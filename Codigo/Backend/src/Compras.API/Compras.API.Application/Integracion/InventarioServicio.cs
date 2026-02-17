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

        public async Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idCompra)

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
                    Observaciones = $"Ingreso automático por Compra #" + idCompra
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
    }
}
