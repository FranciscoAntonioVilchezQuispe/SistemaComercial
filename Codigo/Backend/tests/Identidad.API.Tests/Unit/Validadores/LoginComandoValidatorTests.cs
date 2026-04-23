using FluentAssertions;
using Identidad.API.Application.Features.Auth.Login;
using Xunit;

namespace Identidad.API.Tests.Unit.Validadores
{
    public class LoginComandoValidatorTests
    {
        private readonly LoginComandoValidator _validator;

        public LoginComandoValidatorTests()
        {
            _validator = new LoginComandoValidator();
        }

        [Fact]
        public void Validar_ConUsernameVacio_DebeFallar()
        {
            var comando = new LoginComando { Username = "", Password = "123" };
            var result = _validator.Validate(comando);
            result.IsValid.Should().BeFalse();
        }
    }
}
