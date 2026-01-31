using Microsoft.EntityFrameworkCore;

namespace Ventas.API.Application.Interfaces
{
    public interface IVentasDbContext
    {
        DbSet<Ventas.API.Domain.Entidades.Venta> Ventas { get; set; }
        DbSet<Ventas.API.Domain.Entidades.DetalleVenta> DetallesVenta { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Cotizacion> Cotizaciones { get; set; }
        DbSet<Ventas.API.Domain.Entidades.DetalleCotizacion> DetallesCotizacion { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Caja> Cajas { get; set; }
        DbSet<Ventas.API.Domain.Entidades.MovimientoCaja> MovimientosCaja { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Pago> Pagos { get; set; }
        DbSet<Ventas.API.Domain.Entidades.MetodoPago> MetodosPago { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Cliente> Clientes { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Referencias.CatalogoReferencia> Catalogos { get; set; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
