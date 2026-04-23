using FluentAssertions;
using Identidad.API.Application.Contratos;
using Identidad.API.Application.Features.Auth.Login;
using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Moq;
using Nucleo.Comun.Application.Wrappers;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Identidad.API.Tests.Unit.Comandos
{
    public class LoginManejadorTests
    {
        private readonly Mock<IUsuarioRepositorio> _usuarioRepoMock;
        private readonly Mock<IPasswordHasher> _hasherMock;
        private readonly Mock<ITokenService> _tokenServiceMock;
        private readonly Mock<IPermisoRepositorio> _permisoRepoMock;
        private readonly Mock<IRefreshTokenRepositorio> _refreshTokenRepoMock;
        private readonly Mock<IRolMenuPermisoRepositorio> _rolMenuPermisoRepoMock;
        private readonly LoginManejador _handler;

        public LoginManejadorTests()
        {
            _usuarioRepoMock = new Mock<IUsuarioRepositorio>();
            _hasherMock = new Mock<IPasswordHasher>();
            _tokenServiceMock = new Mock<ITokenService>();
            _permisoRepoMock = new Mock<IPermisoRepositorio>();
            _refreshTokenRepoMock = new Mock<IRefreshTokenRepositorio>();
            _rolMenuPermisoRepoMock = new Mock<IRolMenuPermisoRepositorio>();

            _handler = new LoginManejador(
                _usuarioRepoMock.Object,
                _hasherMock.Object,
                _tokenServiceMock.Object,
                _permisoRepoMock.Object,
                _refreshTokenRepoMock.Object,
                _rolMenuPermisoRepoMock.Object);
        }

        [Fact]
        public async Task Handle_ConCredencialesValidas_DebeRetornarTokenJwt()
        {
            var comando = new LoginComando { Username = "admin", Password = "Password123!" };
            var usuario = new Usuario 
            { 
                Id = 1, 
                Username = "admin", 
                PasswordHash = "hashed",
                UsuariosRoles = new List<UsuarioRol> { new UsuarioRol { Rol = new Rol { NombreRol = "ADMINISTRADOR" } } }
            };

            _usuarioRepoMock.Setup(x => x.ObtenerPorUsernameAsync(comando.Username)).ReturnsAsync(usuario);
            _hasherMock.Setup(x => x.VerifyPassword(comando.Password, usuario.PasswordHash)).Returns(true);
            _rolMenuPermisoRepoMock.Setup(x => x.ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id)).ReturnsAsync(new List<string> { "VENTAS:VER" });
            _tokenServiceMock.Setup(x => x.GenerarTokenJwt(It.IsAny<Usuario>(), It.IsAny<List<string>>(), It.IsAny<List<string>>())).Returns("mocked-jwt");
            _tokenServiceMock.Setup(x => x.GenerarRefreshToken()).Returns("mocked-refresh");

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturn<LoginRespuesta>>();
            var successResult = result as ToReturn<LoginRespuesta>;
            successResult!.Data.Token.Should().Be("mocked-jwt");
        }

        [Fact]
        public async Task Handle_ConEmailInexistente_DebeRetornarError401()
        {
            var comando = new LoginComando { Username = "none", Password = "123" };
            _usuarioRepoMock.Setup(x => x.ObtenerPorUsernameAsync(comando.Username)).ReturnsAsync((Usuario?)null);

            var result = await _handler.Handle(comando, CancellationToken.None);

            result.Should().BeOfType<ToReturnError<LoginRespuesta>>();
            var errorResult = result as ToReturnError<LoginRespuesta>;
            errorResult!.Status.Should().Be(401);
        }
    }
}
