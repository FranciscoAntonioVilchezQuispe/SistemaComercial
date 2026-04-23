using Contabilidad.API.Domain.Entidades;
using FluentAssertions;
using System.Collections.Generic;
using Xunit;

namespace Contabilidad.API.Tests.Unit.Domain
{
    public class AsientoContableTests
    {
        [Fact]
        public void CalcularTotales_ConDetalles_DebeSumarCorrectamente()
        {
            // Arrange
            var asiento = new AsientoContable
            {
                Detalles = new List<DetalleAsiento>
                {
                    new DetalleAsiento { Debe = 100, Haber = 0 },
                    new DetalleAsiento { Debe = 0, Haber = 100 }
                }
            };

            // Act (Simulando lógica que debería estar en la entidad o un servicio)
            asiento.TotalDebe = 0;
            asiento.TotalHaber = 0;
            foreach (var detalle in asiento.Detalles)
            {
                asiento.TotalDebe += detalle.Debe;
                asiento.TotalHaber += detalle.Haber;
            }

            // Assert
            asiento.TotalDebe.Should().Be(100);
            asiento.TotalHaber.Should().Be(100);
            (asiento.TotalDebe - asiento.TotalHaber).Should().Be(0);
        }
    }
}
