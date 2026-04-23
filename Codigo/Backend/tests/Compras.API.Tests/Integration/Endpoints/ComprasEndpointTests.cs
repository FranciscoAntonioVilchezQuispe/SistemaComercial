using Compras.API.Infrastructure.Datos;
using Compras.API.Domain.Interfaces;
using Compras.API.Domain.DTOs;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Xunit;

namespace Compras.API.Tests.Integration.Endpoints
{
    public class ComprasEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;
        private readonly Mock<ICompraRepositorio> _compraRepoMock = new();

        public ComprasEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ComprasDbContext>));
                    if (descriptor != null) services.Remove(descriptor);
                    services.AddDbContext<ComprasDbContext>(options => options.UseInMemoryDatabase("TestDbCompras"));

                    var repoDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(ICompraRepositorio));
                    if (repoDescriptor != null) services.Remove(repoDescriptor);
                    services.AddScoped<ICompraRepositorio>(_ => _compraRepoMock.Object);
                });
            });
        }

        [Fact]
        public async Task GET_Compras_DebeRetornar200()
        {
            // Arrange
            _compraRepoMock.Setup(x => x.ObtenerPaginadoAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .ReturnsAsync((new System.Collections.Generic.List<CompraListDto>(), 0));

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/compras");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
