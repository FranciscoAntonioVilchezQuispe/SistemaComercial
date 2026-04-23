using Ventas.API.Infrastructure.Datos;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Domain.DTOs;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Xunit;

namespace Ventas.API.Tests.Integration.Endpoints
{
    public class VentasEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;
        private readonly Mock<IVentaRepositorio> _ventaRepoMock = new();

        public VentasEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    // Reemplazar DbContext con InMemory
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<VentasDbContext>));
                    if (descriptor != null) services.Remove(descriptor);
                    services.AddDbContext<VentasDbContext>(options => options.UseInMemoryDatabase("TestDbVentas"));

                    // Reemplazar repositorio real con Mock para evitar errores de Dapper
                    var repoDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IVentaRepositorio));
                    if (repoDescriptor != null) services.Remove(repoDescriptor);
                    services.AddScoped<IVentaRepositorio>(_ => _ventaRepoMock.Object);
                });
            });
        }

        [Fact]
        public async Task GET_Ventas_DebeRetornar200()
        {
            // Arrange
            _ventaRepoMock.Setup(x => x.ObtenerPaginadoAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .ReturnsAsync((new System.Collections.Generic.List<VentaListDto>(), 0));

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/ventas");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
