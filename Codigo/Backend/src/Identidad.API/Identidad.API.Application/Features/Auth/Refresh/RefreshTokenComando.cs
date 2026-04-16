using MediatR;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Application.Features.Auth.Refresh
{
    public class RefreshTokenComando : IRequest<IToReturn<Login.LoginRespuesta>>
    {
        public string Token { get; set; } = null!;
        public string RefreshToken { get; set; } = null!;
    }
}
