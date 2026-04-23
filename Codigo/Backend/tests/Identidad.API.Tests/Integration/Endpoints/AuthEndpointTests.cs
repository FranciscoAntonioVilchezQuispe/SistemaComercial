using FluentAssertions;
using Identidad.API.Application.Features.Auth.Login;
using Identidad.API.Infrastructure.Datos;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Identidad.API.Tests.Integration.Endpoints
{
    public class AuthEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public AuthEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<IdentidadDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<IdentidadDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbAuth");
                    });
                });
            });
        }

        [Fact]
        [Trait("Category", "Integration")]
        public async Task POST_Login_ConCredencialesInvalidas_DebeRetornar401()
        {
            // Arrange
            var client = _factory.CreateClient();
            var comando = new LoginComando { Username = "wrong", Password = "user" };

            // Act
            var response = await client.PostAsJsonAsync("/api/auth/login", comando);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
        }
    }
}
