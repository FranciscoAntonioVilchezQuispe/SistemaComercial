using Configuracion.API.Application.Validadores;
using Configuracion.API.Application.DTOs;
using FluentValidation.TestHelper;
using Xunit;

namespace Configuracion.API.Tests.Unit.Validadores
{
    public class SerieComprobanteValidatorTests
    {
        private readonly SerieComprobanteDtoValidator _validator;

        public SerieComprobanteValidatorTests()
        {
            _validator = new SerieComprobanteDtoValidator();
        }

        [Theory]
        [InlineData("F001")]
        [InlineData("B001")]
        [InlineData("FC01")]
        [InlineData("FD01")]
        public void Validar_ConSerieValida_DebePasar(string serie)
        {
            var dto = new SerieComprobanteDto { Serie = serie, IdTipoComprobante = 1, CorrelativoActual = 1 };
            var result = _validator.TestValidate(dto);
            result.ShouldNotHaveValidationErrorFor(x => x.Serie);
        }

        [Theory]
        [InlineData("A001")]
        [InlineData("F0011")]
        [InlineData("F01")]
        [InlineData("")]
        public void Validar_ConSerieInvalida_DebeFallar(string serie)
        {
            var dto = new SerieComprobanteDto { Serie = serie };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.Serie);
        }

        [Fact]
        public void Validar_ConIdTipoComprobanteCero_DebeFallar()
        {
            var dto = new SerieComprobanteDto { IdTipoComprobante = 0 };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.IdTipoComprobante);
        }

        [Fact]
        public void Validar_ConCorrelativoNegativo_DebeFallar()
        {
            var dto = new SerieComprobanteDto { CorrelativoActual = -1 };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.CorrelativoActual);
        }
    }
}
