using Identidad.API.Domain.Entidades;
using System.Collections.Generic;

namespace Identidad.API.Application.Contratos
{
    public interface ITokenService
    {
        string GenerarTokenJwt(Usuario usuario, List<string> roles, List<string> permisos);
        string GenerarRefreshToken();
    }
}
