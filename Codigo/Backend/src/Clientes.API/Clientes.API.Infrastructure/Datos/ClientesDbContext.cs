using Clientes.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Nucleo.Comun.Domain.Helpers;

namespace Clientes.API.Infrastructure.Datos
{
    public class ClientesDbContext : DbContext
    {
        public ClientesDbContext(DbContextOptions<ClientesDbContext> options) : base(options)
        {
        }

        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<ContactoCliente> ContactosCliente { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("clientes");
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
