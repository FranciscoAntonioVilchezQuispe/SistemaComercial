using FluentAssertions;
using Identidad.API.Infrastructure.Servicios;
using Xunit;

namespace Identidad.API.Tests.Unit.Servicios
{
    public class BCryptPasswordHasherTests
    {
        private readonly BCryptPasswordHasher _hasher;

        public BCryptPasswordHasherTests()
        {
            _hasher = new BCryptPasswordHasher();
        }

        [Fact]
        public void Hashear_ConPasswordValido_DebeRetornarHashDistintoAlTextoOriginal()
        {
            var password = "Password123!";
            var hash = _hasher.HashPassword(password);
            hash.Should().NotBeNullOrEmpty();
            hash.Should().NotBe(password);
        }

        [Fact]
        public void Hashear_MismoPassword_DebeGenerarHashesDiferentes()
        {
            var password = "Password123!";
            var hash1 = _hasher.HashPassword(password);
            var hash2 = _hasher.HashPassword(password);
            hash1.Should().NotBe(hash2);
        }

        [Fact]
        public void Verificar_ConPasswordCorrecto_DebeRetornarTrue()
        {
            var password = "Password123!";
            var hash = _hasher.HashPassword(password);
            var result = _hasher.VerifyPassword(password, hash);
            result.Should().BeTrue();
        }

        [Fact]
        public void Verificar_ConPasswordIncorrecto_DebeRetornarFalse()
        {
            var password = "Password123!";
            var wrongPassword = "WrongPassword";
            var hash = _hasher.HashPassword(password);
            var result = _hasher.VerifyPassword(wrongPassword, hash);
            result.Should().BeFalse();
        }

        [Fact]
        public void Verificar_ConHashVacio_DebeRetornarFalse()
        {
            var password = "Password123!";
            var result = _hasher.VerifyPassword(password, "");
            result.Should().BeFalse();
        }
    }
}
