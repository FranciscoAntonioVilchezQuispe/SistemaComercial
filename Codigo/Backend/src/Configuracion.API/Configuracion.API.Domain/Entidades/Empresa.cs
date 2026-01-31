using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("empresa", Schema = "configuracion")]
    public class Empresa : EntidadBase
    {
        [Column("id_empresa")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("ruc")]
        public string Ruc { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        [Column("razon_social")]
        public string RazonSocial { get; set; } = null!;

        [MaxLength(255)]
        [Column("nombre_comercial")]
        public string? NombreComercial { get; set; }

        [Required]
        [MaxLength(500)]
        [Column("direccion_fiscal")]
        public string DireccionFiscal { get; set; } = null!;

        [MaxLength(50)]
        [Column("telefono")]
        public string? Telefono { get; set; }

        [MaxLength(100)]
        [Column("correo_contacto")]
        public string? CorreoContacto { get; set; }

        [MaxLength(255)]
        [Column("sitio_web")]
        public string? SitioWeb { get; set; }

        [MaxLength(500)]
        [Column("logo_url")]
        public string? LogoUrl { get; set; }

        [Required]
        [MaxLength(3)]
        [Column("moneda_principal")]
        public string MonedaPrincipal { get; set; } = "PEN";
    }
}
