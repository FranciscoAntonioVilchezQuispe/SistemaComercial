using Configuracion.API.Application.DTOs;

namespace Configuracion.API.Application.Consultas
{
    /// <summary>
    /// Consulta para obtener todos los catálogos
    /// </summary>
    public record ObtenerTodosCatalogosConsulta
    {
        // Sin parámetros - retorna todos los catálogos activos
    }

    /// <summary>
    /// Respuesta de la consulta
    /// </summary>
    public record ObtenerTodosCatalogosRespuesta(List<TablaGeneralDto> Catalogos);
}
