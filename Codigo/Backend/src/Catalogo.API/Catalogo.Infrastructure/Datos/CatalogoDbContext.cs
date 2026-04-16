using Catalogo.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using System.Reflection;
using Nucleo.Comun.Domain.Helpers;

namespace Catalogo.Infrastructure.Datos
{
    public class CatalogoDbContext : DbContext
    {
        public CatalogoDbContext(DbContextOptions<CatalogoDbContext> options) : base(options)
        {
        }

        public DbSet<Producto> Productos { get; set; } = null!;
        public DbSet<Categoria> Categorias { get; set; } = null!;
        public DbSet<Marca> Marcas { get; set; } = null!;
        public DbSet<UnidadMedida> UnidadesMedida { get; set; } = null!;
        public DbSet<ListaPrecio> ListasPrecios { get; set; } = null!;
        public DbSet<ImagenProducto> ImagenesProducto { get; set; } = null!;
        public DbSet<VarianteProducto> VariantesProducto { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Definir esquema del microservicio
            modelBuilder.HasDefaultSchema("catalogo");

            // Aplicar configuraciones de la carpeta actual (Configuraciones)
            // Aplicar configuraciones de la carpeta actual (Configuraciones)
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
            // Aplicar auditoría centralizada con Soft Delete (Estandarización Global)
            DbContextAuditHelper.AplicarAuditoriaDirecta(ChangeTracker, "API_USER", true);

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
