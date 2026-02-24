using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Interfaces
{
    public interface IInventarioDbContext
    {
        DbSet<Inventario.API.Domain.Entidades.MovimientoInventario> MovimientosInventario { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncCompra> SyncCompras { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleCompra> SyncDetallesCompra { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncVenta> SyncVentas { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleVenta> SyncDetallesVenta { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncTipoOperacionSunat> SyncTiposOperacionSunat { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncTipoComprobante> SyncTiposComprobante { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncMatrizReglaSunat> SyncMatrizReglasSunat { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Stock> Stocks { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Referencias.TipoMovimientoReferencia> TiposMovimiento { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexMovimiento> KardexMovimientos { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexLote> KardexLotes { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexPeriodoControl> KardexPeriodosControl { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexRecalculoLog> KardexRecalculoLogs { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Traslado> Traslados { get; set; }
        DbSet<Inventario.API.Domain.Entidades.TrasladoDetalle> TrasladosDetalle { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Almacen> Almacenes { get; set; }
        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
