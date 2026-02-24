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
    public class RecibirTrasladoManejador : IRequestHandler<RecibirTrasladoComando, bool>
    {
        private readonly IInventarioDbContext _context;
        private readonly IMediator _mediator;

        public RecibirTrasladoManejador(IInventarioDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<bool> Handle(RecibirTrasladoComando request, CancellationToken cancellationToken)
        {
            // 1. Validar existencia del Traslado
            var traslado = await _context.Traslados
                .FirstOrDefaultAsync(t => t.Id == request.TrasladoId, cancellationToken);

            if (traslado == null)
                throw new Exception($"No se encontró el traslado con ID {request.TrasladoId}");

            if (traslado.Estado != "EN_TRANSITO")
                throw new Exception($"El traslado se encuentra en estado '{traslado.Estado}' y no puede ser recibido.");

            // 2. Obtener tipo de movimiento para transferencia
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Codigo == "TRA_ALM", cancellationToken);

            // 3. Procesar Recepción
            var detalles = await _context.TrasladosDetalle
                .Where(d => d.TrasladoId == traslado.Id)
                .ToListAsync(cancellationToken);

            foreach (var confirmarDetalle in request.Detalles)
            {
                var detalleExistente = detalles.FirstOrDefault(d => d.ProductoId == confirmarDetalle.ProductoId);
                if (detalleExistente == null) continue;

                // Registrar Ingreso en el Almacén Destino
                var comandoIngreso = new CrearMovimientoInventarioComando(
                    confirmarDetalle.ProductoId,
                    traslado.AlmacenDestinoId,
                    tipoMovimiento!.Id,
                    confirmarDetalle.CantidadRecibida,
                    detalleExistente.CostoUnitarioDespacho, // Mantenemos el costo de origen para el CPP de destino
                    "TRASLADOS",
                    traslado.Id,
                    $"Ingreso por Traslado {traslado.NumeroTraslado} (Recibido)",
                    null, null, null
                );

                await _mediator.Send(comandoIngreso, cancellationToken);

                // Actualizar detalle del traslado
                detalleExistente.CantidadRecibida = confirmarDetalle.CantidadRecibida;
                detalleExistente.Observaciones = confirmarDetalle.Observaciones;

                // Registrar Incidencia si hay faltantes
                if (confirmarDetalle.CantidadRecibida < detalleExistente.CantidadDespachada)
                {
                    // Nota: Aquí se podría insertar en traslados_incidencias si la tabla está mapeada
                    // Por ahora queda registrado en el detalle.
                }
            }

            // 4. Actualizar Estado del Traslado
            traslado.Estado = "RECIBIDO";
            traslado.FechaRecepcion = DateTime.UtcNow;
            traslado.Observaciones = request.Observaciones;

            await _context.SaveChangesAsync(cancellationToken);

            return true;
        }
    }
}
