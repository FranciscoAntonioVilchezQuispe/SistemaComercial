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
        DbSet<Ventas.API.Domain.Entidades.Referencias.SeriesComprobante> SeriesComprobantes { get; set; }
        DbSet<Ventas.API.Domain.Entidades.NotaCredito> NotasCredito { get; set; }
        DbSet<Ventas.API.Domain.Entidades.NotaCreditoDetalle> NotasCreditoDetalles { get; set; }
        DbSet<Ventas.API.Domain.Entidades.NotaDebito> NotasDebito { get; set; }
        DbSet<Ventas.API.Domain.Entidades.NotaDebitoDetalle> NotasDebitoDetalles { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Referencias.TipoComprobanteReferencia> TiposComprobanteRef { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Referencias.ImpuestoReferencia> ImpuestosRef { get; set; }
        DbSet<Ventas.API.Domain.Entidades.LogEnvioCpe> LogsEnvioCpe { get; set; }
        DbSet<Ventas.API.Domain.Entidades.EstadoCpe> EstadosCpe { get; set; }
        DbSet<Ventas.API.Domain.Entidades.VentaCuotaPago> CuotasPago { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Referencias.ReglaDocumentoReferencia> ReglasDocumentoRef { get; set; }
        DbSet<Ventas.API.Domain.Entidades.Referencias.TipoDocumentoReferencia> TiposDocumentoRef { get; set; }
        Microsoft.EntityFrameworkCore.Infrastructure.DatabaseFacade Database { get; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
