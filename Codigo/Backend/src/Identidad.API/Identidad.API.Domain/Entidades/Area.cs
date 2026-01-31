using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("areas", Schema = "identidad")]
    public class Area : EntidadBase
    {
        [Column("id_area")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_area")]
        public string NombreArea { get; set; } = null!;

        public virtual ICollection<Cargo> Cargos { get; set; } = new List<Cargo>();
    }
}
