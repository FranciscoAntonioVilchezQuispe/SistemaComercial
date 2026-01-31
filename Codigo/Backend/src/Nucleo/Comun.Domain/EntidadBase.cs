using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Nucleo.Comun.Domain
{
    public abstract class EntidadBase : IAuditable
    {
        [Key]
        [Column("id")]
        public virtual long Id { get; set; }

        [Column("activado")]
        public bool Activado { get; set; } = true;

        [Column("fecha_creacion")]
        public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;

        [MaxLength(50)]
        [Column("usuario_creacion")]
        public string UsuarioCreacion { get; set; } = string.Empty;

        [Column("fecha_modificacion")]
        public DateTime? FechaActualizacion { get; set; }

        [MaxLength(50)]
        [Column("usuario_modificacion")]
        public string? UsuarioActualizacion { get; set; }

        private readonly List<object> _eventosDominio = new();
        public IReadOnlyCollection<object> EventosDominio => _eventosDominio.AsReadOnly();

        public void AgregarEventoDominio(object evento)
        {
            _eventosDominio.Add(evento);
        }

        public void LimpiarEventosDominio()
        {
            _eventosDominio.Clear();
        }
    }
}
