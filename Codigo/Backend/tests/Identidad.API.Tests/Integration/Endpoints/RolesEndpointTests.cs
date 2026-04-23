using FluentAssertions;
using Identidad.API.Domain.Entidades;
using Identidad.API.Infrastructure.Datos;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Nucleo.Comun.Application.Wrappers;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Identidad.API.Tests.Integration.Endpoints
{
    public class RolesEndpointTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public RolesEndpointTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(DbContextOptions<IdentidadDbContext>));
                    if (descriptor != null) services.Remove(descriptor);

                    services.AddDbContext<IdentidadDbContext>(options =>
                    {
                        options.UseInMemoryDatabase("TestDbRoles");
                    });
                });
            });
        }

        private async Task SeedRolesAsync(IdentidadDbContext context)
        {
            if (!context.Roles.Any())
            {
                context.Roles.AddRange(
                    new Rol { Id = 1, NombreRol = "ADMINISTRADOR", Descripcion = "Admin" },
                    new Rol { Id = 2, NombreRol = "VENDEDOR", Descripcion = "Vendedor" }
                );
                await context.SaveChangesAsync();
            }
        }

        [Fact]
        [Trait("Category", "Integration")]
        public async Task GET_Roles_DebeRetornarListaDeRoles()
        {
            // Arrange
            var client = _factory.CreateClient();
            using (var scope = _factory.Services.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<IdentidadDbContext>();
                await SeedRolesAsync(context);
            }

            // Act
            var response = await client.GetAsync("/api/roles");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.OK);
            var result = await response.Content.ReadFromJsonAsync<ToReturnList<Rol>>();
            result.Should().NotBeNull();
            result!.Data.Should().HaveCountGreaterOrEqualTo(2);
        }

        [Fact]
        [Trait("Category", "Integration")]
        public async Task GET_RolPorId_Inexistente_DebeRetornar404()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/roles/999");

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.NotFound);
        }
    }
}
