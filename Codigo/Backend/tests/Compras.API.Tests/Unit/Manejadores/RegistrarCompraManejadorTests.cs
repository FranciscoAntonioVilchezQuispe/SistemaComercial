using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Domain.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Application.Manejadores;
using Compras.API.Domain.Entidades;
using Compras.API.Infrastructure.Datos;
using FluentAssertions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Compras.API.Tests.Unit.Manejadores
{
    public class RegistrarCompraManejadorTests : IDisposable
    {
        private readonly ComprasDbContext _context;
        private readonly Mock<IMediator> _mediatorMock;
        private readonly CrearCompraManejador _manejador;

        public RegistrarCompraManejadorTests()
        {
            var options = new DbContextOptionsBuilder<ComprasDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            _context = new ComprasDbContext(options);
            _mediatorMock = new Mock<IMediator>();

            _manejador = new CrearCompraManejador(_context, _mediatorMock.Object);
        }

        [Fact]
        public async Task Handle_CompraValida_DebeGuardarYPublicarEvento()
        {
            // Arrange
            var compraDto = new CompraDto
            {
                IdProveedor = 1,
                IdAlmacen = 1,
                IdTipoComprobante = 1,
                SerieComprobante = "F001",
                NumeroComprobante = "123",
                Total = 1000,
                Detalles = new List<DetalleCompraDto>
                {
                    new DetalleCompraDto
                    {
                        IdProducto = 1,
                        Cantidad = 10,
                        PrecioUnitarioCompra = 100,
                        Subtotal = 1000,
                        AfectacionIgv = "10"
                    }
                }
            };
            var comando = new CrearCompraComando(compraDto);

            // Act
            var result = await _manejador.Handle(comando, CancellationToken.None);

            // Assert
            result.Should().BeGreaterThan(0);
            
            var compraGuardada = await _context.Compras.Include(c => c.Detalles).FirstOrDefaultAsync(c => c.Id == result);
            compraGuardada.Should().NotBeNull();
            compraGuardada!.Detalles.Should().HaveCount(1);
            compraGuardada.Total.Should().Be(1000);

            _mediatorMock.Verify(m => m.Publish(It.IsAny<INotification>(), It.IsAny<CancellationToken>()), Times.Once);
        }

        public void Dispose()
        {
            _context.Database.EnsureDeleted();
            _context.Dispose();
        }
    }
}
