using Catalogo.Application.Comandos;
using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using MediatR;
using System.Threading;
using System.Threading.Tasks;

namespace Catalogo.Application.Manejadores
{
    public class CrearProductoManejador : IRequestHandler<CrearProductoComando, long>
    {
        private readonly IProductoRepositorio _repositorio;

        public CrearProductoManejador(IProductoRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<long> Handle(CrearProductoComando request, CancellationToken cancellationToken)
        {
            var nuevoProducto = new Producto(
                request.Codigo,
                request.Nombre,
                request.IdCategoria,
                request.IdMarca,
                request.IdUnidadMedida
            )
            {
                Descripcion = request.Descripcion,
                IdTipoProducto = request.IdTipoProducto,

                // Códigos adicionales
                CodigoBarras = request.CodigoBarras,
                Sku = request.Sku,

                // Stock
                StockMinimo = request.StockMinimo,
                StockMaximo = request.StockMaximo,

                // Configuración de inventario
                TieneVariantes = request.TieneVariantes,
                PermiteInventarioNegativo = request.PermiteInventarioNegativo,

                // Configuración fiscal
                GravadoImpuesto = request.GravadoImpuesto,
                PorcentajeImpuesto = request.PorcentajeImpuesto,

                // Imagen
                ImagenPrincipalUrl = request.ImagenPrincipalUrl
            };

            // Establecer todos los precios
            nuevoProducto.EstablecerPrecios(
                request.PrecioCompra,
                request.PrecioVentaPublico,
                request.PrecioVentaMayorista,
                request.PrecioVentaDistribuidor
            );

            await _repositorio.AgregarAsync(nuevoProducto);

            return nuevoProducto.Id;
        }
    }
}

