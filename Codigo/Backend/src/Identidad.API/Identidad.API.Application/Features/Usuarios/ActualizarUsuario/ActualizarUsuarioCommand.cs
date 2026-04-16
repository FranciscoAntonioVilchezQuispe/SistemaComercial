using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Application.Features.Usuarios.ActualizarUsuario
{
    public record ActualizarUsuarioCommand : IRequest<IToReturn<bool>>
    {
        public long Id { get; set; }
        public string Email { get; set; } = null!;
        public string Nombres { get; set; } = null!;
        public string Apellidos { get; set; } = null!;
        public List<long> Roles { get; set; } = new();
    }

    public class ActualizarUsuarioCommandHandler : IRequestHandler<ActualizarUsuarioCommand, IToReturn<bool>>
    {
        private readonly IUsuarioRepositorio _repoUsuario;
        private readonly IUsuarioRolRepositorio _repoUsuarioRol;

        public ActualizarUsuarioCommandHandler(IUsuarioRepositorio repoUsuario, IUsuarioRolRepositorio repoUsuarioRol)
        {
            _repoUsuario = repoUsuario;
            _repoUsuarioRol = repoUsuarioRol;
        }

        public async Task<IToReturn<bool>> Handle(ActualizarUsuarioCommand request, CancellationToken cancellationToken)
        {
            var usuario = await _repoUsuario.ObtenerPorIdAsync(request.Id);
            if (usuario == null)
                return new ToReturnError<bool>("Usuario no encontrado.", 404);

            usuario.Email = request.Email;
            usuario.Nombres = request.Nombres;
            usuario.Apellidos = request.Apellidos;
            usuario.FechaActualizacion = DateTime.UtcNow;

            // Simple sincronización de roles (Borrar y volver a agregar)
            var rolesActuales = await _repoUsuarioRol.ObtenerPorUsuarioAsync(request.Id);
            foreach (var ur in rolesActuales)
            {
                await _repoUsuarioRol.EliminarAsync(ur.Id);
            }

            foreach (var idRol in request.Roles)
            {
                await _repoUsuarioRol.AgregarAsync(new Identidad.API.Domain.Entidades.UsuarioRol 
                { 
                    IdUsuario = request.Id, 
                    IdRol = idRol 
                });
            }

            await _repoUsuario.ActualizarAsync(usuario);
            return new ToReturn<bool>(true);
        }
    }
}
