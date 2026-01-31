using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Clientes.API.Infrastructure.Repositorios
{
    public class ContactoClienteRepositorio : IContactoClienteRepositorio
    {
        private readonly ClientesDbContext _context;

        public ContactoClienteRepositorio(ClientesDbContext context)
        {
            _context = context;
        }

        public async Task<ContactoCliente?> ObtenerPorIdAsync(long id)
        {
            return await _context.ContactosCliente.FindAsync(id);
        }

        public async Task<ContactoCliente> AgregarAsync(ContactoCliente contacto)
        {
            _context.ContactosCliente.Add(contacto);
            await _context.SaveChangesAsync();
            return contacto;
        }

        public async Task ActualizarAsync(ContactoCliente contacto)
        {
            _context.Entry(contacto).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var contacto = await _context.ContactosCliente.FindAsync(id);
            if (contacto != null)
            {
                _context.ContactosCliente.Remove(contacto);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<ContactoCliente>> ObtenerPorClienteAsync(long idCliente)
        {
            return await _context.ContactosCliente
                .Where(c => c.IdCliente == idCliente)
                .ToListAsync();
        }
    }
}
