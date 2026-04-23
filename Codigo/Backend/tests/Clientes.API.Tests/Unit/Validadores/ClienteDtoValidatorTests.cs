using Clientes.API.Application.DTOs;
using FluentValidation.TestHelper;
using Xunit;

namespace Clientes.API.Tests.Unit.Validadores
{
    public class ClienteDtoValidatorTests
    {
        private readonly CrearClienteDtoValidator _validator;

        public ClienteDtoValidatorTests()
        {
            _validator = new CrearClienteDtoValidator();
        }

        [Fact]
        public void Validar_ConDniValido_DebePasar()
        {
            var dto = new CrearClienteDto { IdTipoDocumento = 1, NumeroDocumento = "45678901", RazonSocial = "Juan Perez" };
            var result = _validator.TestValidate(dto);
            result.ShouldNotHaveAnyValidationErrors();
        }

        [Fact]
        public void Validar_ConDniCorto_DebeFallar()
        {
            var dto = new CrearClienteDto { IdTipoDocumento = 1, NumeroDocumento = "123", RazonSocial = "Juan Perez" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.NumeroDocumento);
        }

        [Fact]
        public void Validar_ConRucValido_DebePasar()
        {
            // RUC SUNAT: 20100017491
            var dto = new CrearClienteDto { IdTipoDocumento = 6, NumeroDocumento = "20100017491", RazonSocial = "SUNAT" };
            var result = _validator.TestValidate(dto);
            result.ShouldNotHaveAnyValidationErrors();
        }

        [Fact]
        public void Validar_ConRucInvalido_DebeFallar()
        {
            var dto = new CrearClienteDto { IdTipoDocumento = 6, NumeroDocumento = "20100017490", RazonSocial = "SUNAT" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.NumeroDocumento);
        }

        [Fact]
        public void Validar_SinRazonSocial_DebeFallar()
        {
            var dto = new CrearClienteDto { IdTipoDocumento = 1, NumeroDocumento = "45678901", RazonSocial = "" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.RazonSocial);
        }
    }
}
