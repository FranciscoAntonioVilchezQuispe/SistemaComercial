using Configuracion.API.Application.DTOs;

namespace Configuracion.API.Application.Consultas
{
    /// <summary>
    /// Consulta para obtener solo los valores de un catálogo
    /// </summary>
    public record ObtenerValoresCatalogoConsulta(string Codigo, bool IncluirInactivos = false);

    /// <summary>
    /// Respuesta de la consulta
    /// </summary>
    public record ObtenerValoresCatalogoRespuesta(List<TablaGeneralDetalleDto> Valores);
}
