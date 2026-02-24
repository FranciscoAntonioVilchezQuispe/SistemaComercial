using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Entidades.Referencias;
using Microsoft.EntityFrameworkCore;

namespace Inventario.API.Infrastructure.Datos
{
    public class InventarioDbContext : DbContext, IInventarioDbContext
    {
        public InventarioDbContext(DbContextOptions<InventarioDbContext> options) : base(options) { }

        public DbSet<MovimientoInventario> MovimientosInventario { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncCompra> SyncCompras { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleCompra> SyncDetallesCompra { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncVenta> SyncVentas { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleVenta> SyncDetallesVenta { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncTipoOperacionSunat> SyncTiposOperacionSunat { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncTipoComprobante> SyncTiposComprobante { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncMatrizReglaSunat> SyncMatrizReglasSunat { get; set; } = null!;
        public DbSet<Stock> Stocks { get; set; } = null!;
        public DbSet<Almacen> Almacenes { get; set; } = null!;
        public DbSet<TipoMovimientoReferencia> TiposMovimiento { get; set; } = null!;
        public DbSet<KardexMovimiento> KardexMovimientos { get; set; } = null!;
        public DbSet<KardexLote> KardexLotes { get; set; } = null!;
        public DbSet<KardexPeriodoControl> KardexPeriodosControl { get; set; } = null!;
        public DbSet<KardexRecalculoLog> KardexRecalculoLogs { get; set; } = null!;
        public DbSet<Traslado> Traslados { get; set; } = null!;
        public DbSet<TrasladoDetalle> TrasladosDetalle { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("inventario");

            // Configuraciones de Sincronización o tablas compartidas (Solo lectura o ya existentes, excluidas de migraciones)
            modelBuilder.Entity<Stock>(entity =>
            {
                entity.ToTable("stock", "inventario", t => t.ExcludeFromMigrations());
                entity.Ignore(s => s.Activado).Ignore(s => s.FechaCreacion).Ignore(s => s.UsuarioCreacion).Ignore(s => s.FechaActualizacion).Ignore(s => s.UsuarioActualizacion).Ignore(s => s.EventosDominio);
            });

            modelBuilder.Entity<Almacen>(entity =>
            {
                entity.ToTable("almacenes", "inventario", t => t.ExcludeFromMigrations());
                entity.Ignore(e => e.Activado).Ignore(e => e.FechaCreacion).Ignore(e => e.UsuarioCreacion)
                      .Ignore(e => e.FechaActualizacion).Ignore(e => e.UsuarioActualizacion).Ignore(e => e.EventosDominio);
            });

            // MovimientoInventario sí tiene auditoría de creación pero no Activado ni Modificación
            modelBuilder.Entity<MovimientoInventario>().Ignore(m => m.Activado).Ignore(m => m.FechaActualizacion).Ignore(m => m.UsuarioActualizacion).Ignore(m => m.EventosDominio);

            // KardexMovimiento sí tiene todas las columnas de EntidadBase
            modelBuilder.Entity<KardexMovimiento>().Ignore(k => k.EventosDominio);

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncCompra>(entity =>
            {
                entity.ToTable("compras", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.IdCompra);
                entity.Property(e => e.IdCompra).HasColumnName("id_compra");
                entity.Property(e => e.IdAlmacen).HasColumnName("id_almacen");
                entity.Property(e => e.IdTipoComprobante).HasColumnName("id_tipo_comprobante");
                entity.Property(e => e.SerieComprobante).HasColumnName("serie_comprobante");
                entity.Property(e => e.NumeroComprobante).HasColumnName("numero_comprobante");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.HasMany(e => e.Detalles).WithOne(e => e.Compra).HasForeignKey(e => e.IdCompra);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleCompra>(entity =>
            {
                entity.ToTable("detalle_compra", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle_compra");
                entity.Property(e => e.IdCompra).HasColumnName("id_compra");
                entity.Property(e => e.IdProducto).HasColumnName("id_producto");
                entity.Property(e => e.Cantidad).HasColumnName("cantidad");
                entity.Property(e => e.PrecioUnitarioCompra).HasColumnName("precio_unitario_compra");
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncVenta>(entity =>
            {
                entity.ToTable("ventas", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.IdVenta);
                entity.Property(e => e.IdVenta).HasColumnName("id_venta");
                entity.Property(e => e.IdAlmacen).HasColumnName("id_almacen");
                entity.Property(e => e.IdTipoComprobante).HasColumnName("id_tipo_comprobante");
                entity.Property(e => e.Serie).HasColumnName("serie");
                entity.Property(e => e.Numero).HasColumnName("numero");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.HasMany(e => e.Detalles).WithOne(e => e.Venta).HasForeignKey(e => e.IdVenta);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleVenta>(entity =>
            {
                entity.ToTable("detalle_venta", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle_venta");
                entity.Property(e => e.IdVenta).HasColumnName("id_venta");
                entity.Property(e => e.IdProducto).HasColumnName("id_producto");
                entity.Property(e => e.Cantidad).HasColumnName("cantidad");
                entity.Property(e => e.PrecioUnitario).HasColumnName("precio_unitario");
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncTipoOperacionSunat>(entity =>
            {
                entity.ToTable("tipo_operacion_sunat", "configuracion", t => t.ExcludeFromMigrations());
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncMatrizReglaSunat>(entity =>
            {
                entity.ToTable("matriz_regla_sunat", "configuracion", t => t.ExcludeFromMigrations());
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncTipoComprobante>(entity =>
            {
                entity.ToTable("tipo_comprobante", "configuracion", t => t.ExcludeFromMigrations());
            });

            modelBuilder.Entity<KardexMovimiento>()
                .HasIndex(k => new { k.Periodo, k.AlmacenId, k.ProductoId }, "idx_periodo_almacen_prod");

            modelBuilder.Entity<KardexMovimiento>()
                .HasIndex(k => new { k.FechaMovimiento, k.HoraMovimiento }, "idx_fecha_hora");

            modelBuilder.Entity<KardexMovimiento>()
                .HasIndex(k => new { k.TipoDocumento, k.SerieDocumento, k.NumeroDocumento }, "idx_documento");

            modelBuilder.Entity<KardexMovimiento>()
                .HasIndex(k => new { k.ReferenciaId, k.ReferenciaTipo }, "idx_referencia");

            // Configuración de Traslados
            modelBuilder.Entity<Traslado>(entity =>
            {
                entity.ToTable("traslados", "inventario");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.NumeroTraslado).IsRequired().HasMaxLength(20);
                entity.HasIndex(e => e.NumeroTraslado).IsUnique();
                entity.Ignore(e => e.Activado).Ignore(e => e.FechaCreacion).Ignore(e => e.UsuarioCreacion)
                      .Ignore(e => e.FechaActualizacion).Ignore(e => e.UsuarioActualizacion).Ignore(e => e.EventosDominio);
            });

            modelBuilder.Entity<TrasladoDetalle>(entity =>
            {
                entity.ToTable("traslados_detalle", "inventario");
                entity.HasKey(e => e.Id);
                entity.HasOne(d => d.Traslado)
                    .WithMany(t => t.Detalles)
                    .HasForeignKey(d => d.TrasladoId)
                    .OnDelete(DeleteBehavior.Cascade);
            });
        }
    }
}
