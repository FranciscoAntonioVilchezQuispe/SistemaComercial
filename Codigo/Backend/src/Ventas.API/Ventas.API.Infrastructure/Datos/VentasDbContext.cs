using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Interfaces;
using System.Reflection;
using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Entidades.Referencias;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace Ventas.API.Infrastructure.Datos
{
    public class VentasDbContext : DbContext, IVentasDbContext
    {
        public VentasDbContext(DbContextOptions<VentasDbContext> options) : base(options)
        {
        }

        public DbSet<Venta> Ventas { get; set; }
        public DbSet<DetalleVenta> DetallesVenta { get; set; }
        public DbSet<Cotizacion> Cotizaciones { get; set; }
        public DbSet<DetalleCotizacion> DetallesCotizacion { get; set; }
        public DbSet<Caja> Cajas { get; set; }
        public DbSet<MovimientoCaja> MovimientosCaja { get; set; }
        public DbSet<Pago> Pagos { get; set; }
        public DbSet<MetodoPago> MetodosPago { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Ventas.API.Domain.Entidades.Referencias.CatalogoReferencia> Catalogos { get; set; }
        public DbSet<SeriesComprobante> SeriesComprobantes { get; set; } = null!;
        public DbSet<NotaCredito> NotasCredito { get; set; } = null!;
        public DbSet<NotaCreditoDetalle> NotasCreditoDetalles { get; set; } = null!;
        public DbSet<NotaDebito> NotasDebito { get; set; } = null!;
        public DbSet<NotaDebitoDetalle> NotasDebitoDetalles { get; set; } = null!;
        public DbSet<Ventas.API.Domain.Entidades.Referencias.TipoComprobanteReferencia> TiposComprobanteRef { get; set; } = null!;
        public DbSet<Ventas.API.Domain.Entidades.Referencias.ImpuestoReferencia> ImpuestosRef { get; set; } = null!;
        public DbSet<LogEnvioCpe> LogsEnvioCpe { get; set; } = null!;
        public DbSet<EstadoCpe> EstadosCpe { get; set; } = null!;
        public DbSet<VentaCuotaPago> CuotasPago { get; set; } = null!;
        public DbSet<Ventas.API.Domain.Entidades.Referencias.ReglaDocumentoReferencia> ReglasDocumentoRef { get; set; } = null!;
        public DbSet<Ventas.API.Domain.Entidades.Referencias.TipoDocumentoReferencia> TiposDocumentoRef { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("ventas");

            // Re-mapear clientes si es necesario ya que están en otro esquema
            modelBuilder.Entity<Cliente>().ToTable("clientes", "clientes");
            modelBuilder.Entity<ContactoCliente>().ToTable("contactos_cliente", "clientes");
            modelBuilder.Entity<MetodoPago>().ToTable("metodos_pago", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Ventas.API.Domain.Entidades.Referencias.TipoComprobanteReferencia>().ToTable("tipo_comprobante", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Ventas.API.Domain.Entidades.Referencias.ImpuestoReferencia>().ToTable("impuestos", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Ventas.API.Domain.Entidades.Referencias.ReglaDocumentoReferencia>().ToTable("regla_documento_comprobante", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Ventas.API.Domain.Entidades.Referencias.TipoDocumentoReferencia>().ToTable("tipo_documento", "configuracion", t => t.ExcludeFromMigrations());
            
            // Tablas SUNAT
            modelBuilder.Entity<EstadoCpe>().ToTable("cat_estado_cpe", "sunat", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<LogEnvioCpe>().ToTable("log_envio_cpe", "sunat");
            modelBuilder.Entity<VentaCuotaPago>().ToTable("venta_cuota_pago", "ventas");
        }

        protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
        {
            // Convierte todos los DateTime a UTC al guardar en la base de datos
            configurationBuilder
                .Properties<DateTime>()
                .HaveConversion(typeof(DateTimeToUtcConverter));

            configurationBuilder
                .Properties<DateTime?>()
                .HaveConversion(typeof(NullableDateTimeToUtcConverter));
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            var entries = ChangeTracker.Entries()
                .Where(e => e.State == EntityState.Added || e.State == EntityState.Modified);

            foreach (var entry in entries)
            {
                // 1. Normalización de auditoría para EntidadBase
                if (entry.Entity is Nucleo.Comun.Domain.EntidadBase baseEntity)
                {
                    if (entry.State == EntityState.Added)
                    {
                        baseEntity.FechaCreacion = DateTime.UtcNow;
                        baseEntity.UsuarioCreacion = string.IsNullOrEmpty(baseEntity.UsuarioCreacion) ? "SISTEMA" : baseEntity.UsuarioCreacion;
                        baseEntity.Activado = true;
                    }
                    else
                    {
                        baseEntity.FechaActualizacion = DateTime.UtcNow;
                        baseEntity.UsuarioActualizacion = "SISTEMA";
                    }
                }
            }

            return base.SaveChangesAsync(cancellationToken);
        }
    }

    // Convertidores para asegurar DateTimeKind.Utc
    public class DateTimeToUtcConverter : ValueConverter<DateTime, DateTime>
    {
        public DateTimeToUtcConverter()
            : base(v => v.Kind == DateTimeKind.Utc ? v : DateTime.SpecifyKind(v, DateTimeKind.Utc), v => v)
        {
        }
    }

    public class NullableDateTimeToUtcConverter : ValueConverter<DateTime?, DateTime?>
    {
        public NullableDateTimeToUtcConverter()
            : base(v => !v.HasValue ? v : (v.Value.Kind == DateTimeKind.Utc ? v : DateTime.SpecifyKind(v.Value, DateTimeKind.Utc)), v => v)
        {
        }
    }
}
