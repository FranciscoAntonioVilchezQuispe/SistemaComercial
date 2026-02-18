using System.Collections.Generic;
using System.Threading.Tasks;

using Configuracion.API.Domain.Entidades;
using Configuracion.API.Application.DTOs;

namespace Configuracion.API.Application.Interfaces

{
    public interface IReglasDocumentoServicio
    {
        Task<ReglasYRelacionesResponse> ObtenerReglasYRelacionesAsync();


        // Métodos para Mantenedor
        Task<IEnumerable<DocumentoIdentidadRegla>> ListarReglasAsync();
        Task<DocumentoIdentidadRegla?> ObtenerReglaPorIdAsync(long id);
        Task<DocumentoIdentidadRegla> GuardarReglaAsync(DocumentoIdentidadRegla regla);
        Task<bool> EliminarReglaAsync(long id);

        Task<IEnumerable<DocumentoComprobanteRelacion>> ListarRelacionesPorDocumentoAsync(string codigoDocumento);
        Task<IEnumerable<TipoComprobante>> ListarComprobantesPorDocumentoAsync(string codigoDocumento);
        Task<bool> ActualizarRelacionesAsync(string codigoDocumento, List<long> idsTiposComprobante);
    }
}

