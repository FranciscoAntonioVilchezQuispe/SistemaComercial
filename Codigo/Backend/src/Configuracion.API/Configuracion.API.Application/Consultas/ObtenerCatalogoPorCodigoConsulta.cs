using Configuracion.API.Application.DTOs;

namespace Configuracion.API.Application.Consultas
{
    /// <summary>
    /// Consulta para obtener un catálogo completo por código
    /// </summary>
    public record ObtenerCatalogoPorCodigoConsulta(string Codigo, bool IncluirInactivos = false);

    /// <summary>
    /// Respuesta de la consulta
    /// </summary>
    public record ObtenerCatalogoPorCodigoRespuesta(CatalogoCompletoDto? Catalogo);
}
