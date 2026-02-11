using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Compras.API.Infrastructure.Repositorios
{
    public class OrdenCompraRepositorio : IOrdenCompraRepositorio
    {
        private readonly ComprasDbContext _context;

        public OrdenCompraRepositorio(ComprasDbContext context)
        {
            _context = context;
        }

        public async Task<OrdenCompra?> ObtenerPorIdAsync(long id)
        {
            return await _context.OrdenesCompra
                .Include(o => o.Detalles)
                .Include(o => o.Proveedor)
                .FirstOrDefaultAsync(o => o.Id == id);
        }

        public async Task<OrdenCompra> AgregarAsync(OrdenCompra orden)
        {
            _context.OrdenesCompra.Add(orden);
            await _context.SaveChangesAsync();
            return orden;
        }

        public async Task ActualizarAsync(OrdenCompra orden)
        {
            _context.Entry(orden).State = EntityState.Modified;
            foreach (var detalle in orden.Detalles)
            {
                if (detalle.Id == 0) _context.DetallesOrdenCompra.Add(detalle);
                else _context.Entry(detalle).State = EntityState.Modified;
            }
            await _context.SaveChangesAsync();
        }

        public async Task ActualizarEstadoAsync(long id, long idEstado)
        {
            var orden = await _context.OrdenesCompra.FindAsync(id);
            if (orden != null)
            {
                orden.IdEstado = idEstado;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<OrdenCompra>> ObtenerTodosAsync()
        {
            return await _context.OrdenesCompra
                .Include(o => o.Proveedor)
                .Include(o => o.Detalles)
                .ToListAsync();
        }

        public async Task<IEnumerable<OrdenCompra>> ObtenerPorProveedorAsync(long idProveedor)
        {
            return await _context.OrdenesCompra
                .Where(o => o.IdProveedor == idProveedor)
                .ToListAsync();
        }
    }
}
