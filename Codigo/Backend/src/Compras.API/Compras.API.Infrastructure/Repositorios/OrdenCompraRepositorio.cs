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
            var orden = await _context.OrdenesCompra
                .Include(o => o.Detalles)
                .Include(o => o.Proveedor)
                .FirstOrDefaultAsync(o => o.Id == id);

            if (orden != null)
            {
                orden.RazonSocialProveedor = orden.Proveedor?.RazonSocial;
                orden.IdTipoDocumentoProveedor = orden.Proveedor?.IdTipoDocumento ?? 0;
                orden.NumeroDocumentoProveedor = orden.Proveedor?.NumeroDocumento;

                var almacen = await _context.AlmacenesRef.FirstOrDefaultAsync(a => a.Id == orden.IdAlmacenDestino);
                orden.NombreAlmacen = almacen?.NombreAlmacen;

                foreach (var detalle in orden.Detalles)
                {
                    var prod = await _context.ProductosRef.FirstOrDefaultAsync(p => p.Id == detalle.IdProducto);
                    if (prod != null)
                    {
                        detalle.NombreProducto = prod.NombreProducto;
                        var um = await _context.UnidadesMedidaRef.FirstOrDefaultAsync(u => u.Id == prod.IdUnidadMedida);
                        detalle.UnidadMedidaSimbolo = um?.Simbolo;
                    }
                }
            }
            return orden;
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
            var ordenes = await _context.OrdenesCompra
                .Include(o => o.Proveedor)
                .Include(o => o.Detalles)
                .OrderByDescending(o => o.FechaCreacion)
                .ToListAsync();

            foreach (var orden in ordenes)
            {
                orden.RazonSocialProveedor = orden.Proveedor?.RazonSocial;
                orden.IdTipoDocumentoProveedor = orden.Proveedor?.IdTipoDocumento ?? 0;
                orden.NumeroDocumentoProveedor = orden.Proveedor?.NumeroDocumento;
                var almacen = await _context.AlmacenesRef.FirstOrDefaultAsync(a => a.Id == orden.IdAlmacenDestino);
                orden.NombreAlmacen = almacen?.NombreAlmacen;

                foreach (var detalle in orden.Detalles)
                {
                    var prod = await _context.ProductosRef.FirstOrDefaultAsync(p => p.Id == detalle.IdProducto);
                    if (prod != null)
                    {
                        detalle.NombreProducto = prod.NombreProducto;
                        var um = await _context.UnidadesMedidaRef.FirstOrDefaultAsync(u => u.Id == prod.IdUnidadMedida);
                        detalle.UnidadMedidaSimbolo = um?.Simbolo;
                    }
                }
            }

            return ordenes;
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

        public async Task<(IEnumerable<OrdenCompra> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina)
        {
            var query = _context.OrdenesCompra
                .Include(o => o.Proveedor)
                .Include(o => o.Detalles)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var term = busqueda.Trim().ToLower();
                query = query.Where(o =>
                    o.CodigoOrden.ToLower().Contains(term) ||
                    (o.Proveedor != null && o.Proveedor.RazonSocial.ToLower().Contains(term)));
            }

            if (activo.HasValue)
            {
                query = query.Where(o => o.Activado == activo.Value);
            }

            var total = await query.CountAsync();

            var ordenes = await query
                .OrderByDescending(o => o.FechaCreacion)
                .Skip((pagina - 1) * elementosPorPagina)
                .Take(elementosPorPagina)
                .ToListAsync();

            foreach (var orden in ordenes)
            {
                orden.RazonSocialProveedor = orden.Proveedor?.RazonSocial;
                orden.IdTipoDocumentoProveedor = orden.Proveedor?.IdTipoDocumento ?? 0;
                orden.NumeroDocumentoProveedor = orden.Proveedor?.NumeroDocumento;
                var almacen = await _context.AlmacenesRef.FirstOrDefaultAsync(a => a.Id == orden.IdAlmacenDestino);
                orden.NombreAlmacen = almacen?.NombreAlmacen;

                foreach (var detalle in orden.Detalles)
                {
                    var prod = await _context.ProductosRef.FirstOrDefaultAsync(p => p.Id == detalle.IdProducto);
                    if (prod != null)
                    {
                        detalle.NombreProducto = prod.NombreProducto;
                        var um = await _context.UnidadesMedidaRef.FirstOrDefaultAsync(u => u.Id == prod.IdUnidadMedida);
                        detalle.UnidadMedidaSimbolo = um?.Simbolo;
                    }
                }
            }

            return (ordenes, total);
        }
    }
}
