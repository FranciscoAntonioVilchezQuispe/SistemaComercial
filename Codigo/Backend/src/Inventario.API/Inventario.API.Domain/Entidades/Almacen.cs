using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades
{
    [Table("almacenes", Schema = "inventario")]
    public class Almacen : EntidadBase
    {
        [Column("id_almacen")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_almacen")]
        public string NombreAlmacen { get; set; } = null!;

        [MaxLength(255)]
        [Column("direccion")]
        public string? Direccion { get; set; }

        [Column("id_sucursal")]
        public long IdSucursal { get; set; }

        [Column("es_principal")]

        public bool EsPrincipal { get; set; } = false;
    }
}
