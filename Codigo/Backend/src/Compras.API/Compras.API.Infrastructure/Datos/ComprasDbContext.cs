using Compras.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Interfaces;
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

        // Entidades de Referencia para JOINS entre esquemas
        public DbSet<Compras.API.Domain.Entidades.Referencias.TipoDocumentoReferencia> TiposDocumentoRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.TipoComprobanteReferencia> TiposComprobanteRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.AlmacenReferencia> AlmacenesRef { get; set; } = null!;
        public DbSet<Compras.API.Domain.Entidades.Referencias.ProductoReferencia> ProductosRef { get; set; } = null!;
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
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.SerieComprobanteReferencia>().ToTable("series_comprobantes", "configuracion", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Compras.API.Domain.Entidades.Referencias.CatalogoReferencia>().ToTable("tablas_generales_detalle", "configuracion", t => t.ExcludeFromMigrations());

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
