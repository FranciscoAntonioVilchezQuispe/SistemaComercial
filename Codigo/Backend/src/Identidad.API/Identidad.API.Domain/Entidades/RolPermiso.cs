using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("roles_permisos", Schema = "identidad")]
    public class RolPermiso : EntidadBase
    {
        [Column("id_rol")]
        public long IdRol { get; set; }

        [Column("id_permiso")]
        public long IdPermiso { get; set; }

        // Redefining Id is tricky for many-to-many join tables with EntidadBase.
        // Usually, we might not use EntidadBase for pure join tables, or use a composite key + ignore the single Id.
        // However, the SQL script defines PRIMARY KEY (id_rol, id_permiso) AND has audit fields.
        // I will hide the base Id or not use EntidadBase if it strictly requires a single key.
        // Given EntidadBase has public long Id, I will mark it as NotMapped or just use a new Id if preferred.
        // But the SQL doesn't have a single id_rol_permiso.
        // I'll use [NotMapped] for override Id and treat it as a special case, or add a surrogate key if required by EF later.
        // For now, I'll follow the plan of using EntidadBase but acknowledging the composite key.

        [NotMapped]
        public override long Id { get; set; }

        [ForeignKey("IdRol")]
        public virtual Rol Rol { get; set; } = null!;

        [ForeignKey("IdPermiso")]
        public virtual Permiso Permiso { get; set; } = null!;
    }
}
