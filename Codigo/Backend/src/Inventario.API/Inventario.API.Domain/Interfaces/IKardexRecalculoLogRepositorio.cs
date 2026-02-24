using Inventario.API.Domain.Entidades.Kardex;
using System.Threading.Tasks;

namespace Inventario.API.Domain.Interfaces
{
    public interface IKardexRecalculoLogRepositorio
    {
        Task AgregarAsync(KardexRecalculoLog log);
    }
}
