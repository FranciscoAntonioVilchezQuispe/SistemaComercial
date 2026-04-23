using Configuracion.API.Domain.Entidades;
using Configuracion.API.Infrastructure.Datos;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Configuracion.API.Tests.Integration.Endpoints
{
    public class TipoAfectacionIgvEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public TipoAfectacionIgvEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ConfiguracionDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<ConfiguracionDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbAfectacionIgv");
                    });
                });
            });
        }

        [Fact]
        public async Task GET_TipoAfectacionIgv_DebeRetornarLista()
        {
            // Arrange
            using (var scope = _factory.Services.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<ConfiguracionDbContext>();
                await context.Database.EnsureCreatedAsync();
                
                if (!await context.TiposAfectacionIgv.AnyAsync())
                {
                    context.TiposAfectacionIgv.Add(new TipoAfectacionIgv 
                    { 
                        Codigo = "10", 
                        Descripcion = "Gravado - Operación Onerosa",
                        EsGravado = true,
                        UsuarioCreacion = "SEED"
                    });
                    await context.SaveChangesAsync();
                }
            }
            
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/configuracion/tipo-afectacion/todos");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
            var result = await response.Content.ReadFromJsonAsync<Nucleo.Comun.Application.Wrappers.ToReturnList<TipoAfectacionIgv>>();
            result.Should().NotBeNull();
            result!.Data.Should().NotBeEmpty();
            result.Data.Any(x => x.Codigo == "10").Should().BeTrue();
        }
    }
}
