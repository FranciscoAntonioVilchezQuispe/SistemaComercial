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
    public class ObtenerTrasladosManejador : IRequestHandler<ObtenerTrasladosConsulta, List<TrasladoDto>>
    {
        private readonly IInventarioDbContext _context;

        public ObtenerTrasladosManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<List<TrasladoDto>> Handle(ObtenerTrasladosConsulta request, CancellationToken cancellationToken)
        {
            var traslados = await _context.Traslados
                .AsNoTracking()
                .Include(t => t.Detalles)
                .OrderByDescending(t => t.FechaDespacho)
                .ToListAsync(cancellationToken);

            var almacenes = await _context.Almacenes
                .AsNoTracking()
                .Select(a => new { a.Id, a.NombreAlmacen })
                .ToDictionaryAsync(a => a.Id, a => a.NombreAlmacen, cancellationToken);

            var resultado = traslados.Select(t => new TrasladoDto
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

            return resultado;
        }
    }
}
