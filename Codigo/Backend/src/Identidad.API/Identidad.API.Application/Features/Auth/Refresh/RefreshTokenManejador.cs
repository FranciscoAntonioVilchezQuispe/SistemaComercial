using Identidad.API.Application.Contratos;
using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Identidad.API.Application.Features.Auth.Refresh
{
    public class RefreshTokenManejador : IRequestHandler<RefreshTokenComando, IToReturn<Login.LoginRespuesta>>
    {
        private readonly IRefreshTokenRepositorio _refreshTokenRepositorio;
        private readonly ITokenService _tokenService;
        private readonly IUsuarioRepositorio _usuarioRepositorio;
        private readonly IPermisoRepositorio _permisoRepositorio;

        public RefreshTokenManejador(
            IRefreshTokenRepositorio refreshTokenRepositorio, 
            ITokenService tokenService, 
            IUsuarioRepositorio usuarioRepositorio,
            IPermisoRepositorio permisoRepositorio)
        {
            _refreshTokenRepositorio = refreshTokenRepositorio;
            _tokenService = tokenService;
            _usuarioRepositorio = usuarioRepositorio;
            _permisoRepositorio = permisoRepositorio;
        }

        public async Task<IToReturn<Login.LoginRespuesta>> Handle(RefreshTokenComando request, CancellationToken cancellationToken)
        {
            var storedRefreshToken = await _refreshTokenRepositorio.ObtenerPorTokenAsync(request.RefreshToken);

            if (storedRefreshToken == null || !storedRefreshToken.EsActivo)
            {
                return new ToReturnError<Login.LoginRespuesta>("El token proporcionado no es válido o está revocado.", 401);
            }

            var usuario = await _usuarioRepositorio.ObtenerPorIdAsync(storedRefreshToken.UsuarioId);
            if (usuario == null) return new ToReturnError<Login.LoginRespuesta>("Usuario del token no encontrado.", 404);

            storedRefreshToken.EsRevocado = true;
            await _refreshTokenRepositorio.ActualizarAsync(storedRefreshToken);

            var roles = usuario.UsuariosRoles.Select(ur => ur.Rol.NombreRol).ToList();
            var rolIds = usuario.UsuariosRoles.Select(ur => ur.IdRol).ToList();
            
            var permisos = await _permisoRepositorio.ObtenerCodigosPorRolIdsAsync(rolIds);

            var newToken = _tokenService.GenerarTokenJwt(usuario, roles, permisos.ToList());
            var newRefreshTokenString = _tokenService.GenerarRefreshToken();

            var newRefreshToken = new Domain.Entidades.RefreshToken
            {
                Token = newRefreshTokenString,
                UsuarioId = usuario.Id,
                FechaExpiracion = DateTime.UtcNow.AddDays(7),
                FechaCreacion = DateTime.UtcNow,
                EsRevocado = false
            };

            await _refreshTokenRepositorio.AgregarAsync(newRefreshToken);

            var respuesta = new Login.LoginRespuesta
            {
                Token = newToken,
                RefreshToken = newRefreshTokenString,
                Usuario = new Login.UsuarioInfo
                {
                    Id = usuario.Id,
                    Username = usuario.Username,
                    Nombres = usuario.Nombres,
                    Apellidos = usuario.Apellidos,
                    Email = usuario.Email,
                    Roles = string.Join(",", roles)
                }
            };

            return new ToReturn<Login.LoginRespuesta>(respuesta);
        }
    }
}
