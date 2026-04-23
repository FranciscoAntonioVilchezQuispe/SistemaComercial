# AGENTE-4 — Clientes.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Clientes.API.Tests/` con tests para el microservicio de gestión de clientes.

## Archivos fuente que DEBES leer primero

```
src/Clientes.API/Clientes.API.API/Endpoints/ClienteEndpoints.cs
src/Clientes.API/Clientes.API.Infrastructure/Repositorios/ClienteRepositorio.cs
src/Clientes.API/Clientes.API.Domain/DTOs/ClienteDetalleDto.cs
src/Clientes.API/Clientes.API.Domain/DTOs/ClienteListDto.cs
src/Clientes.API/Clientes.API.Application/Clientes.API.Application.csproj
src/Clientes.API/Clientes.API.API/Program.cs
```

Busca también si existen comandos y validadores en:
```
src/Clientes.API/Clientes.API.Application/Comandos/
src/Clientes.API/Clientes.API.Application/Validadores/
```

## Archivo .csproj a crear

`tests/Clientes.API.Tests/Clientes.API.Tests.csproj`:
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
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Clientes.API\Clientes.API.API\Clientes.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Reglas de dominio peruano (CRÍTICAS)

- **DNI**: exactamente 8 dígitos numéricos
- **RUC**: exactamente 11 dígitos numéricos (empieza en 10 o 20)
- **CE (Carnet Extranjería)**: variable, no hay longitud fija
- El tipo de documento determina la validación de longitud

## Tests que debes implementar

### `Unit/Comandos/CrearClienteHandlerTests.cs`

Si el microservicio usa CQRS con MediatR, leer el handler. Si usa repositorio directo, mockear `IClienteRepositorio`.

1. `Handle_ConDniValido_DebeCrearCliente()`
   - Cliente con TipoDocumento=DNI, NumeroDocumento="12345678" (8 dígitos)
   - Assert: cliente creado con Id > 0

2. `Handle_ConRucValido_DebeCrearCliente()`
   - Cliente con TipoDocumento=RUC, NumeroDocumento="20123456789" (11 dígitos)
   - Assert: cliente creado con Id > 0

3. `Handle_ConDocumentoDuplicado_DebeLanzarException()`
   - Setup: repositorio indica que el documento ya existe
   - Assert: lanza excepción de negocio

### `Unit/Validadores/ClienteValidatorTests.cs`

Si no existe un validador FluentValidation, crear el test que prueba la lógica de validación del endpoint directamente.

1. `Validar_ConDni8Digitos_DebePasar()`
   - NumeroDocumento="12345678", TipDocumento=DNI → válido

2. `Validar_ConDni7Digitos_DebeFallar()`
   - NumeroDocumento="1234567" (7 dígitos) → inválido

3. `Validar_ConRuc11Digitos_DebePasar()`
   - NumeroDocumento="20123456789" → válido

4. `Validar_ConRuc10Digitos_DebeFallar()`
   - NumeroDocumento="2012345678" (10 dígitos) → inválido

5. `Validar_ConNombreVacio_DebeFallar()`
   - Nombre="" → inválido

### `Integration/Endpoints/ClientesEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Endpoints de escritura requieren token Admin.

1. `GET_Clientes_ConTokenAdmin_DebeRetornarListaPaginada()`
   - GET /api/clientes → 200 OK, lista (puede ser vacía si no hay datos seed)

2. `GET_Clientes_PorId_ConIdValido_DebeRetornarDetalle()`
   - Crear cliente primero, luego GET /api/clientes/{id} → 200 OK con detalle completo

3. `POST_Clientes_ConDniValido_DebeCrear()`
   - POST /api/clientes con {tipoDocumento: "DNI", numeroDocumento: "12345678", nombre: "Juan Pérez"} → 201

4. `POST_Clientes_ConRucInvalido_DebeRetornar400()`
   - POST con RUC de 10 dígitos → 400 BadRequest

5. `PUT_Clientes_ConDatosValidos_DebeActualizar()`
   - Crear cliente, luego PUT /api/clientes/{id} con datos nuevos → 200 OK

6. `DELETE_Clientes_ConIdValido_DebeSoftDelete()`
   - Crear cliente, DELETE /api/clientes/{id} → 200 OK
   - El cliente debe existir en BD con Activado=false (soft delete)

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`)
- No agregar paquetes NuGet extra
- No modificar nada en `src/`

## Verificación final

```
dotnet build tests/Clientes.API.Tests/Clientes.API.Tests.csproj
```
