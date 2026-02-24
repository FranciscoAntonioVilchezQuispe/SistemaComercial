using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores
{
    public class CrearTrasladoManejador : IRequestHandler<CrearTrasladoComando, long>
    {
        private readonly IInventarioDbContext _context;
        private readonly IMediator _mediator;

        public CrearTrasladoManejador(IInventarioDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(CrearTrasladoComando request, CancellationToken cancellationToken)
        {
            // 1. Validar Tipo de Movimiento para Transferencia
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Codigo == "TRA_ALM", cancellationToken);

            if (tipoMovimiento == null)
                throw new Exception("No se encontró el tipo de movimiento 'TRA_ALM' (Transferencia entre almacenes).");

            // 2. Crear Cabecera de Traslado
            var traslado = new Traslado
            {
                NumeroTraslado = $"TR-{DateTime.Now:yyyyMMdd}-{Guid.NewGuid().ToString().Substring(0, 4).ToUpper()}",
                AlmacenOrigenId = request.AlmacenOrigenId,
                AlmacenDestinoId = request.AlmacenDestinoId,
                Estado = "EN_TRANSITO", // Al crear se asume despacho inmediato en este flujo simplificado
                FechaPedido = DateTime.UtcNow,
                FechaDespacho = DateTime.UtcNow,
                Observaciones = request.Observaciones,
                UsuarioCreacion = "SISTEMA",
                FechaCreacion = DateTime.UtcNow
            };

            _context.Traslados.Add(traslado);
            await _context.SaveChangesAsync(cancellationToken);

            // 3. Procesar Detalles y Generar Salidas de Inventario
            foreach (var detalleDto in request.Detalles)
            {
                // Registrar Salida del Almacén Origen
                var comandoSalida = new CrearMovimientoInventarioComando(
                    detalleDto.ProductoId,
                    request.AlmacenOrigenId,
                    tipoMovimiento.Id,
                    detalleDto.Cantidad,
                    null, // Costo se calcula automáticamente en salida (CPP actual)
                    "TRASLADOS",
                    traslado.Id,
                    $"Salida por Traslado {traslado.NumeroTraslado}",
                    null, null, null // Documento SUNAT se asocia en la GR que complementa
                );

                var movimientoId = await _mediator.Send(comandoSalida, cancellationToken);

                // Obtener el costo usado en la salida para guardarlo en el detalle del traslado
                var movimiento = await _context.MovimientosInventario
                    .AsNoTracking()
                    .FirstOrDefaultAsync(m => m.Id == movimientoId, cancellationToken);

                var detalle = new TrasladoDetalle
                {
                    TrasladoId = traslado.Id,
                    ProductoId = detalleDto.ProductoId,
                    CantidadSolicitada = detalleDto.Cantidad,
                    CantidadDespachada = detalleDto.Cantidad,
                    CostoUnitarioDespacho = movimiento?.CostoUnitarioMovimiento ?? 0,
                    Observaciones = $"Despacho de {detalleDto.Cantidad}"
                };

                _context.TrasladosDetalle.Add(detalle);
            }

            await _context.SaveChangesAsync(cancellationToken);

            return traslado.Id;
        }
    }
}
