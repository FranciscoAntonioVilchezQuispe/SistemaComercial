using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("cat_estado_cpe", Schema = "sunat")]
    public class EstadoCpe
    {
        [Key]
        [Column("id_estado")]
        [MaxLength(20)]
        public string IdEstado { get; set; } = null!;

        [Column("descripcion")]
        [MaxLength(100)]
        public string Descripcion { get; set; } = null!;

        [Column("es_final")]
        public bool EsFinal { get; set; } = false;

        [Column("permite_reenvio")]
        public bool PermiteReenvio { get; set; } = false;

        [Column("activado")]
        public bool Activado { get; set; } = true;

        [Column("fecha_creacion")]
        public DateTime FechaCreacion { get; set; }

        [Column("usuario_creacion")]
        [MaxLength(50)]
        public string UsuarioCreacion { get; set; } = "sistema";

        [Column("fecha_modificacion")]
        public DateTime? FechaModificacion { get; set; }

        [Column("usuario_modificacion")]
        [MaxLength(50)]
        public string? UsuarioModificacion { get; set; }
    }
}
