using FluentValidation.TestHelper;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Validators;
using Xunit;

namespace Inventario.API.Tests.Unit.Validadores
{
    public class MovimientoInventarioValidatorTests
    {
        private readonly CrearMovimientoInventarioComandoValidator _validator;

        public MovimientoInventarioValidatorTests()
        {
            _validator = new CrearMovimientoInventarioComandoValidator();
        }

        [Fact]
        public void Validar_ConDatosValidos_DebePasar()
        {
            var comando = new CrearMovimientoInventarioComando(1, 1, 1, 10.5m, 100, "COMPRAS", 1, "Compra", 1, "F001", "1");
            var result = _validator.TestValidate(comando);
            result.ShouldNotHaveAnyValidationErrors();
        }

        [Fact]
        public void Validar_ConCantidadCero_DebeFallar()
        {
            var comando = new CrearMovimientoInventarioComando(1, 1, 1, 0, 100, null, null, null, null, null, null);
            var result = _validator.TestValidate(comando);
            result.ShouldHaveValidationErrorFor(x => x.Cantidad);
        }

        [Fact]
        public void Validar_ConSerieInvalida_DebeFallar()
        {
            var comando = new CrearMovimientoInventarioComando(1, 1, 1, 10, 100, null, null, null, null, "ABCD", "1");
            var result = _validator.TestValidate(comando);
            result.ShouldHaveValidationErrorFor(x => x.SerieDocumento);
        }

        [Fact]
        public void Validar_SinProducto_DebeFallar()
        {
            var comando = new CrearMovimientoInventarioComando(0, 1, 1, 10, 100, null, null, null, null, null, null);
            var result = _validator.TestValidate(comando);
            result.ShouldHaveValidationErrorFor(x => x.IdProducto);
        }
    }
}
