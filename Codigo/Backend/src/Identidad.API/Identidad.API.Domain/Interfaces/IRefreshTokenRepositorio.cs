using Identidad.API.Domain.Entidades;
using System.Threading.Tasks;

namespace Identidad.API.Domain.Interfaces
{
    public interface IRefreshTokenRepositorio
    {
        Task<RefreshToken?> ObtenerPorTokenAsync(string token);
        Task AgregarAsync(RefreshToken refreshToken);
        Task ActualizarAsync(RefreshToken refreshToken);
    }
}
