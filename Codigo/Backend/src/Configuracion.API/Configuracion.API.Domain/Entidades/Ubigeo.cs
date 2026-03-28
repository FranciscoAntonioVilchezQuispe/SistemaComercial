using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Nucleo.Comun.Domain;

namespace Configuracion.API.Domain.Entidades
{
    /// <summary>
    /// Representa un Ubigeo (Departamento, Provincia, Distrito) de forma recursiva.
    /// Basado en el estándar INEI/SUNAT.
    /// </summary>
    [Table("ubigeos", Schema = "configuracion")]
    public class Ubigeo : EntidadBase
    {
        // Sobrescribimos el Id porque el Ubigeo usa un código VARCHAR(6) como PK
        [Key]
        [Column("codigo")]
        [MaxLength(6)]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Required]
        [Column("nivel")]
        public short Nivel { get; set; } // 1: Depto, 2: Prov, 3: Dist

        [Column("parent_id")]
        [MaxLength(6)]
        public string? ParentId { get; set; }

        // Navegación recursiva
        [ForeignKey("ParentId")]
        public virtual Ubigeo? Parent { get; set; }

        public virtual ICollection<Ubigeo> Hijos { get; set; } = new List<Ubigeo>();

        #region Propiedades de Conveniencia (Solo Lectura)

        [NotMapped]
        public bool EsDepartamento => Nivel == 1;

        [NotMapped]
        public bool EsProvincia => Nivel == 2;

        [NotMapped]
        public bool EsDistrito => Nivel == 3;

        [NotMapped]
        public string CodigoDepartamento => Codigo.Length >= 2 ? Codigo.Substring(0, 2) : Codigo;

        [NotMapped]
        public string? CodigoProvincia => (Nivel >= 2 && Codigo.Length >= 4) ? Codigo.Substring(0, 4) : null;

        #endregion

        public Ubigeo()
        {
            Activado = true;
            UsuarioCreacion = "SISTEMA";
            FechaCreacion = DateTime.UtcNow;
        }
    }
}
