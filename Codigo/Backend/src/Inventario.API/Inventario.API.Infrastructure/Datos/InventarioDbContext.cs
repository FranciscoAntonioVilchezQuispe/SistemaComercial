using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Entidades.Referencias;
using Microsoft.EntityFrameworkCore;

namespace Inventario.API.Infrastructure.Datos
{
    public class InventarioDbContext : DbContext, IInventarioDbContext
    {
        public InventarioDbContext(DbContextOptions<InventarioDbContext> options) : base(options) { }

        public DbSet<MovimientoInventario> MovimientosInventario { get; set; } = null!;
        public DbSet<Stock> Stocks { get; set; } = null!;
        public DbSet<Almacen> Almacenes { get; set; } = null!;
        public DbSet<TipoMovimientoReferencia> TiposMovimiento { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("inventario");
        }
    }
}
