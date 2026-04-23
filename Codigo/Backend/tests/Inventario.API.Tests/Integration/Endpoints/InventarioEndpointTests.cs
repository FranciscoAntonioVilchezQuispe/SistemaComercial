using Inventario.API.Infrastructure.Datos;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Inventario.API.Tests.Integration.Endpoints
{
    public class InventarioEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public InventarioEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<InventarioDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<InventarioDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbInventarioEndpoints");
                    });
                });
            });
        }

        [Fact]
        public async Task GET_Almacenes_DebeRetornar200()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/inventario/almacenes");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }

        [Fact]
        public async Task GET_Stocks_DebeRetornar200()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/inventario/stock");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
