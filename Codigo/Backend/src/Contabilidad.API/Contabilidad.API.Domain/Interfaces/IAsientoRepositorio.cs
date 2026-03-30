using Contabilidad.API.Domain.Entidades;
using Contabilidad.API.Domain.DTOs;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Contabilidad.API.Domain.Interfaces
{
    public interface IAsientoRepositorio
    {
        Task<AsientoDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<AsientoContable?> ObtenerPorIdAsync(long id);
        Task<AsientoContable> AgregarAsync(AsientoContable asiento);
        Task<(IEnumerable<AsientoListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, string? periodo, int pagina, int elementosPorPagina);
    }
}
