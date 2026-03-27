using Inventario.API.Application.Consultas;
using Inventario.API.Application.Interfaces;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores
{
    public class ObtenerTrasladosManejador : IRequestHandler<ObtenerTrasladosConsulta, Nucleo.Comun.Application.Paginacion.PagedResponse<TrasladoDto>>
    {
        private readonly IInventarioDbContext _context;

        public ObtenerTrasladosManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<Nucleo.Comun.Application.Paginacion.PagedResponse<TrasladoDto>> Handle(ObtenerTrasladosConsulta request, CancellationToken cancellationToken)
        {
            var query = _context.Traslados
                .AsNoTracking()
                .Include(t => t.Detalles)
                .AsQueryable();

            if (!string.IsNullOrEmpty(request.Search))
            {
                query = query.Where(t => t.NumeroTraslado.Contains(request.Search) || (t.Observaciones != null && t.Observaciones.Contains(request.Search)));
            }

            int total = await query.CountAsync(cancellationToken);

            var traslados = await query
                .OrderByDescending(t => t.FechaDespacho)
                .Skip(((request.PageNumber ?? 1) - 1) * (request.PageSize ?? 10))
                .Take(request.PageSize ?? 10)
                .ToListAsync(cancellationToken);

            var almacenes = await _context.Almacenes
                .AsNoTracking()
                .Select(a => new { a.Id, a.NombreAlmacen })
                .ToDictionaryAsync(a => a.Id, a => a.NombreAlmacen, cancellationToken);

            var dtos = traslados.Select(t => new TrasladoDto
            {
                Id = t.Id,
                NumeroTraslado = t.NumeroTraslado,
                AlmacenOrigenId = t.AlmacenOrigenId,
                AlmacenOrigenNombre = almacenes.ContainsKey(t.AlmacenOrigenId) ? almacenes[t.AlmacenOrigenId] : "Desconocido",
                AlmacenDestinoId = t.AlmacenDestinoId,
                AlmacenDestinoNombre = almacenes.ContainsKey(t.AlmacenDestinoId) ? almacenes[t.AlmacenDestinoId] : "Desconocido",
                FechaDespacho = t.FechaDespacho,
                FechaRecepcion = t.FechaRecepcion,
                Estado = t.Estado,
                Observaciones = t.Observaciones,
                Detalles = t.Detalles.Select(d => new TrasladoDetalleDto
                {
                    ProductoId = d.ProductoId,
                    ProductoNombre = $"Producto {d.ProductoId}",
                    CantidadSolicitada = d.CantidadSolicitada,
                    CantidadDespachada = d.CantidadDespachada,
                    CantidadRecibida = d.CantidadRecibida
                }).ToList()
            }).ToList();

            return new Nucleo.Comun.Application.Paginacion.PagedResponse<TrasladoDto>(dtos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
        }
    }
}
