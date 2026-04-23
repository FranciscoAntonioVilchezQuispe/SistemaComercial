using FluentAssertions;
using Nucleo.Comun.Domain.Helpers;
using System;
using System.Threading.Tasks;
using Xunit;

namespace Nucleo.Tests.Unit.Helpers
{
    public class DateTimeHelperTests
    {
        [Fact]
        public async Task ObtenerAhoraLima_DebeRetornarHoraUTCMenos5()
        {
            // Arrange
            var utcNow = DateTime.UtcNow;
            var expectedLima = utcNow.AddHours(-5);

            // Act
            var limaNow = DateTimeHelper.ObtenerAhoraLima();

            // Assert
            // Usamos una tolerancia de 1 minuto por la pequeña diferencia entre la captura de utcNow y la ejecución de ObtenerAhoraLima
            limaNow.Should().BeCloseTo(expectedLima, TimeSpan.FromMinutes(1));
            
            await Task.CompletedTask;
        }
    }
}
