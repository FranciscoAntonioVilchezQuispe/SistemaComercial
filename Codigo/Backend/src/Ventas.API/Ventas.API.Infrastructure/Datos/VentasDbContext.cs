using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Interfaces;
using System.Reflection;
using Ventas.API.Domain.Entidades;

namespace Ventas.API.Infrastructure.Datos
{
    public class VentasDbContext : DbContext, IVentasDbContext
    {
        public VentasDbContext(DbContextOptions<VentasDbContext> options) : base(options)
        {
        }

        public DbSet<Venta> Ventas { get; set; }
        public DbSet<DetalleVenta> DetallesVenta { get; set; }
        public DbSet<Cotizacion> Cotizaciones { get; set; }
        public DbSet<DetalleCotizacion> DetallesCotizacion { get; set; }
        public DbSet<Caja> Cajas { get; set; }
        public DbSet<MovimientoCaja> MovimientosCaja { get; set; }
        public DbSet<Pago> Pagos { get; set; }
        public DbSet<MetodoPago> MetodosPago { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Ventas.API.Domain.Entidades.Referencias.CatalogoReferencia> Catalogos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("ventas");

            // Re-mapear clientes si es necesario ya que están en otro esquema
            modelBuilder.Entity<Cliente>().ToTable("clientes", "clientes");
            modelBuilder.Entity<ContactoCliente>().ToTable("contactos_cliente", "clientes");
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
