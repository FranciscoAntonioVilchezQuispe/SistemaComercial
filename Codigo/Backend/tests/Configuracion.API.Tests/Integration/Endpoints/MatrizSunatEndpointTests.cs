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
    public class MatrizSunatEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public MatrizSunatEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ConfiguracionDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<ConfiguracionDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbMatrizSunat");
                    });
                });
            });
        }

        [Fact]
        public async Task GET_MatrizSunat_DebeRetornarLista()
        {
            // Arrange
            using (var scope = _factory.Services.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<ConfiguracionDbContext>();
                await context.Database.EnsureCreatedAsync();
                
                if (!await context.MatrizReglasSunat.AnyAsync())
                {
                    var op = new TipoOperacionSunat { Codigo = "0101", Nombre = "Venta Interna", UsuarioCreacion = "SEED" };
                    var comp = new TipoComprobante { Codigo = "01", Nombre = "Factura", UsuarioCreacion = "SEED" };
                    context.TiposOperacionSunat.Add(op);
                    context.TiposComprobante.Add(comp);
                    await context.SaveChangesAsync();

                    context.MatrizReglasSunat.Add(new MatrizReglaSunat 
                    { 
                        IdTipoComprobante = comp.Id,
                        IdTipoOperacion = op.Id,
                        NivelObligatoriedad = 1,
                        UsuarioCreacion = "SEED"
                    });
                    await context.SaveChangesAsync();
                }
            }
            
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/configuracion/matriz-sunat");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}
