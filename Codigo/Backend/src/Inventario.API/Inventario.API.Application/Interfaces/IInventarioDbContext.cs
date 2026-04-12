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
        
        // Notas de Compras
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoCompra> SyncNotaCreditoCompras { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoCompra> SyncDetalleNotaCreditoCompras { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoCompra> SyncNotaDebitoCompras { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoCompra> SyncDetalleNotaDebitoCompras { get; set; }

        // Notas de Ventas
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoVenta> SyncNotaCreditoVentas { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoVenta> SyncDetalleNotaCreditoVentas { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoVenta> SyncNotaDebitoVentas { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoVenta> SyncDetalleNotaDebitoVentas { get; set; }

        DbSet<Inventario.API.Domain.Entidades.Stock> Stocks { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Referencias.TipoMovimientoReferencia> TiposMovimiento { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexMovimiento> KardexMovimientos { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexLote> KardexLotes { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexPeriodoControl> KardexPeriodosControl { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Kardex.KardexRecalculoLog> KardexRecalculoLogs { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Traslado> Traslados { get; set; }
        DbSet<Inventario.API.Domain.Entidades.TrasladoDetalle> TrasladosDetalle { get; set; }
        DbSet<Inventario.API.Domain.Entidades.Almacen> Almacenes { get; set; }
        System.Data.IDbConnection GetDbConnection();
        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
