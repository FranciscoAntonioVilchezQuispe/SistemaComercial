using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;
using Nucleo.Comun.Domain.Helpers;

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

                // 1. Validar fecha (Política v1.0: 24 horas absolutas para anulación directa)
                var limite24Horas = compra.FechaCreacion.AddHours(24);
                if (DateTimeHelper.ObtenerAhoraLima() > limite24Horas)
                    throw new Exception("Han pasado más de 24 horas desde el registro. No se puede anular directamente. Debe realizar una Nota de Crédito.");

                // 2. Actualizar estados y campos v1.0
                compra.IdEstado = (long)EstadoDocumento.AnuladoDirecto;
                compra.IdEstadoPago = (long)EstadoPago.Anulado;
                compra.FechaAnulacion = DateTimeHelper.ObtenerAhoraLima();
                compra.MotivoAnulacion = request.Motivo;
                compra.TipoAnulacion = "directo";
                compra.UsuarioActualizacion = request.UsuarioId.ToString();
                compra.EstadoSunat = "ANULADO";
                compra.Observaciones += $"\n[ANULACIÓN DIRECTA] {DateTimeHelper.ObtenerAhoraLima()} por {request.UsuarioId}: {request.Motivo}";

                // 3. Solicitar reversión de stock (Salida de almacén por devolución integral)
                _logger.LogInformation("Solicitando reversión de stock para Compra {CompraId}", compra.Id);
                var successStock = await _inventarioServicio.EliminarMovimientosCompraAsync(compra.Id);

                if (!successStock)
                {
                    _logger.LogError("Fallo en la reversión de stock para la Compra {CompraId}", compra.Id);
                    throw new Exception("Error al revertir el stock en inventarios.");
                }

                _context.Compras.Update(compra);

                // 4. Liberar Orden de Compra si existe referencia
                var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.CompraId == compra.Id, cancellationToken);
                if (orden != null)
                {
                    _logger.LogInformation("Liberando Orden de Compra {CodigoOrden} vinculada a Compra {CompraId}", orden.CodigoOrden, compra.Id);
                    orden.CompraId = null;
                    orden.IdEstado = (long)EstadoOrdenCompra.Aprobada; // Revertir a Aprobado
                    orden.Observaciones += $"\n[LIBERACIÓN] {DateTimeHelper.ObtenerAhoraLima()}: Compra {compra.SerieComprobante}-{compra.NumeroComprobante} anulada.";
                    _context.OrdenesCompra.Update(orden);
                }

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
