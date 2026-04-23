# AGENTE-3 — Catalogo.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Catalogo.API.Tests/` con tests para el microservicio de catálogo de productos (productos, categorías, marcas, unidades de medida).

## Archivos fuente que DEBES leer primero

```
src/Catalogo.API/Catalogo.Domain/Entidades/Producto.cs
src/Catalogo.API/Catalogo.Application/Comandos/CrearProductoComando.cs
src/Catalogo.API/Catalogo.Application/Comandos/ActualizarProductoComando.cs
src/Catalogo.API/Catalogo.Application/DTOs/ActualizarProductoRequest.cs
src/Catalogo.API/Catalogo.Application/DTOs/ProductoDto.cs
src/Catalogo.API/Catalogo.Application/Manejadores/CrearProductoManejador.cs
src/Catalogo.API/Catalogo.Application/Manejadores/ActualizarProductoManejador.cs
src/Catalogo.API/Catalogo.Domain/Interfaces/IProductoRepositorio.cs
src/Catalogo.API/Catalogo.Domain/DTOs/ProductoListDto.cs
src/Catalogo.API/Catalogo.Domain/DTOs/ProductoDetalleDto.cs
src/Catalogo.API/Catalogo.API/Endpoints/ProductoEndpoints.cs
src/Catalogo.API/Catalogo.API/Endpoints/CategoriaEndpoints.cs
src/Catalogo.API/Catalogo.Infrastructure/Repositorios/ProductoRepositorio.cs
src/Catalogo.API/Catalogo.API/Program.cs
```

## Archivo .csproj a crear

`tests/Catalogo.API.Tests/Catalogo.API.Tests.csproj`:
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
    <ProjectReference Include="..\..\src\Catalogo.API\Catalogo.API\Catalogo.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Conocimiento del dominio

- **Método de valuación** (MetodoValuacion): solo acepta "PP" (Promedio Ponderado), "PE" (FIFO), "UE" (LIFO)
- **Soft Delete**: eliminar un producto setea `Activado = false`, NO elimina el registro de BD
- **Paginación**: el endpoint GET /api/productos devuelve `PagedResponse<ProductoListDto>` con campos: `datos`, `total`, `pageNumber`, `pageSize`, `totalPages`
- Los endpoints de escritura (POST, PUT, DELETE) requieren rol ADMIN

## Tests que debes implementar

### `Unit/Comandos/CrearProductoManejadorTests.cs`

Leer `CrearProductoManejador.cs` para entender qué repositorios usa. Mockear todas las interfaces.

1. `Handle_ConDatosCompletos_DebeCrearProductoConId()`
   - Setup: repos devuelven datos válidos (categoría existe, marca existe, código no duplicado)
   - Assert: resultado tiene Id > 0

2. `Handle_ConCodigoDuplicado_DebeLanzarAppException()`
   - Setup: repositorio indica que el código ya existe
   - Assert: lanza excepción de negocio

3. `Handle_ConCategoriaInexistente_DebeLanzarAppException()`
   - Setup: repositorio de categoría devuelve null para el IdCategoria
   - Assert: lanza excepción

4. `Handle_ConMarcaInexistente_DebeLanzarAppException()`
   - Setup: repositorio de marca devuelve null
   - Assert: lanza excepción

5. `Handle_ConMetodoValuacionPP_DebeAsignarCorrecto()`
   - Comando con MetodoValuacion="PP"
   - Assert: el producto creado tiene MetodoValuacion="PP"

### `Unit/Comandos/ActualizarProductoManejadorTests.cs`

1. `Handle_ConProductoExistente_DebeActualizarCampos()`
   - Setup: repo devuelve producto existente
   - Assert: los campos cambiados se actualizan correctamente

2. `Handle_ConProductoInexistente_DebeLanzarAppException()`
   - Setup: repo devuelve null para el Id
   - Assert: lanza excepción

3. `Handle_ConPrecioNegativo_DebeLanzarValidationException()`
   - Comando con PrecioVentaPublico=-1
   - Assert: lanza ValidationException (atrapada por el pipeline de MediatR)

### `Unit/Validadores/CrearProductoComandoValidatorTests.cs`

Buscar el validador en `src/Catalogo.API/Catalogo.Application/`. Si usa FluentValidation, instanciar directamente y llamar `.Validate()`.

1. `Validar_ConNombreVacio_DebeFallar()`
2. `Validar_ConPrecioNegativo_DebeFallar()` — PrecioVentaPublico = -1
3. `Validar_ConIdCategoria0_DebeFallar()` — IdCategoria = 0
4. `Validar_ConMetodoValuacionInvalido_DebeFallar()` — MetodoValuacion = "XX" (no es PP/PE/UE)
5. `Validar_ConDatosCompletos_DebePasar()` — todos los campos válidos → IsValid=true

### `Integration/Repositorios/ProductoRepositorioTests.cs`

Usar `PostgreSqlFixture` (IClassFixture). Crear una instancia de `CatalogoDbContext` con la connection string del contenedor. Aplicar migrations antes del primer test.

1. `ObtenerPaginadoAsync_ConPagina1Size10_DebeRetornar10Items()`
   - Insertar 15 productos, pedir página 1 size 10 → recibir exactamente 10

2. `ObtenerPorIdAsync_ConIdExistente_DebeRetornarProductoConRelaciones()`
   - Insertar producto con categoría y marca → el detalle incluye nombre de categoría

3. `CrearAsync_ConProductoValido_DebeGuardarConId()`
   - Crear producto → Id > 0 en BD

4. `EliminarAsync_ConProductoExistente_DebeSoftDeleteActivadoFalse()`
   - Crear producto, eliminar → buscar en BD con `IgnoreQueryFilters()` → Activado=false, registro aún existe

### `Integration/Endpoints/ProductosEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Los tests de escritura necesitan token Admin.

1. `GET_Productos_DebeRetornarListaPaginada()`
   - GET /api/productos → 200 OK, body tiene campo `datos` o `items`

2. `GET_Productos_PorId_ConIdValido_DebeRetornarDetalle()`
   - Primero crear producto via POST, luego GET /api/productos/{id} → 200

3. `GET_Productos_PorId_ConIdInexistente_DebeRetornar404()`
   - GET /api/productos/999999 → 404 NotFound

4. `POST_Productos_ConDatosValidos_DebeRetornar201()`
   - POST con body válido y token Admin → 201 Created

5. `POST_Productos_ConNombreVacio_DebeRetornar400()`
   - POST con NombreProducto="" → 400 BadRequest

6. `PUT_Productos_ConDatosValidos_DebeActualizar()`
   - PUT /api/productos/{id} con datos válidos → 200 OK

7. `DELETE_Productos_ConIdValido_DebeDesactivar()`
   - DELETE /api/productos/{id} → 200 OK
   - Verificar que el producto sigue en BD con Activado=false

### `Integration/Endpoints/CategoriasEndpointTests.cs`

1. `GET_Categorias_DebeRetornarLista()`
   - GET /api/categorias → 200 OK con lista

2. `POST_Categorias_ConNombreValido_DebeCrear()`
   - POST /api/categorias con {nombre: "Electrónica"} y token Admin → 201

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`)
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Tests de repositorio: usar `[Collection("PostgreSQL")]` y `IClassFixture<PostgreSqlFixture>`

## Verificación final

```
dotnet build tests/Catalogo.API.Tests/Catalogo.API.Tests.csproj
dotnet test tests/Catalogo.API.Tests/Catalogo.API.Tests.csproj --filter "Category!=Integration"
```
