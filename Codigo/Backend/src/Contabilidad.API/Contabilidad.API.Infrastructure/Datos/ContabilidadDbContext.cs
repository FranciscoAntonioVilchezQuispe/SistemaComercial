using Contabilidad.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Nucleo.Comun.Domain.Helpers;

namespace Contabilidad.API.Infrastructure.Datos
{
    public class ContabilidadDbContext : DbContext
    {
        public ContabilidadDbContext(DbContextOptions<ContabilidadDbContext> options) : base(options)
        {
        }

        public DbSet<PlanCuenta> PlanCuentas { get; set; }
        public DbSet<CentroCosto> CentrosCosto { get; set; }
        public DbSet<AsientoContable> AsientosContables { get; set; }
        public DbSet<DetalleAsiento> DetallesAsiento { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("contabilidad");
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
            // Aplicar auditoría centralizada (Estandarización Global)
            DbContextAuditHelper.AplicarAuditoriaDirecta(ChangeTracker, "API_USER");

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
