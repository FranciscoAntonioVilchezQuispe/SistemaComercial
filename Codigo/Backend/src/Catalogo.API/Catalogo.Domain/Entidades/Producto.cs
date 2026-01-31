using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Catalogo.Domain.Entidades
{
    [Table("productos", Schema = "catalogo")]
    public class Producto : EntidadBase
    {
        [Column("id_producto")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("codigo_producto")]
        public string CodigoProducto { get; set; } = null!;

        [MaxLength(100)]
        [Column("codigo_barras")]
        public string? CodigoBarras { get; set; }

        [MaxLength(100)]
        [Column("sku")]
        public string? Sku { get; set; }

        [Required]
        [MaxLength(255)]
        [Column("nombre_producto")]
        public string NombreProducto { get; set; } = null!;

        [Column("descripcion", TypeName = "text")]
        public string? Descripcion { get; set; }

        [Column("id_categoria")]
        public long IdCategoria { get; set; }

        [Column("id_marca")]
        public long IdMarca { get; set; }

        [Column("id_unidad")]
        public long IdUnidadMedida { get; set; }

        [Column("tiene_variantes")]
        public bool TieneVariantes { get; set; }

        // Precios
        [Column("precio_compra", TypeName = "decimal(12,2)")]
        public decimal PrecioCompra { get; set; }

        [Column("precio_venta_publico", TypeName = "decimal(12,2)")]
        public decimal PrecioVentaPublico { get; set; }

        [Column("precio_venta_mayorista", TypeName = "decimal(12,2)")]
        public decimal PrecioVentaMayorista { get; set; }

        [Column("precio_venta_distribuidor", TypeName = "decimal(12,2)")]
        public decimal PrecioVentaDistribuidor { get; set; }

        // Stock Referencial
        [Column("stock_minimo", TypeName = "decimal(10,3)")]
        public decimal StockMinimo { get; set; }

        [Column("stock_maximo", TypeName = "decimal(10,3)")]
        public decimal? StockMaximo { get; set; }

        [Column("permite_inventario_negativo")]
        public bool PermiteInventarioNegativo { get; set; }

        // Fiscal
        [Column("id_tipo_producto")]
        public long? IdTipoProducto { get; set; }

        [Column("gravado_impuesto")]
        public bool GravadoImpuesto { get; set; } = true;

        [Column("porcentaje_impuesto", TypeName = "decimal(5,2)")]
        public decimal PorcentajeImpuesto { get; set; } = 18.00m;

        [MaxLength(500)]
        [Column("imagen_principal_url")]
        public string? ImagenPrincipalUrl { get; set; }

        // Navigation Properties
        [ForeignKey("IdCategoria")]
        public virtual Categoria Categoria { get; set; } = null!;

        [ForeignKey("IdMarca")]
        public virtual Marca Marca { get; set; } = null!;

        [ForeignKey("IdUnidadMedida")]
        public virtual UnidadMedida UnidadMedida { get; set; } = null!;

        public virtual ICollection<VarianteProducto> Variantes { get; set; } = new List<VarianteProducto>();
        public virtual ICollection<ImagenProducto> Imagenes { get; set; } = new List<ImagenProducto>();

        // Constructor para creación rápida
        public Producto() { }

        public Producto(string codigo, string nombre, long idCategoria, long idMarca, long idUnidadMedida)
        {
            CodigoProducto = codigo;
            NombreProducto = nombre;
            IdCategoria = idCategoria;
            IdMarca = idMarca;
            IdUnidadMedida = idUnidadMedida;
        }

        public void EstablecerPrecios(decimal compra, decimal ventaPublico, decimal ventaMayorista, decimal ventaDistribuidor)
        {
            PrecioCompra = compra;
            PrecioVentaPublico = ventaPublico;
            PrecioVentaMayorista = ventaMayorista;
            PrecioVentaDistribuidor = ventaDistribuidor;
        }
    }
}
