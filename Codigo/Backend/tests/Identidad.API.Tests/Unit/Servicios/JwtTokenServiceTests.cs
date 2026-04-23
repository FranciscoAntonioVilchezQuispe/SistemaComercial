using FluentAssertions;
using Identidad.API.Domain.Entidades;
using Identidad.API.Infrastructure.Servicios;
using Microsoft.Extensions.Configuration;
using Moq;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using Xunit;

namespace Identidad.API.Tests.Unit.Servicios
{
    public class JwtTokenServiceTests
    {
        private readonly Mock<IConfiguration> _configMock;
        private readonly JwtTokenService _service;
        private const string SecretKey = "SUPER_SECRET_KEY_PROVISIONAL_1234567890_LONGER_FOR_TEST";

        public JwtTokenServiceTests()
        {
            _configMock = new Mock<IConfiguration>();
            _configMock.Setup(x => x["Jwt:SecretKey"]).Returns(SecretKey);
            _configMock.Setup(x => x["Jwt:Issuer"]).Returns("SistemaComercial");
            _configMock.Setup(x => x["Jwt:Audience"]).Returns("IdentidadAPI");
            _configMock.Setup(x => x["Jwt:ExpirationMinutes"]).Returns("60");

            _service = new JwtTokenService(_configMock.Object);
        }

        [Fact]
        public void GenerarToken_ConUsuarioValido_DebeIncluirClaimUserId()
        {
            var usuario = new Usuario { Id = 1, Username = "testuser", Email = "test@example.com" };
            var token = _service.GenerarTokenJwt(usuario, new List<string> { "USER" }, new List<string> { "VENTAS:VER" });
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(token);
            jwtToken.Claims.First(c => c.Type == JwtRegisteredClaimNames.Sub).Value.Should().Be("1");
        }

        [Fact]
        public void GenerarToken_ConRolAdmin_DebeIncluirClaimRol()
        {
            var usuario = new Usuario { Id = 1, Username = "admin", Email = "admin@example.com" };
            var token = _service.GenerarTokenJwt(usuario, new List<string> { "ADMINISTRADOR" }, new List<string>());
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(token);
            var roleClaims = jwtToken.Claims.Where(c => c.Type == ClaimTypes.Role || c.Type == "role" || c.Type == "roles").Select(c => c.Value);
            roleClaims.Should().Contain(c => c.Equals("ADMINISTRADOR", System.StringComparison.OrdinalIgnoreCase));
        }

        [Fact]
        public void GenerarToken_DebeUsarIssuerYAudienceCorrectos()
        {
            var usuario = new Usuario { Id = 1, Username = "user", Email = "user@example.com" };
            var token = _service.GenerarTokenJwt(usuario, new List<string>(), new List<string>());
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(token);
            jwtToken.Issuer.Should().Be("SistemaComercial");
            jwtToken.Audiences.Should().Contain("IdentidadAPI");
        }

        [Fact]
        public void GenerarRefreshToken_DebeRetornarStringBase64NoVacio()
        {
            var refreshToken = _service.GenerarRefreshToken();
            refreshToken.Should().NotBeNullOrEmpty();
            refreshToken.Length.Should().BeGreaterThan(20);
        }
    }
}
