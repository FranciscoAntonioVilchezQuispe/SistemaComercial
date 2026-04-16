using Identidad.API.Application.Contratos;
using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Application.Features.Usuarios.CrearUsuario
{
    public record CrearUsuarioCommand : IRequest<IToReturn<long>>
    {
        public string Username { get; set; } = null!;
        public string Email { get; set; } = null!;
        public long IdTrabajador { get; set; }
        public List<long> Roles { get; set; } = new();
    }

    public class CrearUsuarioCommandHandler : IRequestHandler<CrearUsuarioCommand, IToReturn<long>>
    {
        private readonly IUsuarioRepositorio _repoUsuario;
        private readonly ITrabajadorRepositorio _repoTrabajador;
        private readonly IPasswordHasher _passwordHasher;

        public CrearUsuarioCommandHandler(
            IUsuarioRepositorio repoUsuario, 
            ITrabajadorRepositorio repoTrabajador,
            IPasswordHasher passwordHasher)
        {
            _repoUsuario = repoUsuario;
            _repoTrabajador = repoTrabajador;
            _passwordHasher = passwordHasher;
        }

        public async Task<IToReturn<long>> Handle(CrearUsuarioCommand request, CancellationToken cancellationToken)
        {
            // 1. Verificar si el username ya existe
            var existente = await _repoUsuario.ObtenerPorUsernameAsync(request.Username);
            if (existente != null)
                return new ToReturnError<long>("El nombre de usuario ya está en uso.", 400);

            // 2. Verificar existencia del trabajador
            var trabajador = await _repoTrabajador.ObtenerPorIdAsync(request.IdTrabajador);
            if (trabajador == null)
                return new ToReturnError<long>("El trabajador especificado no existe.", 404);

            // 3. Verificar que el trabajador no tenga ya un usuario (Relación 1:1)
            var usuarioTrabajador = await _repoUsuario.ObtenerPorTrabajadorIdAsync(request.IdTrabajador);
            if (usuarioTrabajador != null)
                return new ToReturnError<long>($"El trabajador {trabajador.Nombres} {trabajador.Apellidos} ya tiene un usuario asignado.", 400);

            // Contraseña temporal por defecto
            var passwordTemporal = "Temporal123!";
            var hash = _passwordHasher.HashPassword(passwordTemporal);

            var nuevoUsuario = new Usuario
            {
                Username = request.Username,
                Email = request.Email,
                IdTrabajador = request.IdTrabajador,
                // Sincronizamos nombres y apellidos del trabajador
                Nombres = trabajador.Nombres,
                Apellidos = trabajador.Apellidos,
                PasswordHash = hash,
                FechaCreacion = DateTime.UtcNow,
                UsuariosRoles = request.Roles.Select(idRol => new UsuarioRol { IdRol = idRol }).ToList()
            };

            var usuarioCreado = await _repoUsuario.AgregarAsync(nuevoUsuario);
            return new ToReturn<long>(usuarioCreado.Id);
        }
    }
}
