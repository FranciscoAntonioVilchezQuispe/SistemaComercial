using System.Text.Json.Serialization;

namespace Nucleo.Comun.Application.Paginacion
{
    public class PagedRequest
    {
        [JsonIgnore]
        public int PageNumber { get; set; } = 1;

        [JsonIgnore]
        public int PageSize { get; set; } = 10;

        // Propiedades auxiliares para binding desde query string si es necesario
        // Pero en Minimal APIs se bindean directo.
        // Esto es util si se pasa como objeto.

        public string? SortBy { get; set; } // Nombre de la columna
        public string? SortDirection { get; set; } = "asc"; // asc o desc
        public string? Search { get; set; } // Texto libre

        // Filtros comunes
        public bool? Activo { get; set; } // null: todos, true: activos, false: inactivos
    }
}
