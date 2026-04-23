using FluentAssertions;
using Identidad.API.Application.Contratos;
using Identidad.API.Application.Features.Auth.Refresh;
using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Moq;
using Nucleo.Comun.Application.Wrappers;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Identidad.API.Tests.Unit.Comandos
{
    public class RefreshTokenHandlerTests
    {
        private readonly Mock<IRefreshTokenRepositorio> _refreshTokenRepoMock;
        private readonly Mock<ITokenService> _tokenServiceMock;
        private readonly Mock<IUsuarioRepositorio> _usuarioRepoMock;
        private readonly Mock<IPermisoRepositorio> _permisoRepoMock;
        private readonly Mock<IRolMenuPermisoRepositorio> _rolMenuPermisoRepoMock;
        private readonly RefreshTokenManejador _handler;

        public RefreshTokenHandlerTests()
        {
            _refreshTokenRepoMock = new Mock<IRefreshTokenRepositorio>();
            _tokenServiceMock = new Mock<ITokenService>();
            _usuarioRepoMock = new Mock<IUsuarioRepositorio>();
            _permisoRepoMock = new Mock<IPermisoRepositorio>();
            _rolMenuPermisoRepoMock = new Mock<IRolMenuPermisoRepositorio>();

            _handler = new RefreshTokenManejador(
                _refreshTokenRepoMock.Object,
                _tokenServiceMock.Object,
                _usuarioRepoMock.Object,
                _permisoRepoMock.Object,
                _rolMenuPermisoRepoMock.Object);
        }

        [Fact]
        public async Task Handle_ConRefreshTokenValido_DebeRetornarNuevoJwt()
        {
            var comando = new RefreshTokenComando { RefreshToken = "valid" };
            var storedToken = new RefreshToken { Token = "valid", UsuarioId = 1, EsRevocado = false, FechaExpiracion = DateTime.UtcNow.AddDays(1) };
            var usuario = new Usuario { Id = 1, Username = "user", UsuariosRoles = new List<UsuarioRol> { new UsuarioRol { Rol = new Rol { NombreRol = "USER" } } } };

            _refreshTokenRepoMock.Setup(x => x.ObtenerPorTokenAsync(comando.RefreshToken)).ReturnsAsync(storedToken);
            _usuarioRepoMock.Setup(x => x.ObtenerPorIdAsync(1)).ReturnsAsync(usuario);
            _rolMenuPermisoRepoMock.Setup(x => x.ObtenerPermisosAplanadosPorUsuarioAsync(1)).ReturnsAsync(new List<string>());
            _tokenServiceMock.Setup(x => x.GenerarTokenJwt(It.IsAny<Usuario>(), It.IsAny<List<string>>(), It.IsAny<List<string>>())).Returns("new-jwt");
            _tokenServiceMock.Setup(x => x.GenerarRefreshToken()).Returns("new-refresh");

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturn<Identidad.API.Application.Features.Auth.Login.LoginRespuesta>>();
        }

        [Fact]
        public async Task Handle_ConRefreshTokenExpirado_DebeRetornarError401()
        {
            var comando = new RefreshTokenComando { RefreshToken = "expired" };
            var storedToken = new RefreshToken { Token = "expired", EsRevocado = false, FechaExpiracion = DateTime.UtcNow.AddDays(-1) };
            _refreshTokenRepoMock.Setup(x => x.ObtenerPorTokenAsync(comando.RefreshToken)).ReturnsAsync(storedToken);

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturnError<Identidad.API.Application.Features.Auth.Login.LoginRespuesta>>();
            var errorResult = result as ToReturnError<Identidad.API.Application.Features.Auth.Login.LoginRespuesta>;
            errorResult!.Status.Should().Be(401);
        }

        [Fact]
        public async Task Handle_ConRefreshTokenNoExistente_DebeRetornarError401()
        {
            var comando = new RefreshTokenComando { RefreshToken = "none" };
            _refreshTokenRepoMock.Setup(x => x.ObtenerPorTokenAsync(comando.RefreshToken)).ReturnsAsync((RefreshToken?)null);

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturnError<Identidad.API.Application.Features.Auth.Login.LoginRespuesta>>();
        }
    }
}
