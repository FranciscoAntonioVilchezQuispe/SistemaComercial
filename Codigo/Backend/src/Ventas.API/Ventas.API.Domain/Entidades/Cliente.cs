using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("clientes", Schema = "clientes")]
    public class Cliente : EntidadBase
    {
        [Column("id_cliente")]
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

        // Datos Comerciales
        [Column("id_tipo_cliente")]
        public long? IdTipoCliente { get; set; }

        [Column("limite_credito", TypeName = "decimal(12,2)")]
        public decimal? LimiteCredito { get; set; } = 0;

        [Column("dias_credito")]
        public int? DiasCredito { get; set; } = 0;

        [Column("id_lista_precio_asignada")]
        public long? IdListaPrecioAsignada { get; set; }

        public virtual ICollection<ContactoCliente> Contactos { get; set; } = new List<ContactoCliente>();
    }
}
