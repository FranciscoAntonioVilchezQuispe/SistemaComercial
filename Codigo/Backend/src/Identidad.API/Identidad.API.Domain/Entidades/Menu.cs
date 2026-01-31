using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("menus", Schema = "identidad")]
    public class Menu : EntidadBase
    {
        [Column("id_menu")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [MaxLength(255)]
        [Column("ruta")]
        public string? Ruta { get; set; }

        [MaxLength(50)]
        [Column("icono")]
        public string? Icono { get; set; }

        [Column("orden")]
        public int Orden { get; set; } = 0;

        [Column("id_menu_padre")]
        public long? IdMenuPadre { get; set; }

        // Navegación
        [ForeignKey("IdMenuPadre")]
        public virtual Menu? MenuPadre { get; set; }

        public virtual ICollection<Menu> SubMenus { get; set; } = new List<Menu>();
        public virtual ICollection<RolMenu> RolesMenus { get; set; } = new List<RolMenu>();
    }
}
