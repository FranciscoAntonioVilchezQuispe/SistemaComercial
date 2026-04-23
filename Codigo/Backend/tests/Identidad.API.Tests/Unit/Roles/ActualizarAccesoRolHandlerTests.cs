using FluentAssertions;
using Identidad.API.Application.Features.Roles.ActualizarAccesoRol;
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
    public class ActualizarAccesoRolHandlerTests
    {
        private readonly Mock<IRolRepositorio> _rolRepoMock;
        private readonly Mock<IRolMenuRepositorio> _rolMenuRepoMock;
        private readonly Mock<IRolMenuPermisoRepositorio> _rolMenuPermisoRepoMock;
        private readonly ActualizarAccesoRolCommandHandler _handler;

        public ActualizarAccesoRolHandlerTests()
        {
            _rolRepoMock = new Mock<IRolRepositorio>();
            _rolMenuRepoMock = new Mock<IRolMenuRepositorio>();
            _rolMenuPermisoRepoMock = new Mock<IRolMenuPermisoRepositorio>();

            _handler = new ActualizarAccesoRolCommandHandler(
                _rolRepoMock.Object,
                _rolMenuRepoMock.Object,
                _rolMenuPermisoRepoMock.Object,
                new Mock<IMenuRepositorio>().Object,
                new Mock<ITipoPermisoRepositorio>().Object);
        }

        [Fact]
        public async Task Handle_ConNuevoAcceso_DebeCrearRolMenu()
        {
            var idRol = 1L;
            var comando = new ActualizarAccesoRolCommand { IdRol = idRol, Accesos = new List<AccesoMenuDto> { new AccesoMenuDto { IdMenu = 10, TiposPermisoIds = new List<long>() } } };
            _rolRepoMock.Setup(x => x.ObtenerPorIdAsync(idRol)).ReturnsAsync(new Rol { Id = idRol });
            _rolMenuRepoMock.Setup(x => x.ObtenerPorRolAsync(idRol)).ReturnsAsync(new List<RolMenu>());
            _rolMenuRepoMock.Setup(x => x.AgregarAsync(It.IsAny<RolMenu>())).ReturnsAsync(new RolMenu { Id = 50 });
            _rolMenuPermisoRepoMock.Setup(x => x.ObtenerPorRolMenuAsync(It.IsAny<long>())).ReturnsAsync(new List<RolMenuPermiso>());

            await _handler.Handle(comando, CancellationToken.None);

            _rolMenuRepoMock.Verify(x => x.AgregarAsync(It.IsAny<RolMenu>()), Times.Once);
        }
    }
}
