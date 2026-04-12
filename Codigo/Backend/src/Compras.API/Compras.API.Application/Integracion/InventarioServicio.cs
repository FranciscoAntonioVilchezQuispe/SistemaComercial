using System.Net.Http.Json;
using Microsoft.Extensions.Logging;
using Compras.API.Application.Interfaces;

namespace Compras.API.Application.Integracion
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

        public async Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idCompra, long idTipoComprobante, string serie, string numero, string codigoOperacionSunat = "02")

        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 19, // ING_COM (Ingreso por Compra)
                    Cantidad = cantidad,
                    CostoUnitario = costoUnitario,
                    ReferenciaModulo = "COMPRAS",

                    IdReferencia = idCompra,
                    Observaciones = $"Ingreso automático por Compra #" + idCompra,
                    IdTipoDocumento = idTipoComprobante,
                    SerieDocumento = serie,
                    NumeroDocumento = numero,
                    CodigoOperacionSunat = codigoOperacionSunat
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                var errorMsg = await response.Content.ReadAsStringAsync();
                _logger.LogError("Error al registrar ingreso en inventario: {Error}", errorMsg);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error de conexión con Inventario.API desde Compras");
                return false;
            }
        }

        public async Task<bool> EliminarMovimientosCompraAsync(long idCompra)
        {
            try
            {
                var response = await _httpClient.DeleteAsync($"inventario/movimientos/referencia/COMPRAS/{idCompra}");
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al eliminar movimientos en inventario para Compra {CompraId}", idCompra);
                return false;
            }
        }

        public async Task<bool> RegistrarSalidaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero, long idTipoComprobante, string codigoOperacionSunat = "07")
        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 24, // DevolucionCompra (NC Compra)
                    Cantidad = Math.Abs(cantidad),
                    ReferenciaModulo = "COMPRAS",
                    IdReferencia = idNota,
                    Observaciones = $"Salida por Devolución - Nota de Crédito #" + idNota,
                    IdTipoDocumento = idTipoComprobante,
                    SerieDocumento = serie,
                    NumeroDocumento = numero,
                    CodigoOperacionSunat = codigoOperacionSunat
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar salida por Nota de Crédito Compra {NotaId}", idNota);
                return false;
            }
        }

        public async Task<bool> RegistrarEntradaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idNota, string serie, string numero, long idTipoComprobante, string codigoOperacionSunat = "02")
        {
            try
            {
                var comando = new
                {
                    IdProducto = idProducto,
                    IdAlmacen = idAlmacen,
                    IdTipoMovimiento = 26, // NotaDebitoCompra (ND Compra)
                    Cantidad = cantidad,
                    CostoUnitario = costoUnitario,
                    ReferenciaModulo = "COMPRAS",
                    IdReferencia = idNota,
                    Observaciones = $"Ingreso adicional por Nota de Débito #" + idNota,
                    IdTipoDocumento = idTipoComprobante,
                    SerieDocumento = serie,
                    NumeroDocumento = numero,
                    CodigoOperacionSunat = codigoOperacionSunat
                };

                var response = await _httpClient.PostAsJsonAsync("inventario/movimientos", comando);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar entrada por Nota de Débito Compra {NotaId}", idNota);
                return false;
            }
        }
    }
}
