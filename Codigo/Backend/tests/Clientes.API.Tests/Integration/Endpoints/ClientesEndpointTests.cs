using Clientes.API.Domain.Entidades;
using Clientes.API.Infrastructure.Datos;
using Clientes.API.Domain.Interfaces;
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
using Clientes.API.Domain.DTOs;

namespace Clientes.API.Tests.Integration.Endpoints
{
    public class ClientesEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;
        private readonly Mock<IClienteRepositorio> _repoMock;

        public ClientesEndpointTests(WebApplicationFactory<Program> factory)
        {
            _repoMock = new Mock<IClienteRepositorio>();
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(IClienteRepositorio));
                    if (descriptor != null) services.Remove(descriptor);
                    services.AddScoped(_ => _repoMock.Object);

                    var dbDescriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ClientesDbContext>));
                    if (dbDescriptor != null) services.Remove(dbDescriptor);
                    services.AddDbContext<ClientesDbContext>(options => options.UseInMemoryDatabase("TestDbClientesMock"));
                });
            });
        }

        [Fact]
        public async Task GET_Clientes_DebeRetornar200()
        {
            // Arrange
            _repoMock.Setup(x => x.ObtenerPaginadoAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>()))
                     .ReturnsAsync((new List<ClienteListDto>(), 0));

            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/clientes");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
