# AGENTE-6 — Compras.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Compras.API.Tests/` con tests para el microservicio de compras. Este microservicio se comunica con Inventario.API mediante HTTP (patrón HttpClient) para registrar movimientos de stock.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/Compras.API/Compras.API.Application/Manejadores/CrearCompraManejador.cs
src/Compras.API/Compras.API.Application/Manejadores/AnularCompraManejador.cs
src/Compras.API/Compras.API.Application/Manejadores/CrearNotaCreditoCompraManejador.cs
src/Compras.API/Compras.API.Application/Manejadores/CrearNotaDebitoCompraManejador.cs
src/Compras.API/Compras.API.Application/Interfaces/IInventarioServicio.cs
src/Compras.API/Compras.API.Application/Integracion/InventarioServicio.cs
src/Compras.API/Compras.API.Application/Validadores/CrearCompraValidator.cs
src/Compras.API/Compras.API.Domain/Entidades/Compra.cs
src/Compras.API/Compras.API.Domain/Interfaces/ICompraRepositorio.cs
src/Compras.API/Compras.API.Application/DTOs/CompraDto.cs
src/Compras.API/Compras.API.Application/DTOs/NotaCreditoCompraDto.cs
src/Compras.API/Compras.API.API/Endpoints/CompraEndpoints.cs
src/Compras.API/Compras.API.API/Endpoints/ReportesComprasEndpoints.cs
src/Compras.API/Compras.API.API/Program.cs
```

## Archivo .csproj a crear

`tests/Compras.API.Tests/Compras.API.Tests.csproj`:
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
    <ProjectReference Include="..\..\src\Compras.API\Compras.API.API\Compras.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Conocimiento del dominio

### Estados de documento (tabla configuracion.tablas_generales_detalle, tabla 15)
| ID | Estado |
|----|--------|
| 60 | Registrado |
| 61 | Anulado Directo |
| 64 | Anulado Nota Crédito |
| 66 | Completado |

Al anular una compra → `id_estado = 61`.

### Tipos de movimiento que Compras envía a Inventario
| ID | Nombre | Cuándo |
|----|--------|--------|
| 19 | ING_COM | Al crear compra (entrada por compra) |
| 24 | DevolucionCompra | Al crear NC de compra (salida por devolución) |
| 26 | NotaDebitoCompra | Al crear ND de compra (entrada adicional) |

### Cálculo de IGV en compras
- Subtotal por línea = Cantidad × PrecioUnitario
- IGV por línea = Subtotal × 0.18 (si gravado)
- Total = Subtotal + IGV

### Patrón de integración con Inventario
`IInventarioServicio` (en `src/Compras.API/Compras.API.Application/Interfaces/`) tiene estos métodos:
```csharp
Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad,
    decimal costoUnitario, long idCompra, long idTipoComprobante,
    string serie, string numero, string codigoOperacionSunat = "02");

Task<bool> EliminarMovimientosCompraAsync(long idCompra);

Task<bool> RegistrarSalidaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad,
    long idNota, string serie, string numero, long idTipoComprobante,
    string codigoOperacionSunat = "07");

Task<bool> RegistrarEntradaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad,
    decimal costoUnitario, long idNota, string serie, string numero,
    long idTipoComprobante, string codigoOperacionSunat = "02");
```

## Tests que debes implementar

### `Unit/Comandos/CrearCompraHandlerTests.cs`

Leer `CrearCompraManejador.cs` para conocer exactamente qué repositorios e interfaces usa. Mockear todo.

**Setup base para estos tests:**
```csharp
var inventarioMock = new Mock<IInventarioServicio>();
inventarioMock
    .Setup(s => s.RegistrarEntradaCompraAsync(
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<decimal>(),
        It.IsAny<decimal>(), It.IsAny<long>(), It.IsAny<long>(),
        It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
    .ReturnsAsync(true);
```

1. `Handle_ConDetallesValidos_DebeCrearCompraConId()`
   - Comando con 1+ detalles válidos → resultado.Id > 0

2. `Handle_ConUnDetalle_DebeCalcularIgvCorrecto()`
   - 1 detalle: Cantidad=1, PrecioUnitario=100, gravado=true
   - Assert: Subtotal=100, IGV=18 (o 18%), Total=118

3. `Handle_ConMultiplesDetalles_DebeSumarTotalesCorrectamente()`
   - 2 detalles: [1u×100] + [2u×50] → Total esperado = 236 (con IGV 18%)

4. `Handle_ConCompraCreada_DebeLlamarInventarioUnaVezPorLinea()`
   - Comando con 2 líneas de detalle
   - Verify: `RegistrarEntradaCompraAsync` llamado `Times.Exactly(2)`

5. `Handle_ConInventarioFallando_DebeGuardarCompraIgual()`
   - Setup: `inventarioMock` devuelve `false`
   - Assert: la compra igual se guarda (el servicio falla silenciosamente y loguea)

### `Unit/Comandos/AnularCompraHandlerTests.cs`

Leer `AnularCompraManejador.cs`. Al anular: cambia `id_estado = 61` y llama `EliminarMovimientosCompraAsync`.

1. `Handle_ConCompraRegistrada_DebeCambiarEstadoA61()`
   - Compra con id_estado=60 → después de anular: id_estado=61

2. `Handle_ConCompraAnulada_DebeLlamarEliminarMovimientosInventario()`
   - Verify: `EliminarMovimientosCompraAsync(idCompra)` llamado `Times.Once`

3. `Handle_ConCompraYaAnulada_DebeLanzarException()`
   - Compra con id_estado=61 → intentar anular → excepción de negocio

4. `Handle_ConCompraCompletada_DebeLanzarException()`
   - Compra con id_estado=66 → intentar anular → excepción de negocio

### `Unit/Comandos/CrearNotaCreditoCompraHandlerTests.cs`

Leer `CrearNotaCreditoCompraManejador.cs`. La NC referencia una compra origen. Llama `RegistrarSalidaNotaCreditoAsync` con tipo `DevolucionCompra (id=24)`.

1. `Handle_ConCompraReferenciada_DebeCrearNotaCredito()`
   - Comando con IdCompraOrigen válido → NC creada con referencia correcta

2. `Handle_ConMontoMayorQueCompra_DebeLanzarException()`
   - Monto NC > Monto total de la compra → excepción

3. `Handle_ConNotaCreada_DebeLlamarInventarioConTipoMovimiento24()`
   - Verify: `RegistrarSalidaNotaCreditoAsync` llamado Times.Once (con el tipo correcto según el servicio)

### `Unit/Integracion/InventarioServicioTests.cs`

Probar la clase concreta `InventarioServicio` usando un `HttpMessageHandler` mockeado.

**Patrón obligatorio para mockear HttpClient:**
```csharp
using Moq.Protected;
using System.Net;

var handlerMock = new Mock<HttpMessageHandler>();
handlerMock
    .Protected()
    .Setup<Task<HttpResponseMessage>>(
        "SendAsync",
        ItExpr.IsAny<HttpRequestMessage>(),
        ItExpr.IsAny<CancellationToken>())
    .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK));

var httpClient = new HttpClient(handlerMock.Object)
{
    BaseAddress = new Uri("http://gateway-test/")
};
var servicio = new InventarioServicio(httpClient,
    Mock.Of<ILogger<InventarioServicio>>());
```

1. `RegistrarEntradaCompraAsync_ConRespuesta200_DebeRetornarTrue()`
   - Handler devuelve 200 → resultado = true

2. `RegistrarEntradaCompraAsync_ConRespuesta500_DebeRetornarFalse()`
   - Handler devuelve 500 → resultado = false

3. `RegistrarEntradaCompraAsync_ConExcepcionDeRed_DebeRetornarFalseYLoguear()`
   - Handler lanza `HttpRequestException` → resultado = false (no lanza, loguea)

4. `EliminarMovimientosCompraAsync_ConRespuesta200_DebeRetornarTrue()`
   - Llamada DELETE → resultado = true

5. `RegistrarSalidaNotaCreditoAsync_DebeEnviarRequestAInventarioMovimientos()`
   - Verify: la petición HTTP va a la URL que contiene "inventario/movimientos"

6. `RegistrarEntradaNotaDebitoAsync_DebeEnviarRequestAInventarioMovimientos()`
   - Verify: la petición HTTP va a la URL que contiene "inventario/movimientos"

### `Unit/Validadores/CrearCompraValidatorTests.cs`

Leer `CrearCompraValidator.cs`. Instanciar directamente.

1. `Validar_SinDetalles_DebeFallar()`
   - Lista de detalles vacía → IsValid=false

2. `Validar_ConCantidadCero_DebeFallar()`
   - Detalle con Cantidad=0 → IsValid=false

3. `Validar_ConPrecioUnitarioNegativo_DebeFallar()`
   - Detalle con PrecioUnitario=-1 → IsValid=false

4. `Validar_SinProveedor_DebeFallar()`
   - IdProveedor=0 o null → IsValid=false

5. `Validar_ConDatosCompletos_DebePasar()`
   - Todos los campos válidos → IsValid=true

### `Integration/Endpoints/ComprasEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Mockear `IInventarioServicio` en el contenedor DI del test para que no llame al servicio real.

1. `GET_Compras_DebeRetornarListaPaginada()`
   - GET /api/compras → 200 OK

2. `GET_Compras_PorId_ConIdValido_DebeRetornarDetalle()`
   - Crear compra, GET /api/compras/{id} → 200 OK

3. `POST_Compras_ConDatosValidos_DebeRetornar201()`
   - POST /api/compras con body válido → 201

4. `POST_Compras_SinDetalles_DebeRetornar400()`
   - POST con lista detalles vacía → 400

5. `PUT_Compras_Anular_ConMotivoValido_DebeAnular()`
   - PUT /api/compras/{id}/anular → 200 OK, estado cambia a 61

### `Integration/Endpoints/ReportesComprasEndpointTests.cs`

Endpoint: `GET /api/compras/reportes/compras-proveedor`
Parámetros opcionales: `fechaInicio`, `fechaFin`, `top` (default: últimos 30 días, top 10).

1. `GET_ComprasProveedor_SinFiltroFecha_UsaUltimos30Dias()`
   - Sin parámetros → 200 OK (usa últimos 30 días internamente)

2. `GET_ComprasProveedor_ConFiltroFecha_DebeRetornarSoloPeriodo()`
   - Con fechaInicio y fechaFin específicas → 200 OK

3. `GET_ComprasProveedor_ConTop5_DebeRetornarMaximo5()`
   - top=5 → lista con máximo 5 elementos

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`) — NO usar `Assert.Equal()`
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Para mockear `HttpMessageHandler` SIEMPRE usar `Moq.Protected`
- En integration tests, registrar `IInventarioServicio` como mock en el builder de test:
  ```csharp
  services.AddScoped<IInventarioServicio>(_ => inventarioMock.Object);
  ```

## Verificación final

```
dotnet build tests/Compras.API.Tests/Compras.API.Tests.csproj
dotnet test tests/Compras.API.Tests/Compras.API.Tests.csproj --filter "Category!=Integration"
```
