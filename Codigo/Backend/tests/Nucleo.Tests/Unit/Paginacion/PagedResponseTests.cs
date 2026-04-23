using FluentAssertions;
using Nucleo.Comun.Application.Paginacion;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;

namespace Nucleo.Tests.Unit.Paginacion
{
    public class PagedResponseTests
    {
        [Fact]
        public async Task Crear_ConTotalMayorQuePageSize_DebeCalcularTotalPaginasCorrectamente()
        {
            // Arrange
            var data = new List<string> { "item1", "item2" };
            int total = 25;
            int pageSize = 10;
            int pageNumber = 1;

            // Act
            var response = new PagedResponse<string>(data, pageNumber, pageSize, total);

            // Assert
            response.TotalPages.Should().Be(3);
            await Task.CompletedTask;
        }

        [Fact]
        public async Task Crear_ConPagina1_DebeIndicarQueNoHayPaginaAnterior()
        {
            // Arrange
            var data = new List<string> { "item1" };
            int total = 10;
            int pageSize = 10;
            int pageNumber = 1;

            // Act
            var response = new PagedResponse<string>(data, pageNumber, pageSize, total);

            // Assert
            response.HasPreviousPage.Should().BeFalse();
            await Task.CompletedTask;
        }

        [Fact]
        public async Task Crear_ConUltimaPagina_DebeIndicarQueNoHayPaginaSiguiente()
        {
            // Arrange
            var data = new List<string> { "item1" };
            int total = 20;
            int pageSize = 10;
            int pageNumber = 2;

            // Act
            var response = new PagedResponse<string>(data, pageNumber, pageSize, total);

            // Assert
            response.HasNextPage.Should().BeFalse();
            await Task.CompletedTask;
        }

        [Fact]
        public async Task Crear_ConTotal0_DebeRetornarCeroTotalPaginas()
        {
            // Arrange
            var data = new List<string>();
            int total = 0;
            int pageSize = 10;
            int pageNumber = 1;

            // Act
            var response = new PagedResponse<string>(data, pageNumber, pageSize, total);

            // Assert
            response.TotalPages.Should().Be(0);
            await Task.CompletedTask;
        }
    }
}
