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
    public class ActualizarProductoManejadorTests
    {
        private readonly Mock<IProductoRepositorio> _repoMock;
        private readonly ActualizarProductoManejador _handler;

        public ActualizarProductoManejadorTests()
        {
            _repoMock = new Mock<IProductoRepositorio>();
            _handler = new ActualizarProductoManejador(_repoMock.Object);
        }

        [Fact]
        public async Task Handle_ConProductoExistente_DebeRetornarTrue()
        {
            // Arrange
            var productoExistente = new Producto("P001", "Viejo", 1, 1, 1);
            _repoMock.Setup(x => x.ObtenerPorIdAsync(It.IsAny<long>()))
                     .ReturnsAsync(productoExistente);

            var comando = new ActualizarProductoComando(
                1, "P001", "Nuevo", "Desc", 1, 1, 1, 1,
                "123", "SKU", 10, 15, 14, 13, 1, 100,
                false, false, "PP", true, 18, 1, 1, null, true
            );

            // Act
            var result = await _handler.Handle(comando, CancellationToken.None);

            // Assert
            result.Should().BeTrue();
            _repoMock.Verify(x => x.ActualizarAsync(It.IsAny<Producto>()), Times.Once);
        }

        [Fact]
        public async Task Handle_ConProductoInexistente_DebeRetornarFalse()
        {
            // Arrange
            _repoMock.Setup(x => x.ObtenerPorIdAsync(It.IsAny<long>()))
                     .ReturnsAsync((Producto)null!);

            var comando = new ActualizarProductoComando(
                99, "P001", "Nuevo", "Desc", 1, 1, 1, 1,
                "123", "SKU", 10, 15, 14, 13, 1, 100,
                false, false, "PP", true, 18, 1, 1, null, true
            );

            // Act
            var result = await _handler.Handle(comando, CancellationToken.None);

            // Assert
            result.Should().BeFalse();
        }
    }
}
