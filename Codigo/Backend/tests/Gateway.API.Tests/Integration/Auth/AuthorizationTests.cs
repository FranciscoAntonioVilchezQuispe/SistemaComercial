using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Nucleo.Tests.Shared.Helpers;
using System.Net;
using System.Threading.Tasks;
using Xunit;

namespace Gateway.API.Tests.Integration.Auth
{
    public class AuthorizationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public AuthorizationTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory;
        }

        [Fact]
        public async Task Request_SinToken_AEndpointProtegido_DebeRetornar401()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/productos");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        }

        [Fact]
        public async Task Request_ConTokenAdmin_AEndpointAdmin_DebeRetornar200_SiElBackendRespondiera()
        {
            // Arrange
            var token = AuthHelper.GenerarTokenAdmin();
            var client = _factory.CreateClient().ConToken(token);

            // Act
            // Nota: Como no tenemos los backends corriendo, YARP intentará conectar y fallará con 502/504
            // Pero el middleware de seguridad del Gateway debería dejarlo pasar antes de eso.
            var response = await client.GetAsync("/api/usuarios");

            // Assert
            // Si llega a YARP y falla por no encontrar el backend, retornará 502 Bad Gateway
            // Pero NO debería ser 401 ni 403.
            response.StatusCode.Should().NotBe(HttpStatusCode.Unauthorized);
            response.StatusCode.Should().NotBe(HttpStatusCode.Forbidden);
        }

        [Fact]
        public async Task Request_ConTokenVendedor_AEndpointAdmin_DebeRetornar403()
        {
            // Arrange
            var token = AuthHelper.GenerarTokenVendedor();
            var client = _factory.CreateClient().ConToken(token);

            // Act
            var response = await client.PostAsync("/api/usuarios", null);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
        }
    }
}
