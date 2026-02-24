using Inventario.API.Domain.Entidades.Kardex;
using System.Threading.Tasks;

namespace Inventario.API.Domain.Interfaces
{
    public interface IKardexPeriodoControlRepositorio
    {
        Task<KardexPeriodoControl?> ObtenerPorPeriodoAsync(string periodo);
        Task AgregarAsync(KardexPeriodoControl periodoControl);
        Task ActualizarAsync(KardexPeriodoControl periodoControl);
        Task<bool> EstaPeriodoCerradoAsync(string periodo);
    }
}
