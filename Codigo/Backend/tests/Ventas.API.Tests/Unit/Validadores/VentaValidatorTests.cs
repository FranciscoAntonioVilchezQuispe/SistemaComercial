using FluentValidation.TestHelper;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Domain.DTOs;
using System.Collections.Generic;
using Xunit;

namespace Ventas.API.Tests.Unit.Validadores
{
    public class VentaValidatorTests
    {
        private readonly CrearVentaComandoValidator _validator;

        public VentaValidatorTests()
        {
            _validator = new CrearVentaComandoValidator();
        }

        [Fact]
        public void Validar_VentaValida_DebePasar()
        {
            // Arrange
            var venta = new VentaDto
            {
                IdAlmacen = 1,
                IdCliente = 1,
                IdTipoComprobante = 1,
                Serie = "F001",
                Moneda = "PEN",
                TotalVenta = 118,
                Detalles = new List<DetalleVentaDto>
                {
                    new DetalleVentaDto
                    {
                        IdProducto = 1,
                        Cantidad = 1,
                        PrecioUnitario = 100,
                        CodigoAfectacionIgv = "10"
                    }
                }
            };
            var comando = new CrearVentaComando(venta);

            // Act
            var result = _validator.TestValidate(comando);

            // Assert
            result.ShouldNotHaveAnyValidationErrors();
        }

        [Fact]
        public void Validar_SinDetalles_DebeFallar()
        {
            var venta = new VentaDto { IdAlmacen = 1, IdCliente = 1, IdTipoComprobante = 1, Serie = "F001", Moneda = "PEN", TotalVenta = 100 };
            var comando = new CrearVentaComando(venta);
            var result = _validator.TestValidate(comando);
            result.ShouldHaveValidationErrorFor("Venta.Detalles");
        }

        [Fact]
        public void Validar_SerieInvalida_DebeFallar()
        {
            var venta = new VentaDto { Serie = "ABCD", IdAlmacen = 1, IdCliente = 1, IdTipoComprobante = 1 };
            var comando = new CrearVentaComando(venta);
            var result = _validator.TestValidate(comando);
            result.ShouldHaveValidationErrorFor("Venta.Serie");
        }
    }
}
