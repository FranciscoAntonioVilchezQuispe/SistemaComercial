using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("tipos_permiso", Schema = "identidad")]
    public class TipoPermiso : EntidadBase
    {
        [Column("id_tipo_permiso")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        // Navegación
        public virtual ICollection<RolMenuPermiso> RolesMenusPermisos { get; set; } = new List<RolMenuPermiso>();
    }
}
