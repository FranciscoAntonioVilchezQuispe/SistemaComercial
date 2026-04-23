using Catalogo.Domain.Entidades;
using Catalogo.Infrastructure.Datos;
using Catalogo.Domain.Interfaces;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;
using Xunit.Abstractions;
using Catalogo.Domain.DTOs;

namespace Catalogo.API.Tests.Integration.Endpoints
{
    public class ProductosEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;
        private readonly Mock<IProductoRepositorio> _repoMock;

        public ProductosEndpointTests(WebApplicationFactory<Program> factory)
        {
            _repoMock = new Mock<IProductoRepositorio>();
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    // Reemplazar el repositorio real por el mock
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IProductoRepositorio));
                    if (descriptor != null) services.Remove(descriptor);
                    services.AddScoped(_ => _repoMock.Object);

                    // También configurar DB in-memory para evitar errores de conexión al iniciar el host
                    var dbDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<CatalogoDbContext>));
                    if (dbDescriptor != null) services.Remove(dbDescriptor);
                    services.AddDbContext<CatalogoDbContext>(options => options.UseInMemoryDatabase("TestDbCatalogoMock"));
                });
            });
        }

        [Fact]
        public async Task GET_Productos_DebeRetornar200()
        {
            // Arrange
            _repoMock.Setup(x => x.ObtenerPaginadoAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                     .ReturnsAsync((new List<ProductoListDto>(), 0));

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/productos");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }

        [Fact]
        public async Task GET_ProductoPorId_Inexistente_DebeRetornar404()
        {
            // Arrange
            _repoMock.Setup(x => x.ObtenerDetallePorIdAsync(It.IsAny<long>()))
                     .ReturnsAsync((ProductoDetalleDto)null!);

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/productos/9999");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    }
}
