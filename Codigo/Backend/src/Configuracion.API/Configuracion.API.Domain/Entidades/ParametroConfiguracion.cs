using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("configuraciones", Schema = "configuracion")]
    public class ParametroConfiguracion : EntidadBase
    {
        [Column("id_configuracion")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("clave")]
        public string Clave { get; set; } = null!;

        [Required]
        [Column("valor", TypeName = "text")]
        public string Valor { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [MaxLength(50)]
        [Column("grupo")]
        public string? Grupo { get; set; }
    }
}
