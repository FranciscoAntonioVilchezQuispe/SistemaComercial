using Catalogo.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

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

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            foreach (var entry in ChangeTracker.Entries<Nucleo.Comun.Domain.EntidadBase>())
            {
                switch (entry.State)
                {
                    case EntityState.Added:
                        entry.Entity.FechaCreacion = DateTime.UtcNow;
                        entry.Entity.UsuarioCreacion = "API_USER"; // TODO: Integrar con ICurrentUserService
                        entry.Entity.Activado = true;
                        break;

                    case EntityState.Modified:
                        entry.Entity.FechaActualizacion = DateTime.UtcNow;
                        entry.Entity.UsuarioActualizacion = "API_USER";
                        break;

                    case EntityState.Deleted:
                        // Soft Delete logic
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
