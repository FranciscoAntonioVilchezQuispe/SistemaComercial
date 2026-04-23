using Identidad.API.Application.Contratos;
using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;
using Nucleo.Comun.Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Identidad.API.Application.Features.Auth.Login
{
    public class LoginManejador : IRequestHandler<LoginComando, IToReturn<LoginRespuesta>>
    {
        private readonly IUsuarioRepositorio _usuarioRepositorio;
        private readonly IPasswordHasher _passwordHasher;
        private readonly ITokenService _tokenService;
        private readonly IPermisoRepositorio _permisoRepositorio;
        private readonly IRefreshTokenRepositorio _refreshTokenRepositorio;
        private readonly IRolMenuPermisoRepositorio _rolMenuPermisoRepositorio;

        public LoginManejador(
            IUsuarioRepositorio usuarioRepositorio,
            IPasswordHasher passwordHasher,
            ITokenService tokenService,
            IPermisoRepositorio permisoRepositorio,
            IRefreshTokenRepositorio refreshTokenRepositorio,
            IRolMenuPermisoRepositorio rolMenuPermisoRepositorio)
        {
            _usuarioRepositorio = usuarioRepositorio;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
            _permisoRepositorio = permisoRepositorio;
            _refreshTokenRepositorio = refreshTokenRepositorio;
            _rolMenuPermisoRepositorio = rolMenuPermisoRepositorio;
        }

        public async Task<IToReturn<LoginRespuesta>> Handle(LoginComando request, CancellationToken cancellationToken)
        {
            var usuario = await _usuarioRepositorio.ObtenerPorUsernameAsync(request.Username);

            if (usuario == null || !_passwordHasher.VerifyPassword(request.Password, usuario.PasswordHash))
            {
                return new ToReturnError<LoginRespuesta>("Credenciales incorrectas.", 401);
            }

            usuario.UltimoAcceso = DateTimeHelper.ObtenerAhoraLima(); 
            await _usuarioRepositorio.ActualizarAsync(usuario);

            var roles = usuario.UsuariosRoles.Select(ur => ur.Rol.NombreRol).ToList();
            
            // Obtener permisos en formato granular aplanado: "MENU:PERMISO"
            var permisos = await _rolMenuPermisoRepositorio.ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id);

            var token = _tokenService.GenerarTokenJwt(usuario, roles, permisos.ToList());
            var refreshTokenString = _tokenService.GenerarRefreshToken();

            var refreshToken = new RefreshToken
            {
                Token = refreshTokenString,
                UsuarioId = usuario.Id,
                FechaExpiracion = DateTimeHelper.ObtenerAhoraLima().AddDays(7),
                FechaCreacion = DateTimeHelper.ObtenerAhoraLima(),
                EsRevocado = false
            };

            await _refreshTokenRepositorio.AgregarAsync(refreshToken);

            var respuesta = new LoginRespuesta
            {
                Token = token,
                RefreshToken = refreshTokenString,
                Usuario = new UsuarioInfo
                {
                    Id = usuario.Id,
                    Username = usuario.Username,
                    Nombres = usuario.Nombres,
                    Apellidos = usuario.Apellidos,
                    Email = usuario.Email,
                    Roles = string.Join(",", roles)
                }
            };

            return new ToReturn<LoginRespuesta>(respuesta);
        }
    }
}
