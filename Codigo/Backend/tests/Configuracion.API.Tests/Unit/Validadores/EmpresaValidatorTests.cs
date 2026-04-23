using Configuracion.API.Application.DTOs;
using Configuracion.API.Application.Validadores;
using FluentValidation.TestHelper;
using Xunit;

namespace Configuracion.API.Tests.Unit.Validadores
{
    public class EmpresaValidatorTests
    {
        private readonly EmpresaDtoValidator _validator;

        public EmpresaValidatorTests()
        {
            _validator = new EmpresaDtoValidator();
        }

        [Fact]
        public void Validar_ConRucDe11Digitos_DebePasar()
        {
            var dto = new EmpresaDto { Ruc = "20123456789", RazonSocial = "Empresa Test", DireccionFiscal = "Direccion 123" };
            var result = _validator.TestValidate(dto);
            result.ShouldNotHaveValidationErrorFor(x => x.Ruc);
        }

        [Fact]
        public void Validar_ConRucMenorDe11Digitos_DebeFallar()
        {
            var dto = new EmpresaDto { Ruc = "2012345678" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.Ruc);
        }

        [Fact]
        public void Validar_ConRazonSocialVacia_DebeFallar()
        {
            var dto = new EmpresaDto { RazonSocial = "" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.RazonSocial);
        }

        [Fact]
        public void Validar_ConDireccionFiscalVacia_DebeFallar()
        {
            var dto = new EmpresaDto { DireccionFiscal = "" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.DireccionFiscal);
        }

        [Fact]
        public void Validar_ConCorreoInvalido_DebeFallar()
        {
            var dto = new EmpresaDto { CorreoContacto = "correo-invalido" };
            var result = _validator.TestValidate(dto);
            result.ShouldHaveValidationErrorFor(x => x.CorreoContacto);
        }
    }
}
