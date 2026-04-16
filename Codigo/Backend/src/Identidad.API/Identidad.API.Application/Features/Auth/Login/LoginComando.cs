using MediatR;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Application.Features.Auth.Login
{
    public class LoginRespuesta
    {
        public string Token { get; set; } = null!;
        public string RefreshToken { get; set; } = null!;
        public UsuarioInfo Usuario { get; set; } = null!;
    }

    public class UsuarioInfo
    {
        public long Id { get; set; }
        public string Username { get; set; } = null!;
        public string Nombres { get; set; } = null!;
        public string Apellidos { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Roles { get; set; } = null!;
    }

    public class LoginComando : IRequest<IToReturn<LoginRespuesta>>
    {
        public string Username { get; set; } = null!;
        public string Password { get; set; } = null!;
    }
}
