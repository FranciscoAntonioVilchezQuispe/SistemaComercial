using Ventas.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Ventas.API.Domain.Interfaces
{
    public interface ICajaRepositorio
    {
        Task<Caja?> ObtenerPorIdAsync(long id);
        Task<Caja> AgregarAsync(Caja caja);
        Task ActualizarAsync(Caja caja);
        Task<IEnumerable<Caja>> ObtenerTodasAsync();
    }
}
