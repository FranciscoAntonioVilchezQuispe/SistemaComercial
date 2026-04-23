using FluentAssertions;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Manejadores;
using Inventario.API.Application.DTOs;
using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Entidades.Referencias;
using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Inventario.API.Tests.Unit.Manejadores
{
    public class ProcesarMovimientoManejadorTests : IDisposable
    {
        private readonly InventarioDbContext _context;
        private readonly Mock<IKardexService> _kardexMock;
        private readonly Mock<IValidacionReglaSunatService> _validacionSunatMock;
        private readonly CrearMovimientoInventarioManejador _manejador;

        public ProcesarMovimientoManejadorTests()
        {
            var options = new DbContextOptionsBuilder<InventarioDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            _context = new InventarioDbContext(options);
            _kardexMock = new Mock<IKardexService>();
            _validacionSunatMock = new Mock<IValidacionReglaSunatService>();

            _manejador = new CrearMovimientoInventarioManejador(_context, _kardexMock.Object, _validacionSunatMock.Object);
        }

        [Fact]
        public async Task Handle_ConDatosValidos_DebeCrearMovimientoYActualizarStock()
        {
            // Arrange
            var tipoMov = new TipoMovimientoReferencia { Id = 1, Codigo = "ING_COM", Nombre = "Ingreso por Compra", Factor = 1 };
            _context.TiposMovimiento.Add(tipoMov);
            await _context.SaveChangesAsync();

            var comando = new CrearMovimientoInventarioComando(
                IdProducto: 1,
                IdAlmacen: 1,
                IdTipoMovimiento: 1,
                Cantidad: 10,
                CostoUnitario: 50,
                ReferenciaModulo: "COMPRAS",
                IdReferencia: 100,
                Observaciones: "Test",
                IdTipoDocumento: null,
                SerieDocumento: "F001",
                NumeroDocumento: "1"
            );

            // Act
            var result = await _manejador.Handle(comando, CancellationToken.None);

            // Assert
            result.Should().BeGreaterThan(0);
            
            var stock = await _context.Stocks.FirstOrDefaultAsync(s => s.IdProducto == 1 && s.IdAlmacen == 1);
            stock.Should().NotBeNull();
            stock!.CantidadActual.Should().Be(10);
            stock.CostoPromedio.Should().Be(50);

            _kardexMock.Verify(x => x.RegistrarEntradaAsync(It.IsAny<RegistrarMovimientoKardexDto>()), Times.Once);
        }

        [Fact]
        public async Task Handle_ConStockInsuficiente_DebeLanzarException()
        {
            // Arrange
            var tipoMov = new TipoMovimientoReferencia { Id = 2, Codigo = "SAL_VEN", Nombre = "Salida por Venta", Factor = -1 };
            _context.TiposMovimiento.Add(tipoMov);
            
            // Agregar registro de stock con 0 para forzar error de "Stock insuficiente" en lugar de "No existe registro"
            _context.Stocks.Add(new Stock { IdProducto = 1, IdAlmacen = 1, CantidadActual = 0 });
            
            await _context.SaveChangesAsync();

            var comando = new CrearMovimientoInventarioComando(
                IdProducto: 1,
                IdAlmacen: 1,
                IdTipoMovimiento: 2,
                Cantidad: 10,
                CostoUnitario: 50,
                ReferenciaModulo: "VENTAS",
                IdReferencia: 101,
                Observaciones: "Test Salida",
                IdTipoDocumento: null,
                SerieDocumento: "B001",
                NumeroDocumento: "1",
                PermitirStockNegativo: false
            );

            // Act & Assert
            await _manejador.Invoking(x => x.Handle(comando, CancellationToken.None))
                .Should().ThrowAsync<Exception>()
                .WithMessage("*Stock insuficiente*");
        }

        public void Dispose()
        {
            _context.Database.EnsureDeleted();
            _context.Dispose();
        }
    }
}
