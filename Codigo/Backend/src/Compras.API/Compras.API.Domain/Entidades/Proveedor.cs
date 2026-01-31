using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("proveedores", Schema = "compras")]
    public class Proveedor : EntidadBase
    {
        [Column("id_proveedor")]
        public override long Id { get; set; }

        [Required]
        [Column("id_tipo_documento")]
        public long IdTipoDocumento { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("numero_documento")]
        public string NumeroDocumento { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        [Column("razon_social")]
        public string RazonSocial { get; set; } = null!;

        [MaxLength(255)]
        [Column("nombre_comercial")]
        public string? NombreComercial { get; set; }

        [MaxLength(500)]
        [Column("direccion")]
        public string? Direccion { get; set; }

        [MaxLength(50)]
        [Column("telefono")]
        public string? Telefono { get; set; }

        [MaxLength(100)]
        [Column("email")]
        public string? Email { get; set; }

        [MaxLength(255)]
        [Column("pagina_web")]
        public string? PaginaWeb { get; set; }
    }
}
