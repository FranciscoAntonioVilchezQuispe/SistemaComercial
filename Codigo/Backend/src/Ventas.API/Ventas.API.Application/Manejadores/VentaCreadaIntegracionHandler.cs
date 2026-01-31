using MediatR;
using Microsoft.Extensions.Logging;
using Ventas.API.Application.Eventos;
using Ventas.API.Application.Interfaces;

namespace Ventas.API.Application.Manejadores
{
    public class VentaCreadaIntegracionHandler : INotificationHandler<VentaCreadaEvento>
    {
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<VentaCreadaIntegracionHandler> _logger;

        public VentaCreadaIntegracionHandler(IInventarioServicio inventarioServicio, ILogger<VentaCreadaIntegracionHandler> logger)
        {
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task Handle(VentaCreadaEvento notification, CancellationToken cancellationToken)
        {
            _logger.LogInformation("Procesando actualización de inventario para la Venta {VentaId}", notification.VentaId);

            foreach (var item in notification.Items)
            {
                var success = await _inventarioServicio.RegistrarSalidaVentaAsync(
                    item.IdProducto, 
                    notification.IdAlmacen, 
                    item.Cantidad, 
                    notification.VentaId);

                if (!success)
                {
                    _logger.LogWarning("No se pudo actualizar el stock para el Producto {ProductoId} de la Venta {VentaId}", 
                        item.IdProducto, notification.VentaId);
                }
            }
        }
    }
}
