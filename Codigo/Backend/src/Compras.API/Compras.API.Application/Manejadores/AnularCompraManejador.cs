using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;

namespace Compras.API.Application.Manejadores
{
    public class AnularCompraManejador : IRequestHandler<AnularCompraComando, bool>
    {
        private readonly IComprasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<AnularCompraManejador> _logger;

        public AnularCompraManejador(
            IComprasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<AnularCompraManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<bool> Handle(AnularCompraComando request, CancellationToken cancellationToken)
        {
            try 
            {
                var compra = await _context.Compras
                    .Include(c => c.Detalles)
                    .FirstOrDefaultAsync(c => c.Id == request.IdCompra, cancellationToken);

                if (compra == null)
                    throw new Exception("La compra no existe.");

                if (compra.IdEstadoPago == (long)EstadoPago.Anulado)
                    return true;

                // 1. Validar fecha (opcional según política interna, para compras es más flexible pero seguiremos el estándar SUNAT de mismo día para 'anulación' técnica)
                if (compra.FechaEmision.Date != DateTime.UtcNow.Date)
                    throw new Exception("No se puede anular una compra de fecha anterior. Debe realizar una Nota de Crédito.");

                // 2. Actualizar estados y campos SUNAT en Compras
                compra.IdEstadoPago = (long)EstadoPago.Anulado;
                compra.FechaAnulacion = DateTime.UtcNow;
                compra.MotivoAnulacion = request.Motivo;
                compra.EstadoSunat = "ANULADO";
                compra.Observaciones += $"\n[ANULACIÓN] {DateTime.UtcNow}: {request.Motivo}";

                // 3. Solicitar reversión de stock (Salida de almacén por devolución integral)
                _logger.LogInformation("Solicitando reversión de stock para Compra {CompraId}", compra.Id);
                var successStock = await _inventarioServicio.EliminarMovimientosCompraAsync(compra.Id);

                if (!successStock)
                {
                    _logger.LogError("Fallo en la reversión de stock para la Compra {CompraId}", compra.Id);
                    throw new Exception("Error al revertir el stock en inventarios.");
                }

                _context.Compras.Update(compra);
                await _context.SaveChangesAsync(cancellationToken);

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al anular la compra {CompraId}", request.IdCompra);
                throw;
            }
        }
    }
}
