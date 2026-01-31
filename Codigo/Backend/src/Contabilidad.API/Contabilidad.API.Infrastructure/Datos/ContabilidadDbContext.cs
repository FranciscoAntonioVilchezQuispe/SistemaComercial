using Contabilidad.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;

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

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            foreach (var entry in ChangeTracker.Entries<Nucleo.Comun.Domain.EntidadBase>())
            {
                switch (entry.State)
                {
                    case EntityState.Added:
                        entry.Entity.FechaCreacion = DateTime.UtcNow;
                        entry.Entity.UsuarioCreacion = "API_USER";
                        entry.Entity.Activado = true;
                        break;
                    case EntityState.Modified:
                        entry.Entity.FechaActualizacion = DateTime.UtcNow;
                        entry.Entity.UsuarioActualizacion = "API_USER";
                        break;
                }
            }
            return base.SaveChangesAsync(cancellationToken);
        }
    }
}
