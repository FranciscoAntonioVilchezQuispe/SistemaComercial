using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Interfaces
{
    public interface IInventarioDbContext
    {
        DbSet<Inventario.API.Domain.Entidades.MovimientoInventario> MovimientosInventario { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Stock> Stocks { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Referencias.TipoMovimientoReferencia> TiposMovimiento { get; set; }
        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
