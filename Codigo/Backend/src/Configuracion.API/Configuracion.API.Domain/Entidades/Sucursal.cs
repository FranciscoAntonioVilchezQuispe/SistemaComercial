using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("sucursal", Schema = "configuracion")]
    public class Sucursal : EntidadBase
    {
        [Column("id_sucursal")]
        public override long Id { get; set; }

        [Column("id_empresa")]
        public long IdEmpresa { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_sucursal")]
        public string NombreSucursal { get; set; } = null!;

        [MaxLength(255)]
        [Column("direccion")]
        public string? Direccion { get; set; }

        [MaxLength(50)]
        [Column("telefono")]
        public string? Telefono { get; set; }

        [Column("es_principal")]
        public bool EsPrincipal { get; set; }

        [ForeignKey("IdEmpresa")]
        public virtual Empresa Empresa { get; set; } = null!;
    }
}
