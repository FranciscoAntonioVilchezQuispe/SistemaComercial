using Nucleo.Comun.Application.Wrappers;
using System.Text.Json.Serialization;

namespace Nucleo.Comun.Application.Paginacion
{
    public class PagedResponse<T> : ToReturnList<T>
    {
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }

        [JsonPropertyName("hasPreviousPage")]
        public bool HasPreviousPage => PageNumber > 1;

        [JsonPropertyName("hasNextPage")]
        public bool HasNextPage => PageNumber < TotalPages;

        public PagedResponse(IEnumerable<T> data, int pageNumber, int pageSize, int totalRecords) : base(data, totalRecords)
        {
            PageNumber = pageNumber;
            PageSize = pageSize;
            TotalPages = (int)Math.Ceiling(totalRecords / (double)pageSize);
        }
    }
}
