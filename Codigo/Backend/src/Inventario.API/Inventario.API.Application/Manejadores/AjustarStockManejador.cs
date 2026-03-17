using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Comandos;
using Inventario.API.Domain.Entidades;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores
{
    public class AjustarStockManejador : IRequestHandler<AjustarStockComando, long>
    {
        private readonly IInventarioDbContext _context;
        private readonly IMediator _mediator;

        public AjustarStockManejador(IInventarioDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(AjustarStockComando request, CancellationToken cancellationToken)
        {
            var stock = await _context.Stocks
                .FirstOrDefaultAsync(s => s.IdProducto == request.IdProducto && s.IdAlmacen == request.IdAlmacen, cancellationToken);

            decimal cantidadActual = stock?.CantidadActual ?? 0;
            decimal diferencia = request.NuevaCantidad - cantidadActual;

            if (diferencia == 0) return 0;

            string codigoTipo = diferencia > 0 ? "AJU_POS" : "AJU_NEG";
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Codigo == codigoTipo, cancellationToken);

            if (tipoMovimiento == null)
                throw new Exception($"El tipo de movimiento {codigoTipo} no existe configurado.");

            var comandoMovimiento = new CrearMovimientoInventarioComando(
                IdProducto: request.IdProducto,
                IdAlmacen: request.IdAlmacen,
                IdTipoMovimiento: tipoMovimiento.Id,
                Cantidad: Math.Abs(diferencia),
                CostoUnitario: null,
                ReferenciaModulo: "INVENTARIO",
                IdReferencia: null,
                Observaciones: request.Motivo,
                IdTipoDocumento: null,
                SerieDocumento: null,
                NumeroDocumento: null
            );

            return await _mediator.Send(comandoMovimiento, cancellationToken);
        }
    }
}
