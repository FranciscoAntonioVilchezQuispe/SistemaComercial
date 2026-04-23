using Contabilidad.API.Infrastructure.Datos;
using Contabilidad.API.Domain.Interfaces;
using Contabilidad.API.Domain.DTOs;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Xunit;

namespace Contabilidad.API.Tests.Integration.Endpoints
{
    public class ContabilidadEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;
        private readonly Mock<IAsientoRepositorio> _asientoRepoMock = new();

        public ContabilidadEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ContabilidadDbContext>));
                    if (descriptor != null) services.Remove(descriptor);
                    services.AddDbContext<ContabilidadDbContext>(options => options.UseInMemoryDatabase("TestDbContabilidad"));

                    var repoDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IAsientoRepositorio));
                    if (repoDescriptor != null) services.Remove(repoDescriptor);
                    services.AddScoped<IAsientoRepositorio>(_ => _asientoRepoMock.Object);
                });
            });
        }

        [Fact]
        public async Task GET_Asientos_DebeRetornar200()
        {
            // Arrange
            _asientoRepoMock.Setup(x => x.ObtenerPaginadoAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                .ReturnsAsync((new System.Collections.Generic.List<AsientoListDto>(), 0));

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/asientos");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
