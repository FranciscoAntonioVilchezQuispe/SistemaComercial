using Contabilidad.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Contabilidad.API.Domain.Interfaces
{
    public interface IPlanCuentaRepositorio
    {
        Task<PlanCuenta?> ObtenerPorIdAsync(long id);
        Task<PlanCuenta> AgregarAsync(PlanCuenta cuenta);
        Task ActualizarAsync(PlanCuenta cuenta);
        Task<IEnumerable<PlanCuenta>> ObtenerTodasAsync();
        Task<IEnumerable<PlanCuenta>> ObtenerPorNivelAsync(int nivel);
    }

    public interface ICentroCostoRepositorio
    {
        Task<CentroCosto?> ObtenerPorIdAsync(long id);
        Task<CentroCosto> AgregarAsync(CentroCosto centro);
        Task ActualizarAsync(CentroCosto centro);
        Task<IEnumerable<CentroCosto>> ObtenerTodosAsync();
    }
}
