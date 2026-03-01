using Catalogo.Application.Comandos;
using Catalogo.Domain.Interfaces;
using MediatR;
using System.Threading;
using System.Threading.Tasks;

namespace Catalogo.Application.Manejadores
{
    public class ActualizarProductoManejador : IRequestHandler<ActualizarProductoComando, bool>
    {
        private readonly IProductoRepositorio _repositorio;

        public ActualizarProductoManejador(IProductoRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<bool> Handle(ActualizarProductoComando request, CancellationToken cancellationToken)
        {
            var producto = await _repositorio.ObtenerPorIdAsync(request.Id);
            if (producto == null) return false;

            // Información básica
            producto.CodigoProducto = request.Codigo;
            producto.NombreProducto = request.Nombre;
            producto.Descripcion = request.Descripcion;

            // Relaciones
            producto.IdCategoria = request.IdCategoria;
            producto.IdMarca = request.IdMarca;
            producto.IdUnidadMedida = request.IdUnidadMedida;
            // Tratar 0 como null para evitar violación de FK cuando no se selecciona tipo
            producto.IdTipoProducto = (request.IdTipoProducto.HasValue && request.IdTipoProducto.Value > 0)
                ? request.IdTipoProducto
                : null;

            // Códigos adicionales
            producto.CodigoBarras = string.IsNullOrWhiteSpace(request.CodigoBarras) ? null : request.CodigoBarras;
            producto.Sku = string.IsNullOrWhiteSpace(request.Sku) ? null : request.Sku;

            // Precios
            producto.EstablecerPrecios(
                request.PrecioCompra,
                request.PrecioVentaPublico,
                request.PrecioVentaMayorista,
                request.PrecioVentaDistribuidor
            );

            // Stock
            producto.StockMinimo = request.StockMinimo;
            producto.StockMaximo = request.StockMaximo;

            // Configuración de inventario
            producto.TieneVariantes = request.TieneVariantes;
            producto.PermiteInventarioNegativo = request.PermiteInventarioNegativo;

            // Configuración fiscal
            producto.GravadoImpuesto = request.GravadoImpuesto;
            producto.PorcentajeImpuesto = request.PorcentajeImpuesto;

            // Imagen
            producto.ImagenPrincipalUrl = request.ImagenPrincipalUrl;

            // Auditoría
            producto.Activado = request.Activo;

            await _repositorio.ActualizarAsync(producto);
            return true;
        }
    }
}
