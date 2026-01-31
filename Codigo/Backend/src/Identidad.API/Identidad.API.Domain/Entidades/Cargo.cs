using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("cargos", Schema = "identidad")]
    public class Cargo : EntidadBase
    {
        [Column("id_cargo")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_cargo")]
        public string NombreCargo { get; set; } = null!;

        [Column("id_area")]
        public long? IdArea { get; set; }

        [ForeignKey("IdArea")]
        public virtual Area? Area { get; set; }

        public virtual ICollection<Trabajador> Trabajadores { get; set; } = new List<Trabajador>();
    }
}
