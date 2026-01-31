using System.Net.Http.Json;
using Microsoft.Extensions.Logging;
using Ventas.API.Application.Interfaces;

namespace Ventas.API.Application.Integracion
{
    public class InventarioServicio : IInventarioServicio
    {
        private readonly HttpClient _httpClient;
        private readonly ILogger<InventarioServicio> _logger;

        public InventarioServicio(HttpClient httpClient, ILogger<InventarioServicio> logger)
        {
            _httpClient = httpClient;
            _logger = logger;
        }

        public async Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad, long idVenta)
        {
            try
            {
                // El endpoint en Inventario.API es POST /inventario/movimientos
                // Basado en CrearMovimientoInventarioComando.cs
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 20, // SAL_VEN (Salida por Venta)
                    Cantidad = cantidad,
                    ReferenciaModulo = "VENTAS",
                    IdReferencia = idVenta,
                    Observaciones = $"Salida automática por Venta #" + idVenta
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                var errorMsg = await response.Content.ReadAsStringAsync();
                _logger.LogError("Error al registrar movimiento en inventario: {Error}", errorMsg);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error de conexión con Inventario.API");
                return false;
            }
        }
    }
}
