using MediatR;
using Microsoft.Extensions.Logging;
using Compras.API.Application.Eventos;
using Compras.API.Application.Interfaces;

namespace Compras.API.Application.Manejadores
{
    public class CompraCreadaIntegracionHandler : INotificationHandler<CompraCreadaEvento>
    {
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CompraCreadaIntegracionHandler> _logger;

        public CompraCreadaIntegracionHandler(IInventarioServicio inventarioServicio, ILogger<CompraCreadaIntegracionHandler> logger)
        {
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task Handle(CompraCreadaEvento notification, CancellationToken cancellationToken)
        {
            _logger.LogInformation("Procesando actualización de inventario para la Compra {CompraId}", notification.CompraId);

            foreach (var item in notification.Items)
            {
                var success = await _inventarioServicio.RegistrarEntradaCompraAsync(
                    item.IdProducto, 
                    notification.IdAlmacen, 
                    item.Cantidad, 
                    notification.CompraId);

                if (!success)
                {
                    _logger.LogWarning("No se pudo actualizar el stock para el Producto {ProductoId} de la Compra {CompraId}", 
                        item.IdProducto, notification.CompraId);
                }
            }
        }
    }
}
