# AGENTE-1 — Identidad.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente existente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe (creada por AGENTE-0) y contiene `AuthHelper`, `PostgreSqlFixture` y `HttpClientExtensions`.

## Tu misión

Crear el proyecto `tests/Identidad.API.Tests/` con tests para el microservicio de autenticación y gestión de usuarios/roles.

## Arquitectura del microservicio

Identidad.API usa **Clean Architecture + CQRS con MediatR**:
- Endpoints en `src/Identidad.API/Identidad.API.API/Endpoints/`
- Handlers en `src/Identidad.API/Identidad.API.Application/Features/`
- Servicios en `src/Identidad.API/Identidad.API.Infrastructure/Servicios/`
- Entidades en `src/Identidad.API/Identidad.API.Domain/Entidades/`
- Interfaces en `src/Identidad.API/Identidad.API.Domain/Interfaces/`

## Archivos fuente que DEBES leer primero

```
src/Identidad.API/Identidad.API.Infrastructure/Servicios/BCryptPasswordHasher.cs
src/Identidad.API/Identidad.API.Infrastructure/Servicios/JwtTokenService.cs
src/Identidad.API/Identidad.API.Application/Features/Auth/Login/LoginManejador.cs
src/Identidad.API/Identidad.API.Application/Features/Auth/Login/LoginComando.cs
src/Identidad.API/Identidad.API.Application/Features/Auth/Login/LoginComandoValidator.cs
src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs
src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenComando.cs
src/Identidad.API/Identidad.API.Application/Features/Roles/ActualizarAccesoRol/ActualizarAccesoRolCommand.cs
src/Identidad.API/Identidad.API.Application/Features/Roles/ActualizarPermisosRol/ActualizarPermisosRolCommand.cs
src/Identidad.API/Identidad.API.Application/Features/Usuarios/CrearUsuario/CrearUsuarioCommand.cs
src/Identidad.API/Identidad.API.Application/Contratos/IPasswordHasher.cs
src/Identidad.API/Identidad.API.Application/Contratos/ITokenService.cs
src/Identidad.API/Identidad.API.Domain/Interfaces/IIdentidadRepositorios.cs
src/Identidad.API/Identidad.API.Domain/Interfaces/IPermisosRepositorios.cs
src/Identidad.API/Identidad.API.Domain/Interfaces/IRefreshTokenRepositorio.cs
src/Identidad.API/Identidad.API.Domain/Entidades/Usuario.cs
src/Identidad.API/Identidad.API.Domain/Entidades/RefreshToken.cs
src/Identidad.API/Identidad.API.API/Endpoints/AuthEndpoints.cs
src/Identidad.API/Identidad.API.API/Endpoints/IdentidadEndpoints.cs
src/Identidad.API/Identidad.API.API/Program.cs
src/Identidad.API/Identidad.API.API/appsettings.json
```

## Archivo .csproj a crear

`tests/Identidad.API.Tests/Identidad.API.Tests.csproj`:
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.11.0" />
    <PackageReference Include="xunit" Version="2.9.0" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.8.2" />
    <PackageReference Include="FluentAssertions" Version="6.12.1" />
    <PackageReference Include="Moq" Version="4.20.72" />
    <PackageReference Include="Testcontainers.PostgreSql" Version="3.10.0" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Identidad.API\Identidad.API.API\Identidad.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Tests que debes implementar (con código completo)

### `Unit/Servicios/BCryptPasswordHasherTests.cs`

Lee `BCryptPasswordHasher.cs` para conocer la clase concreta. Instanciarla directamente (no mockear).

1. `Hashear_ConPasswordValido_DebeRetornarHashDistintoAlTextoOriginal()`
2. `Hashear_MismoPassword_DebeGenerarHashesDiferentes()` — dos hashes del mismo password deben ser distintos (salt aleatorio)
3. `Verificar_ConPasswordCorrecto_DebeRetornarTrue()`
4. `Verificar_ConPasswordIncorrecto_DebeRetornarFalse()`
5. `Verificar_ConHashVacio_DebeRetornarFalse()`

### `Unit/Servicios/JwtTokenServiceTests.cs`

Lee `JwtTokenService.cs`. El servicio recibe configuración (Issuer, Audience, SecretKey) del IConfiguration.

1. `GenerarToken_ConUsuarioValido_DebeIncluirClaimUserId()` — decodificar el JWT y verificar claim NameIdentifier
2. `GenerarToken_ConRolAdmin_DebeIncluirClaimRol()` — verificar claim Role="ADMIN"
3. `GenerarToken_DebeUsarIssuerYAudienceCorrectos()` — verificar Issuer y Audience del token
4. `GenerarRefreshToken_DebeRetornarStringBase64NoVacio()`
5. `GenerarRefreshToken_DosLlamadas_DebeRetornarValoresDiferentes()`

### `Unit/Comandos/LoginComandoHandlerTests.cs`

El `LoginManejador` (lee el archivo): busca usuario por email/username usando `IUsuarioRepositorio`, verifica password con `IPasswordHasher`, genera JWT con `ITokenService`, guarda `RefreshToken`.

Mockear: `IUsuarioRepositorio`, `IPasswordHasher`, `ITokenService`, `IRefreshTokenRepositorio`.

1. `Handle_ConCredencialesValidas_DebeRetornarTokenJwt()`
   - Setup: repo devuelve usuario activo, hasher.Verificar=true, tokenService genera token
   - Assert: resultado.Token no debe ser nulo ni vacío

2. `Handle_ConEmailInexistente_DebeLanzarAppException()`
   - Setup: repo devuelve null
   - Assert: lanza `AppException` o excepción de negocio

3. `Handle_ConPasswordIncorrecto_DebeLanzarAppException()`
   - Setup: repo devuelve usuario, hasher.Verificar=false

4. `Handle_ConUsuarioInactivo_DebeLanzarAppException()`
   - Setup: usuario con Activado=false

5. `Handle_ConLoginExitoso_DebeGuardarRefreshTokenEnBD()`
   - Verify: `_refreshTokenRepo.GuardarAsync()` llamado Times.Once

### `Unit/Comandos/RefreshTokenHandlerTests.cs`

1. `Handle_ConRefreshTokenValido_DebeRetornarNuevoJwt()`
2. `Handle_ConRefreshTokenExpirado_DebeLanzarAppException()`
3. `Handle_ConRefreshTokenNoExistente_DebeLanzarAppException()`

### `Unit/Roles/ActualizarPermisosRolHandlerTests.cs`

El handler `ActualizarPermisosRolCommandHandler` (lee el archivo): obtiene rol por ID y llama `SincronizarPermisosAsync`.

Mockear: `IRolRepositorio`.

1. `Handle_ConRolExistente_DebeLlamarSincronizarPermisos()`
   - Verify: `_repoRol.SincronizarPermisosAsync(idRol, listaIds)` llamado Times.Once

2. `Handle_ConRolInexistente_DebeRetornarError404()`
   - Setup: repo devuelve null
   - Assert: resultado.Status == 404

3. `Handle_ConListaPermisoVacia_DebeVaciarPermisosDelRol()`
   - Enviar lista vacía → llamar SincronizarPermisosAsync con lista vacía

### `Unit/Roles/ActualizarAccesoRolHandlerTests.cs`

El handler `ActualizarAccesoRolCommandHandler` (lee el archivo): gestiona RolMenu + RolMenuPermiso con operaciones crear/eliminar.

Mockear: `IRolRepositorio`, `IRolMenuRepositorio`, `IRolMenuPermisoRepositorio`, `IMenuRepositorio`, `ITipoPermisoRepositorio`.

1. `Handle_ConRolInexistente_DebeRetornarError404()`

2. `Handle_ConNuevoAcceso_DebeCrearRolMenu()`
   - Accesos actuales: vacío. Request: 1 acceso nuevo.
   - Verify: `_repoRolMenu.AgregarAsync()` llamado Times.Once

3. `Handle_ConAccesoEliminado_DebeEliminarRolMenuObsoleto()`
   - Accesos actuales: [MenuId=1]. Request: [] (vacío).
   - Verify: `_repoRolMenu.EliminarAsync()` llamado Times.Once

4. `Handle_ConPermisosActualizados_DebeSincronizarRolMenuPermiso()`
   - RolMenu existente con permisos viejos. Request con permisos nuevos.
   - Verify: EliminarAsync + AgregarAsync llamados en RolMenuPermiso

### `Unit/Validadores/LoginComandoValidatorTests.cs`

Instanciar `LoginComandoValidator` directamente.

1. `Validar_ConEmailVacio_DebeFallar()`
2. `Validar_ConEmailFormatoInvalido_DebeFallar()` — "noesvalido" sin @
3. `Validar_ConPasswordVacio_DebeFallar()`
4. `Validar_ConDatosCompletos_DebePasar()` — email y password válidos → IsValid=true

### `Integration/Endpoints/AuthEndpointTests.cs`

Usar `WebApplicationFactory<Program>` de Identidad.API. Para integration tests, configurar la BD en memoria o un SQLite de test (reemplazar el DbContext en el builder).

1. `POST_Login_ConCredencialesValidas_DebeRetornar200ConToken()`
2. `POST_Login_ConPasswordIncorrecto_DebeRetornar401()`
3. `POST_Login_ConEmailInexistente_DebeRetornar400()`
4. `POST_RefreshToken_ConTokenValido_DebeRetornarNuevoJwt()`

### `Integration/Endpoints/RolesEndpointTests.cs`

Usar `WebApplicationFactory<Program>` con token de AuthHelper.

1. `GET_Roles_ConTokenAdmin_DebeRetornar200ConLista()`
2. `POST_Roles_Permisos_ConRolValido_DebeActualizarPermisos()`
3. `POST_Roles_AccesoGranular_ConMenusValidos_DebeActualizarAccesos()`
4. `POST_Roles_AccesoGranular_ConRolInexistente_DebeRetornar404()`

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`) — NO usar `Assert.Equal()`
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Todos los mocks con `Mock<IInterfaz>()` de Moq
- Los tests de Integration pueden marcarse con `[Trait("Category", "Integration")]`

## Verificación final

```
dotnet build tests/Identidad.API.Tests/Identidad.API.Tests.csproj
dotnet test tests/Identidad.API.Tests/Identidad.API.Tests.csproj --filter "Category!=Integration"
```
