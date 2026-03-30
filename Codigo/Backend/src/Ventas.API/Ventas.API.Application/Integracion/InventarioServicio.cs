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

        public async Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad, long idVenta, long idTipoComprobante, string serie, string numero)
        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 20, // SAL_VEN (Salida por Venta)
                    Cantidad = cantidad,
                    ReferenciaModulo = "VENTAS",
                    IdReferencia = idVenta,
                    Observaciones = $"Salida automática por Venta #" + idVenta,
                    IdTipoDocumento = idTipoComprobante,
                    SerieDocumento = serie,
                    NumeroDocumento = numero
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

        public async Task<bool> AnularMovimientosVentaAsync(long idVenta)
        {
            try
            {
                var response = await _httpClient.DeleteAsync($"inventario/movimientos/referencia/VENTAS/{idVenta}");
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al anular movimientos en inventario para Venta {VentaId}", idVenta);
                return false;
            }
        }

        public async Task<bool> RegistrarEntradaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero)
        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 10, // ENT_DEV (Entrada por Devolución)
                    Cantidad = cantidad,
                    ReferenciaModulo = "NC_VENTA",
                    IdReferencia = idNota,
                    Observaciones = $"Reingreso por Nota de Crédito #" + idNota,
                    IdTipoDocumento = "07",
                    SerieDocumento = serie,
                    NumeroDocumento = numero
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar entrada por Nota de Crédito {NotaId}", idNota);
                return false;
            }
        }

        public async Task<bool> RegistrarSalidaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero)
        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 20, // SAL_VEN
                    Cantidad = cantidad,
                    ReferenciaModulo = "ND_VENTA",
                    IdReferencia = idNota,
                    Observaciones = $"Salida por Nota de Débito #" + idNota,
                    IdTipoDocumento = "08",
                    SerieDocumento = serie,
                    NumeroDocumento = numero
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar salida por Nota de Débito {NotaId}", idNota);
                return false;
            }
        }
    }
}
