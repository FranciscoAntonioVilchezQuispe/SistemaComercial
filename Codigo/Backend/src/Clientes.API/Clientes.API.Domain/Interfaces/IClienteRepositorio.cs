using Clientes.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Clientes.API.Domain.Interfaces
{
    public interface IClienteRepositorio
    {
        Task<Cliente?> ObtenerPorIdAsync(long id);
        Task<Cliente> AgregarAsync(Cliente cliente);
        Task ActualizarAsync(Cliente cliente);
        Task EliminarAsync(long id);
        Task<IEnumerable<Cliente>> ObtenerTodosAsync(string? busqueda = null);
    }
}
