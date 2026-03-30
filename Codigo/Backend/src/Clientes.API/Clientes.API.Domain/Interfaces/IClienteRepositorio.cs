using Clientes.API.Domain.DTOs;
using Clientes.API.Domain.Entidades;

using System.Collections.Generic;
using System.Threading.Tasks;

namespace Clientes.API.Domain.Interfaces
{
    public interface IClienteRepositorio
    {
        Task<ClienteDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<Cliente?> ObtenerPorIdAsync(long id); // Auditoría y escrituras internas
        Task<Cliente> AgregarAsync(Cliente cliente);
        Task ActualizarAsync(Cliente cliente);
        Task EliminarAsync(long id);
        Task<IEnumerable<Cliente>> ObtenerTodosAsync(string? busqueda = null);
        Task<(IEnumerable<ClienteListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
    }
}
