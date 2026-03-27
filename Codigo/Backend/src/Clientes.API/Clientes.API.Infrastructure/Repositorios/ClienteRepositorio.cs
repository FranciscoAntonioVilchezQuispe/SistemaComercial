using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Clientes.API.Infrastructure.Repositorios
{
    public class ClienteRepositorio : IClienteRepositorio
    {
        private readonly ClientesDbContext _context;

        public ClienteRepositorio(ClientesDbContext context)
        {
            _context = context;
        }

        public async Task<Cliente?> ObtenerPorIdAsync(long id)
        {
            return await _context.Clientes
                .Include(c => c.Contactos)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Cliente> AgregarAsync(Cliente cliente)
        {
            _context.Clientes.Add(cliente);
            await _context.SaveChangesAsync();
            return cliente;
        }

        public async Task ActualizarAsync(Cliente cliente)
        {
            _context.Entry(cliente).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                _context.Clientes.Remove(cliente);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Cliente>> ObtenerTodosAsync(string? busqueda = null)
        {
            var query = _context.Clientes.AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var term = busqueda.Trim().ToLower();
                query = query.Where(c =>
                    c.RazonSocial.ToLower().Contains(term) ||
                    c.NumeroDocumento.Contains(term));
            }

            return await query.Take(100).ToListAsync();
        }

        public async Task<(IEnumerable<Cliente> Datos, int Total)> ObtenerPaginadoAsync(string? search, bool? activo, int pageNumber, int pageSize)
        {
            var query = _context.Clientes.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                query = query.Where(c => 
                    c.RazonSocial.ToLower().Contains(search) || 
                    c.NumeroDocumento.Contains(search) ||
                    (c.NombreComercial != null && c.NombreComercial.ToLower().Contains(search)));
            }

            if (activo.HasValue)
            {
                query = query.Where(c => c.Activado == activo.Value);
            }

            var total = await query.CountAsync();
            var datos = await query
                .OrderBy(c => c.RazonSocial)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
        }
    }
}
