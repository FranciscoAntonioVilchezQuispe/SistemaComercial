using Configuracion.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Nucleo.Comun.Domain.Helpers;

namespace Configuracion.API.Infrastructure.Datos
{
    public class ConfiguracionDbContext : DbContext
    {
        public ConfiguracionDbContext(DbContextOptions<ConfiguracionDbContext> options) : base(options)
        {
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            // Aplicar auditoría centralizada (Estandarización Global)
            DbContextAuditHelper.AplicarAuditoriaDirecta(ChangeTracker);

            return base.SaveChangesAsync(cancellationToken);
        }

        public DbSet<TablaGeneral> TablasGenerales { get; set; }
        public DbSet<TablaGeneralDetalle> TablasGeneralesDetalles { get; set; }
        public DbSet<ParametroConfiguracion> Configuraciones { get; set; }
        public DbSet<Empresa> Empresas { get; set; }
        public DbSet<Sucursal> Sucursales { get; set; }
        public DbSet<Impuesto> Impuestos { get; set; }
        public DbSet<MetodoPago> MetodosPago { get; set; }
        public DbSet<SerieComprobante> SeriesComprobantes { get; set; }
        public DbSet<TipoComprobante> TiposComprobante { get; set; }
        public DbSet<DocumentoIdentidadRegla> DocumentoIdentidadReglas { get; set; }
        public DbSet<DocumentoComprobanteRelacion> DocumentoComprobanteRelaciones { get; set; }
        public DbSet<TipoOperacionSunat> TiposOperacionSunat { get; set; } = null!;
        public DbSet<MatrizReglaSunat> MatrizReglasSunat { get; set; } = null!;
        public DbSet<TipoAfectacionIgv> TiposAfectacionIgv { get; set; } = null!;
        public DbSet<TipoTributo> TiposTributo { get; set; } = null!;
        public DbSet<Ubigeo> Ubigeos { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Esquema por defecto para Configuración
            modelBuilder.HasDefaultSchema("configuracion");

            // Configuración específica para tablas
            modelBuilder.Entity<TablaGeneral>().ToTable("tablas_generales", "configuracion");
            modelBuilder.Entity<TablaGeneralDetalle>().ToTable("tablas_generales_detalle", "configuracion");
            modelBuilder.Entity<ParametroConfiguracion>().ToTable("configuraciones", "configuracion");
            modelBuilder.Entity<Empresa>().ToTable("empresa", "configuracion");
            modelBuilder.Entity<SerieComprobante>().ToTable("series_comprobantes", "configuracion");
            modelBuilder.Entity<TipoComprobante>().ToTable("tipo_comprobante", "configuracion");
            modelBuilder.Entity<Impuesto>().ToTable("impuestos", "configuracion");
            modelBuilder.Entity<Sucursal>().ToTable("sucursales", "configuracion");
            modelBuilder.Entity<MetodoPago>().ToTable("metodos_pago", "configuracion");
            modelBuilder.Entity<DocumentoIdentidadRegla>().ToTable("tipo_documento", "configuracion");
            modelBuilder.Entity<DocumentoComprobanteRelacion>().ToTable("regla_documento_comprobante", "configuracion");
            modelBuilder.Entity<TipoOperacionSunat>().ToTable("tipo_operacion_sunat", "configuracion");
            modelBuilder.Entity<MatrizReglaSunat>().ToTable("matriz_regla_sunat", "configuracion");
            modelBuilder.Entity<TipoAfectacionIgv>().ToTable("tipo_afectacion_igv", "configuracion");
            modelBuilder.Entity<TipoTributo>().ToTable("tipo_tributo", "configuracion");
            modelBuilder.Entity<Ubigeo>().ToTable("ubigeos", "configuracion");

            // Configuración de Relaciones (Fluent API)

            // 1. Serie_comprobante -> Tipo_comprobante
            modelBuilder.Entity<SerieComprobante>()
                .HasOne(s => s.TipoComprobante)
                .WithMany()
                .HasForeignKey(s => s.IdTipoComprobante)
                .OnDelete(DeleteBehavior.Restrict);

            // 2. Regla_documento_comprobante -> Tipo_documento (Por Código)
            modelBuilder.Entity<DocumentoComprobanteRelacion>()
                .HasOne(r => r.TipoDocumento)
                .WithMany()
                .HasPrincipalKey(d => d.Codigo)
                .HasForeignKey(r => r.CodigoDocumento)
                .OnDelete(DeleteBehavior.Restrict);

            // 3. Regla_documento_comprobante -> Tipo_comprobante
            modelBuilder.Entity<DocumentoComprobanteRelacion>()
                .HasOne(r => r.TipoComprobante)
                .WithMany()
                .HasForeignKey(r => r.IdTipoComprobante)
                .OnDelete(DeleteBehavior.Restrict);

            // 4. Sucursal -> Empresa
            modelBuilder.Entity<Sucursal>()
                .HasOne(s => s.Empresa)
                .WithMany()
                .HasForeignKey(s => s.IdEmpresa)
                .OnDelete(DeleteBehavior.Restrict);

            // 5. Ubigeo Recursive
            modelBuilder.Entity<Ubigeo>(e =>
            {
                e.HasKey(x => x.Codigo);
                e.HasOne(x => x.Parent)
                    .WithMany(x => x.Hijos)
                    .HasForeignKey(x => x.ParentId)
                    .OnDelete(DeleteBehavior.Restrict);
            });
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
