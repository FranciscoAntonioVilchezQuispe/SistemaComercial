using Compras.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Interfaces;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using System.Reflection;

namespace Compras.API.Infrastructure.Datos
{
    public class ComprasDbContext : DbContext, IComprasDbContext
    {
        public ComprasDbContext(DbContextOptions<ComprasDbContext> options) : base(options)
        {
        }

        public DbSet<Compra> Compras { get; set; }
        public DbSet<DetalleCompra> DetallesCompra { get; set; }
        public DbSet<OrdenCompra> OrdenesCompra { get; set; }
        public DbSet<DetalleOrdenCompra> DetallesOrdenCompra { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Compras.API.Domain.Entidades.Referencias.CatalogoReferencia> Catalogos { get; set; }
        public DbSet<Nota> Notas { get; set; } = null!;
        public DbSet<DetalleNota> DetallesNota { get; set; } = null!;
        public DbSet<NotaCreditoCompra> NotasCredito { get; set; } = null!;
        public DbSet<NotaCreditoDetalleCompra> NotasCreditoDetalles { get; set; } = null!;
        public DbSet<NotaDebitoCompra> NotasDebito { get; set; } = null!;
        public DbSet<NotaDebitoDetalleCompra> NotasDebitoDetalles { get; set; } = null!;

        // Entidades de Referencia para JOINS entre esquemas
        public DbSet<Compras.API.Domain.Entidades.Referencias.TipoDocumentoReferencia> TiposDocumentoRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.TipoComprobanteReferencia> TiposComprobanteRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.AlmacenReferencia> AlmacenesRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.ProductoReferencia> ProductosRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Maestros.UnidadMedida> UnidadesMedidaRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.SerieComprobanteReferencia> SeriesComprobantesRef { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("compras");

            // Configurar Entidades de Referencia como de solo lectura (Exclude from Migrations)
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.TipoDocumentoReferencia>().ToTable("tipo_documento", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.TipoComprobanteReferencia>().ToTable("tipo_comprobante", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.AlmacenReferencia>().ToTable("almacenes", "inventario", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.ProductoReferencia>().ToTable("productos", "catalogo", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Maestros.UnidadMedida>().ToTable("unidades_medida", "catalogo", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.SerieComprobanteReferencia>().ToTable("series_comprobantes", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.CatalogoReferencia>().ToTable("tablas_generales_detalle", "configuracion", t => t.ExcludeFromMigrations());

            modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
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
                // 1. Auditoría para EntidadBase
                if (entry.Entity is Nucleo.Comun.Domain.EntidadBase baseEntity)
                {
                    if (entry.State == EntityState.Added)
                    {
                        baseEntity.FechaCreacion = DateTime.UtcNow;
                        baseEntity.UsuarioCreacion = "API_USER";
                        baseEntity.Activado = true;
                    }
                    else
                    {
                        baseEntity.FechaActualizacion = DateTime.UtcNow;
                        baseEntity.UsuarioActualizacion = "API_USER";
                    }
                }
            }
            return base.SaveChangesAsync(cancellationToken);
        }

        public System.Data.Common.DbConnection GetDbConnection() => Database.GetDbConnection();
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
