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
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // 1. Obtener la serie de comprobante para Orden de Compra
                var serieComprobante = await _context.SeriesComprobantesRef
                    .Include(s => s.TipoComprobante)
                    .Where(s => s.TipoComprobante != null && s.TipoComprobante.EsOrdenCompra && s.TipoComprobante.Activado)
                    .OrderByDescending(s => s.FechaCreacion)
                    .FirstOrDefaultAsync();

                if (serieComprobante == null)
                {
                    throw new System.Exception("No se encontró una serie configurada para el tipo de comprobante 'Orden de Compra'.");
                }

                // 2. Incrementar y formatear correlativo
                serieComprobante.CorrelativoActual++;
                string numeroFormateado = serieComprobante.CorrelativoActual.ToString().PadLeft(8, '0');

                // 3. Asignar valores a la orden
                orden.IdTipoComprobante = serieComprobante.IdTipoComprobante;
                orden.Serie = serieComprobante.Serie;
                orden.Numero = numeroFormateado;
                orden.CodigoOrden = $"{orden.Serie}-{orden.Numero}";

                // 4. Validar duplicados para evitar conflictos
                if (await _context.OrdenesCompra.AnyAsync(o => o.CodigoOrden == orden.CodigoOrden))
                {
                    throw new System.Exception($"Ya existe una orden de compra con el código {orden.CodigoOrden}. Reintente la operación.");
                }

                // 5. Guardar cambios
                _context.OrdenesCompra.Add(orden);
                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
                return orden;
            }
            catch (System.Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
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

        public async Task<OrdenCompra?> ActualizarEstadoAsync(long id, long idEstado)
        {
            var orden = await _context.OrdenesCompra.FindAsync(id);
            if (orden != null)
            {
                orden.IdEstado = idEstado;
                await _context.SaveChangesAsync();
            }
            return orden;
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

        public async Task<string> ObtenerSiguienteNumeroAsync()
        {
            var serieComprobante = await _context.SeriesComprobantesRef
                .Include(s => s.TipoComprobante)
                .Where(s => s.TipoComprobante != null && s.TipoComprobante.EsOrdenCompra)
                .OrderByDescending(s => s.FechaCreacion)
                .FirstOrDefaultAsync();

            if (serieComprobante == null) return "S/N";

            string numeroFormateado = (serieComprobante.CorrelativoActual + 1).ToString().PadLeft(8, '0');
            return $"{serieComprobante.Serie}{numeroFormateado}";
        }
    }
}
