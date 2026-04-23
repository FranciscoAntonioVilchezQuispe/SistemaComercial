using FluentAssertions;
using Identidad.API.Application.Features.Roles.ActualizarPermisosRol;
using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Moq;
using Nucleo.Comun.Application.Wrappers;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Identidad.API.Tests.Unit.Roles
{
    public class ActualizarPermisosRolHandlerTests
    {
        private readonly Mock<IRolRepositorio> _rolRepoMock;
        private readonly ActualizarPermisosRolCommandHandler _handler;

        public ActualizarPermisosRolHandlerTests()
        {
            _rolRepoMock = new Mock<IRolRepositorio>();
            _handler = new ActualizarPermisosRolCommandHandler(_rolRepoMock.Object);
        }

        [Fact]
        public async Task Handle_ConRolExistente_DebeLlamarSincronizarPermisos()
        {
            var comando = new ActualizarPermisosRolCommand { IdRol = 1, PermisosIds = new List<long> { 10 } };
            _rolRepoMock.Setup(x => x.ObtenerPorIdAsync(1)).ReturnsAsync(new Rol { Id = 1 });

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturn<bool>>();
            _rolRepoMock.Verify(x => x.SincronizarPermisosAsync(1, comando.PermisosIds), Times.Once);
        }
    }
}
