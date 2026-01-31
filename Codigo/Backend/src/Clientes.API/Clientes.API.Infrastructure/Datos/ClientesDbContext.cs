using Clientes.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

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
                    case EntityState.Deleted:
                        entry.State = EntityState.Modified;
                        entry.Entity.Activado = false;
                        entry.Entity.FechaActualizacion = DateTime.UtcNow;
                        entry.Entity.UsuarioActualizacion = "API_USER";
                        break;
                }
            }
            return base.SaveChangesAsync(cancellationToken);
        }
    }
}
