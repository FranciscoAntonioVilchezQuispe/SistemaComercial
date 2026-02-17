using System.Collections.Generic;
using Configuracion.API.Domain.Entidades;

namespace Configuracion.API.Application.DTOs
{
    public class ReglasYRelacionesResponse
    {
        public IEnumerable<DocumentoIdentidadRegla> Reglas { get; set; } = new List<DocumentoIdentidadRegla>();
        public IEnumerable<DocumentoComprobanteRelacion> Relaciones { get; set; } = new List<DocumentoComprobanteRelacion>();
    }
}
