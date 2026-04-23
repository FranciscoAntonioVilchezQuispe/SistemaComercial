using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Application.Validadores;
using Compras.API.Domain.Entidades;
using Compras.API.Infrastructure.Datos;
using FluentValidation.TestHelper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Compras.API.Tests.Unit.Validadores
{
    public class CompraValidatorTests : IDisposable
    {
        private readonly ComprasDbContext _context;
        private readonly CrearCompraValidator _validator;

        public CompraValidatorTests()
        {
            var options = new DbContextOptionsBuilder<ComprasDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            _context = new ComprasDbContext(options);
            _validator = new CrearCompraValidator(_context);
        }

        [Fact]
        public async Task Validar_CompraDuplicada_DebeFallar()
        {
            // Arrange
            var proveedor = new Proveedor { Id = 1, NumeroDocumento = "20123456789", RazonSocial = "Prov Test", Activado = true };
            _context.Proveedores.Add(proveedor);
            
            _context.Compras.Add(new Compra 
            { 
                Id = 1, 
                IdProveedor = 1, 
                Proveedor = proveedor,
                IdTipoComprobante = 1, 
                SerieComprobante = "F001", 
                NumeroComprobante = "100",
                IdEstado = 1,
                Activado = true
            });
            await _context.SaveChangesAsync();

            var compraDto = new CompraDto
            {
                IdProveedor = 1,
                IdTipoComprobante = 1,
                SerieComprobante = "F001",
                NumeroComprobante = "100"
            };
            var comando = new CrearCompraComando(compraDto);

            // Act
            var result = await _validator.TestValidateAsync(comando);

            // Assert
            result.ShouldHaveValidationErrorFor(x => x.Compra);
        }

        public void Dispose()
        {
            _context.Database.EnsureDeleted();
            _context.Dispose();
        }
    }
}
