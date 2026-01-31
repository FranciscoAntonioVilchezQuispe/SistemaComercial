using Configuracion.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;

namespace Configuracion.API.Infrastructure.Datos
{
    public class ConfiguracionDbContext : DbContext
    {
        public ConfiguracionDbContext(DbContextOptions<ConfiguracionDbContext> options) : base(options)
        {
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
        }
    }
}
