using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Entidades.Referencias;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

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
        
        // Notas de Compras
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoCompra> SyncNotaCreditoCompras { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoCompra> SyncDetalleNotaCreditoCompras { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoCompra> SyncNotaDebitoCompras { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoCompra> SyncDetalleNotaDebitoCompras { get; set; } = null!;

        // Notas de Ventas
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoVenta> SyncNotaCreditoVentas { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoVenta> SyncDetalleNotaCreditoVentas { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoVenta> SyncNotaDebitoVentas { get; set; } = null!;
        public DbSet<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoVenta> SyncDetalleNotaDebitoVentas { get; set; } = null!;

        public DbSet<Stock> Stocks { get; set; } = null!;
        public DbSet<Almacen> Almacenes { get; set; } = null!;
        public DbSet<TipoMovimientoReferencia> TiposMovimiento { get; set; } = null!;
        public DbSet<KardexMovimiento> KardexMovimientos { get; set; } = null!;
        public DbSet<KardexLote> KardexLotes { get; set; } = null!;
        public DbSet<KardexPeriodoControl> KardexPeriodosControl { get; set; } = null!;
        public DbSet<KardexRecalculoLog> KardexRecalculoLogs { get; set; } = null!;
        public DbSet<Traslado> Traslados { get; set; } = null!;
        public DbSet<TrasladoDetalle> TrasladosDetalle { get; set; } = null!;

        public System.Data.IDbConnection GetDbConnection() => Database.GetDbConnection();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.HasDefaultSchema("inventario");

            // Configuraciones de Sincronización o tablas compartidas (Solo lectura o ya existentes, excluidas de migraciones)
            modelBuilder.Entity<Stock>(entity =>
            {
                entity.ToTable("stock", "inventario", t => t.ExcludeFromMigrations());
                // No se ignora FechaActualizacion ni UsuarioActualizacion porque sí existen en la base de datos (fecha_modificacion/usuario_modificacion)
                entity.Ignore(s => s.Activado).Ignore(s => s.FechaCreacion).Ignore(s => s.UsuarioCreacion).Ignore(s => s.EventosDominio);
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

            // Mapeos de Notas de Compras (NC/ND)
            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoCompra>(entity =>
            {
                entity.ToTable("nota_credito", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_nota");
                entity.Property(e => e.Serie).HasColumnName("serie");
                entity.Property(e => e.Numero).HasColumnName("numero");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.Property(e => e.IdProveedor).HasColumnName("id_proveedor");
                entity.Property(e => e.Total).HasColumnName("total");
                entity.Property(e => e.IdCompraReferencia).HasColumnName("id_compra_referencia");
                entity.Property(e => e.AfectaStock).HasColumnName("afecta_stock");
                entity.Ignore(e => e.IdAlmacen);
                entity.HasOne(e => e.Compra).WithMany().HasForeignKey(e => e.IdCompraReferencia);
                entity.HasMany(e => e.Detalles).WithOne(e => e.Nota).HasForeignKey(e => e.IdNota);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoCompra>(entity =>
            {
                entity.ToTable("nota_credito_detalle", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle");
                entity.Property(e => e.IdNota).HasColumnName("id_nota_credito");
                entity.Property(e => e.IdProducto).HasColumnName("id_producto");
                entity.Property(e => e.Cantidad).HasColumnName("cantidad");
                entity.Property(e => e.PrecioUnitario).HasColumnName("precio_unitario");
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoCompra>(entity =>
            {
                entity.ToTable("nota_debito", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_nota");
                entity.Property(e => e.Serie).HasColumnName("serie");
                entity.Property(e => e.Numero).HasColumnName("numero");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.Property(e => e.IdProveedor).HasColumnName("id_proveedor");
                entity.Property(e => e.Total).HasColumnName("total");
                entity.Property(e => e.IdCompraReferencia).HasColumnName("id_compra_referencia");
                entity.Property(e => e.AfectaStock).HasColumnName("afecta_stock");
                entity.Ignore(e => e.IdAlmacen);
                entity.HasOne(e => e.Compra).WithMany().HasForeignKey(e => e.IdCompraReferencia);
                entity.HasMany(e => e.Detalles).WithOne(e => e.Nota).HasForeignKey(e => e.IdNota);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoCompra>(entity =>
            {
                entity.ToTable("nota_debito_detalle", "compras", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle");
                entity.Property(e => e.IdNota).HasColumnName("id_nota_debito");
                entity.Property(e => e.IdProducto).HasColumnName("id_producto");
                entity.Property(e => e.Cantidad).HasColumnName("cantidad");
                entity.Property(e => e.PrecioUnitario).HasColumnName("precio_unitario");
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

            // Mapeos de Notas de Ventas (NC/ND)
            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncNotaCreditoVenta>(entity =>
            {
                entity.ToTable("nota_credito", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_nota");
                entity.Property(e => e.Serie).HasColumnName("serie");
                entity.Property(e => e.Numero).HasColumnName("numero");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.Property(e => e.Total).HasColumnName("total");
                entity.Property(e => e.IdVentaReferencia).HasColumnName("id_venta_referencia");
                entity.Property(e => e.AfectaStock).HasColumnName("afecta_stock");
                entity.Ignore(e => e.IdAlmacen);
                entity.HasOne(e => e.Venta).WithMany().HasForeignKey(e => e.IdVentaReferencia);
                entity.HasMany(e => e.Detalles).WithOne(e => e.Nota).HasForeignKey(e => e.IdNota);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaCreditoVenta>(entity =>
            {
                entity.ToTable("nota_credito_detalle", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle");
                entity.Property(e => e.IdNota).HasColumnName("id_nota_credito");
                entity.Property(e => e.IdProducto).HasColumnName("id_producto");
                entity.Property(e => e.Cantidad).HasColumnName("cantidad");
                entity.Property(e => e.PrecioUnitario).HasColumnName("precio_unitario");
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncNotaDebitoVenta>(entity =>
            {
                entity.ToTable("nota_debito", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_nota");
                entity.Property(e => e.Serie).HasColumnName("serie");
                entity.Property(e => e.Numero).HasColumnName("numero");
                entity.Property(e => e.FechaEmision).HasColumnName("fecha_emision");
                entity.Property(e => e.Total).HasColumnName("total");
                entity.Property(e => e.IdVentaReferencia).HasColumnName("id_venta_referencia");
                entity.Property(e => e.AfectaStock).HasColumnName("afecta_stock");
                entity.Ignore(e => e.IdAlmacen);
                entity.HasOne(e => e.Venta).WithMany().HasForeignKey(e => e.IdVentaReferencia);
                entity.HasMany(e => e.Detalles).WithOne(e => e.Nota).HasForeignKey(e => e.IdNota);
            });

            modelBuilder.Entity<Inventario.API.Domain.Entidades.Integracion.SyncDetalleNotaDebitoVenta>(entity =>
            {
                entity.ToTable("nota_debito_detalle", "ventas", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_detalle");
                entity.Property(e => e.IdNota).HasColumnName("id_nota_debito");
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
                entity.Property(e => e.MueveStock).HasColumnName("mueve_stock");
                entity.Property(e => e.TipoMovimientoStock).HasColumnName("tipo_movimiento_stock");
                entity.Property(e => e.MovimientoStockVenta).HasColumnName("movimiento_stock_venta");
                entity.Property(e => e.MovimientoStockCompra).HasColumnName("movimiento_stock_compra");
            });

            // Apuntar TiposMovimiento a la nueva tabla inventario.tipos_movimiento
            modelBuilder.Entity<TipoMovimientoReferencia>(entity =>
            {
                entity.ToTable("tipos_movimiento", "inventario", t => t.ExcludeFromMigrations());
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id_tipo_movimiento");
                entity.Property(e => e.Factor).HasColumnName("factor");
                entity.Property(e => e.MueveStock).HasColumnName("mueve_stock");
                entity.Ignore(e => e.IdTabla); // No existe en la nueva tabla
            });

            modelBuilder.Entity<KardexMovimiento>(entity =>
            {
                entity.ToTable("inv_kardex_movimiento", "inventario");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Uuid).HasColumnName("uuid").IsRequired().HasMaxLength(36);
                entity.Property(e => e.Periodo).HasColumnName("periodo").IsRequired().HasMaxLength(7);
                entity.Property(e => e.CorrelativoKardex).HasColumnName("correlativo_kardex");
                entity.Property(e => e.FechaMovimiento).HasColumnName("fecha_movimiento").HasColumnType("date");
                entity.Property(e => e.HoraMovimiento).HasColumnName("hora_movimiento").HasColumnType("time");
                entity.Property(e => e.FechaHoraCompuesta).HasColumnName("fecha_hora_compuesta");
                entity.Property(e => e.ModuloOrigen).HasColumnName("modulo_origen").IsRequired().HasMaxLength(30);
                entity.Property(e => e.TipoDocumento).HasColumnName("tipo_documento").IsRequired().HasMaxLength(2);
                entity.Property(e => e.SerieDocumento).HasColumnName("serie_documento").IsRequired().HasMaxLength(10);
                entity.Property(e => e.NumeroDocumento).HasColumnName("numero_documento").IsRequired().HasMaxLength(20);
                entity.Property(e => e.TipoOperacion).HasColumnName("tipo_operacion").IsRequired().HasMaxLength(10);
                entity.Property(e => e.MotivoTrasladoSunat).HasColumnName("motivo_traslado_sunat").IsRequired().HasMaxLength(4);
                entity.Property(e => e.DescripcionMovimiento).HasColumnName("descripcion_movimiento").IsRequired().HasMaxLength(255);
                entity.Property(e => e.AlmacenId).HasColumnName("almacen_id");
                entity.Property(e => e.AlmacenOrigenId).HasColumnName("almacen_origen_id");
                entity.Property(e => e.AlmacenDestinoId).HasColumnName("almacen_destino_id");
                entity.Property(e => e.ProductoId).HasColumnName("producto_id");
                entity.Property(e => e.UnidadMedidaCodigo).HasColumnName("unidad_medida_codigo").IsRequired().HasMaxLength(10);
                entity.Property(e => e.FactorConversion).HasColumnName("factor_conversion");
                entity.Property(e => e.EntradaCantidad).HasColumnName("entrada_cantidad");
                entity.Property(e => e.EntradaCostoUnitario).HasColumnName("entrada_costo_unitario");
                entity.Property(e => e.EntradaCostoTotal).HasColumnName("entrada_costo_total");
                entity.Property(e => e.SalidaCantidad).HasColumnName("salida_cantidad");
                entity.Property(e => e.SalidaCostoUnitario).HasColumnName("salida_costo_unitario");
                entity.Property(e => e.SalidaCostoTotal).HasColumnName("salida_costo_total");
                entity.Property(e => e.SaldoCantidad).HasColumnName("saldo_cantidad");
                entity.Property(e => e.SaldoCostoUnitario).HasColumnName("saldo_costo_unitario");
                entity.Property(e => e.SaldoCostoTotal).HasColumnName("saldo_costo_total");
                entity.Property(e => e.ReferenciaId).HasColumnName("referencia_id");
                entity.Property(e => e.ReferenciaTipo).HasColumnName("referencia_tipo").HasMaxLength(50);
                entity.Property(e => e.LoteId).HasColumnName("lote_id");
                entity.Property(e => e.ProveedorClienteId).HasColumnName("proveedor_cliente_id");
                entity.Property(e => e.Observaciones).HasColumnName("observaciones").HasColumnType("text");
                entity.Property(e => e.UsuarioRegistroId).HasColumnName("usuario_registro_id");
                entity.Property(e => e.UsuarioAnulacionId).HasColumnName("usuario_anulacion_id");
                entity.Property(e => e.RecalculadoAt).HasColumnName("recalculado_at");

                entity.HasIndex(k => new { k.Periodo, k.AlmacenId, k.ProductoId }, "idx_periodo_almacen_prod");
                entity.HasIndex(k => new { k.FechaMovimiento, k.HoraMovimiento }, "idx_fecha_hora");
                entity.HasIndex(k => new { k.TipoDocumento, k.SerieDocumento, k.NumeroDocumento }, "idx_documento");
                entity.HasIndex(k => new { k.ReferenciaId, k.ReferenciaTipo }, "idx_referencia");
            });

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
