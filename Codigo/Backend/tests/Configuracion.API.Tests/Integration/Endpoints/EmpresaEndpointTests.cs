using Configuracion.API.Application.DTOs;
using Configuracion.API.Domain.Entidades;
using Configuracion.API.Infrastructure.Datos;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Nucleo.Tests.Shared.Helpers;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Configuracion.API.Tests.Integration.Endpoints
{
    public class EmpresaEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public EmpresaEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<ConfiguracionDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<ConfiguracionDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbEmpresa");
                    });
                });
            });
        }

        [Fact]
        public async Task GET_Empresa_DebeRetornar200()
        {
            // Arrange
            using (var scope = _factory.Services.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<ConfiguracionDbContext>();
                await context.Database.EnsureCreatedAsync();
                
                if (!await context.Empresas.AnyAsync())
                {
                    context.Empresas.Add(new Empresa 
                    { 
                        Ruc = "20123456789", 
                        RazonSocial = "Empresa Test SA", 
                        DireccionFiscal = "Lima, Peru",
                        UsuarioCreacion = "SEED"
                    });
                    await context.SaveChangesAsync();
                }
            }
            
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/empresa");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
        }

        [Fact]
        public async Task PUT_Empresa_ConDatosValidos_DebeActualizar()
        {
            // Arrange
            var dto = new EmpresaDto 
            { 
                Ruc = "20987654321", 
                RazonSocial = "Nueva Razon Social", 
                DireccionFiscal = "Nueva Direccion",
                MonedaPrincipal = "PEN"
            };
            var client = _factory.CreateClient();

            // Act
            var response = await client.PutAsJsonAsync("/api/empresa", dto);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
            var result = await response.Content.ReadFromJsonAsync<Nucleo.Comun.Application.Wrappers.ToReturn<Empresa>>();
            result.Should().NotBeNull();
            result!.Data.RazonSocial.Should().Be(dto.RazonSocial);
        }
    }
}
