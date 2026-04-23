using Catalogo.Application.Comandos;
using Catalogo.Application.Manejadores;
using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using FluentAssertions;
using Moq;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Catalogo.API.Tests.Unit.Manejadores
{
    public class CrearProductoManejadorTests
    {
        private readonly Mock<IProductoRepositorio> _repoMock;
        private readonly CrearProductoManejador _handler;

        public CrearProductoManejadorTests()
        {
            _repoMock = new Mock<IProductoRepositorio>();
            _handler = new CrearProductoManejador(_repoMock.Object);
        }

        [Fact]
        public async Task Handle_ConDatosValidos_DebeRetornarId()
        {
            // Arrange
            var comando = new CrearProductoComando(
                "P001", "Producto Test", "Desc", 1, 1, 1, 1,
                "12345", "SKU001", 10.0m, 15.0m, 14.0m, 13.0m,
                1.0m, 100.0m, false, false, "PP", true, 18.0m, 1, 1, null
            );

            _repoMock.Setup(x => x.AgregarAsync(It.IsAny<Producto>()))
                     .ReturnsAsync((Producto p) => { p.Id = 1; return p; });

            // Act
            var result = await _handler.Handle(comando, CancellationToken.None);

            // Assert
            result.Should().Be(1);
            _repoMock.Verify(x => x.AgregarAsync(It.IsAny<Producto>()), Times.Once);
        }
    }
}
