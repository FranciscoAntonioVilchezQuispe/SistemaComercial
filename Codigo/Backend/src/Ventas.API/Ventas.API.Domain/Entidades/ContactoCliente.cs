using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("contactos_cliente", Schema = "clientes")]
    public class ContactoCliente : EntidadBase
    {
        [Column("id_contacto")]
        public override long Id { get; set; }

        [Column("id_cliente")]
        public long IdCliente { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombres")]
        public string Nombres { get; set; } = null!;

        [MaxLength(100)]
        [Column("cargo")]
        public string? Cargo { get; set; }

        [MaxLength(50)]
        [Column("telefono")]
        public string? Telefono { get; set; }

        [MaxLength(100)]
        [Column("email")]
        public string? Email { get; set; }

        [Column("es_principal")]
        public bool EsPrincipal { get; set; }

        [ForeignKey("IdCliente")]
        public virtual Cliente Cliente { get; set; } = null!;
    }
}
