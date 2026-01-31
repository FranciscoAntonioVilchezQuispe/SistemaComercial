using Clientes.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Clientes.API.Domain.Interfaces
{
    public interface IContactoClienteRepositorio
    {
        Task<ContactoCliente?> ObtenerPorIdAsync(long id);
        Task<ContactoCliente> AgregarAsync(ContactoCliente contacto);
        Task ActualizarAsync(ContactoCliente contacto);
        Task EliminarAsync(long id);
        Task<IEnumerable<ContactoCliente>> ObtenerPorClienteAsync(long idCliente);
    }
}
