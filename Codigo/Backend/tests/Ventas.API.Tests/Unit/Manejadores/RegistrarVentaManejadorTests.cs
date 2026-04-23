using FluentAssertions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Domain.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Application.Manejadores;
using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Entidades.Referencias;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Datos;
using Xunit;

namespace Ventas.API.Tests.Unit.Manejadores
{
    public class RegistrarVentaManejadorTests : IDisposable
    {
        private readonly VentasDbContext _context;
        private readonly Mock<IVentaRepositorio> _ventaRepoMock;
        private readonly Mock<IMediator> _mediatorMock;
        private readonly CrearVentaManejador _manejador;

        public RegistrarVentaManejadorTests()
        {
            var options = new DbContextOptionsBuilder<VentasDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            _context = new VentasDbContext(options);
            _ventaRepoMock = new Mock<IVentaRepositorio>();
            _mediatorMock = new Mock<IMediator>();

            _manejador = new CrearVentaManejador(_context, _ventaRepoMock.Object, _mediatorMock.Object);
        }

        [Fact]
        public async Task Handle_VentaValida_DebeCalcularTotalesCorrectamente()
        {
            // Arrange
            _context.ImpuestosRef.Add(new ImpuestoReferencia { Id = 1, CodigoSunat = "1000", Porcentaje = 18, Nombre = "IGV" });
            _context.Clientes.Add(new Cliente { Id = 1, NumeroDocumento = "20123456789", IdTipoDocumento = 1, RazonSocial = "Test" });
            _context.ProductosRef.Add(new ProductoRef { Id = 1, IdTipoAfectacionIgv = 1, Nombre = "Producto Test" });
            _context.TiposAfectacionIgvRef.Add(new TipoAfectacionIgvRef { Id = 1, CodigoSunat = "10", EsGravado = true, Descripcion = "Gravado" });
            await _context.SaveChangesAsync();

            _ventaRepoMock.Setup(x => x.ObtenerSiguienteCorrelativoAsync(It.IsAny<long>(), It.IsAny<long>(), It.IsAny<string>()))
                .ReturnsAsync(1);

            var ventaDto = new VentaDto
            {
                IdAlmacen = 1,
                IdCliente = 1,
                IdTipoComprobante = 1,
                Serie = "F001",
                Moneda = "PEN",
                Detalles = new List<DetalleVentaDto>
                {
                    new DetalleVentaDto
                    {
                        IdProducto = 1,
                        Cantidad = 1,
                        PrecioUnitario = 118, // Incluye IGV
                        CodigoAfectacionIgv = "10"
                    }
                }
            };
            var comando = new CrearVentaComando(ventaDto);

            // Act
            var result = await _manejador.Handle(comando, CancellationToken.None);

            // Assert
            result.SubtotalGravado.Should().Be(100);
            result.TotalImpuesto.Should().Be(18);
            result.TotalVenta.Should().Be(118);
            
            _mediatorMock.Verify(m => m.Publish(It.IsAny<INotification>(), It.IsAny<CancellationToken>()), Times.Once);
        }

        public void Dispose()
        {
            _context.Database.EnsureDeleted();
            _context.Dispose();
        }
    }
}
