# AGENTE-7 — Ventas.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Ventas.API.Tests/` — el microservicio más grande. Cubre: ventas con cálculo de IGV, sistema de turnos y cajas con arqueo, evento de dominio VentaCreada, integración HTTP con Inventario, y reportes.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/Ventas.API/Ventas.API.Application/Manejadores/CrearVentaManejador.cs
src/Ventas.API/Ventas.API.Application/Manejadores/AnularVentaManejador.cs
src/Ventas.API/Ventas.API.Application/Manejadores/CrearNotaCreditoManejador.cs
src/Ventas.API/Ventas.API.Application/Manejadores/VentaCreadaIntegracionHandler.cs
src/Ventas.API/Ventas.API.Application/Eventos/VentaCreadaEvento.cs
src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosManejadores.cs
src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosRequests.cs
src/Ventas.API/Ventas.API.Application/DTOs/TurnosDto.cs
src/Ventas.API/Ventas.API.Application/Interfaces/IInventarioServicio.cs
src/Ventas.API/Ventas.API.Application/Integracion/InventarioServicio.cs
src/Ventas.API/Ventas.API.Application/Interfaces/IVentasDbContext.cs
src/Ventas.API/Ventas.API.Domain/Entidades/Venta.cs
src/Ventas.API/Ventas.API.Domain/Entidades/TurnoVendedor.cs
src/Ventas.API/Ventas.API.Domain/Entidades/CierreTurno.cs
src/Ventas.API/Ventas.API.Domain/Interfaces/IVentaRepositorio.cs
src/Ventas.API/Ventas.API.API/Endpoints/VentaEndpoints.cs
src/Ventas.API/Ventas.API.API/Endpoints/TurnosEndpoints.cs
src/Ventas.API/Ventas.API.API/Endpoints/CajaEndpoints.cs
src/Ventas.API/Ventas.API.API/Endpoints/ReportesEndpoints.cs
src/Ventas.API/Ventas.API.API/Program.cs
```

## Archivo .csproj a crear

`tests/Ventas.API.Tests/Ventas.API.Tests.csproj`:
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
    <ProjectReference Include="..\..\src\Ventas.API\Ventas.API.API\Ventas.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Conocimiento del dominio (LEER CON ATENCIÓN)

### Estados de venta
| ID | Estado |
|----|--------|
| 60 | Registrado |
| 61 | Anulado Directo |
| 64 | Anulado NC |
| 65 | Anulado ND |

Al anular → `id_estado = 61`. Los estados 61, 64 y 65 se excluyen de los cálculos de arqueo.

### Tipos de movimiento que Ventas envía a Inventario
| ID | Nombre | Cuándo |
|----|--------|--------|
| 20 | SAL_VEN | Al crear venta |
| 25 | DevolucionVenta | Al crear NC de venta |
| 27 | NotaDebitoVenta | Al crear ND de venta |

### IInventarioServicio (Ventas)
```csharp
Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad,
    long idVenta, long idTipoComprobante, string serie, string numero,
    DateTime? fechaMovimiento = null, string codigoOperacionSunat = "01");

Task<bool> AnularMovimientosVentaAsync(long idVenta);

Task<bool> RegistrarEntradaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad,
    long idNota, string serie, string numero, long idTipoComprobante,
    DateTime? fechaMovimiento = null, string codigoOperacionSunat = "05");

Task<bool> RegistrarSalidaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad,
    long idNota, string serie, string numero, long idTipoComprobante,
    DateTime? fechaMovimiento = null, string codigoOperacionSunat = "01");
```

### VentaCreadaEvento
```csharp
public record VentaCreadaEvento(
    long VentaId,
    long IdAlmacen,
    long IdTipoComprobante,
    string Serie,
    string Numero,
    DateTime FechaEmision,
    List<VentaItemDetalle> Items) : INotification;

public record VentaItemDetalle(long IdProducto, decimal Cantidad);
```

El `CrearVentaManejador` publica este evento con `IMediator.Publish()`.
El `VentaCreadaIntegracionHandler` lo recibe y llama `IInventarioServicio.RegistrarSalidaVentaAsync` por cada item.

### Fórmula de arqueo de turno
```
MontoEsperado = MontoApertura
              + SUM(pagos en efectivo de ventas activas)
              + SUM(movimientos manuales positivos)
              - SUM(movimientos manuales negativos)

DiferenciaArqueo = MontoFisicoContado - MontoEsperado
```
Ventas activas = ventas donde `id_estado NOT IN (61, 64, 65)`.

---

## SUBGRUPO A — Ventas principales

### `Unit/Comandos/CrearVentaHandlerTests.cs`

Mockear: `IVentasDbContext` (o repositorios), `IMediator`, `IInventarioServicio`.

**Setup base:**
```csharp
var mediatorMock = new Mock<IMediator>();
var inventarioMock = new Mock<IInventarioServicio>();
inventarioMock
    .Setup(s => s.RegistrarSalidaVentaAsync(
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<decimal>(),
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<string>(),
        It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<string>()))
    .ReturnsAsync(true);
```

1. `Handle_ConClienteYDetalles_DebeCrearVentaConId()`
   - Venta con 1 detalle válido → resultado.Id > 0

2. `Handle_ConAfectacionGravada_DebeCalcularIgv18Porciento()`
   - Detalle con TipoAfectacionIgv = gravado, Subtotal=100
   - Assert: IGV ≈ 18.00, Total ≈ 118.00 (tolerancia ±0.01)

3. `Handle_ConAfectacionExonerada_DebeCalcularIgvCero()`
   - Detalle con TipoAfectacionIgv = exonerado
   - Assert: IGV = 0, Total = Subtotal

4. `Handle_ConPagoEfectivo_DebeRegistrarPago()`
   - Comando incluye pago con MetodoPago=Efectivo
   - Assert: el pago se guarda con MontoPago correcto

5. `Handle_AlCrearVenta_DebePublicarVentaCreadaEvento()`
   - Verify: `mediatorMock.Publish(It.IsAny<VentaCreadaEvento>(), ...)` llamado `Times.Once`

6. `Handle_ConVentaCreada_DebeAsignarNumeroCorrelativo()`
   - Assert: resultado.Numero no es null ni vacío

### `Unit/Comandos/AnularVentaHandlerTests.cs`

1. `Handle_ConVentaRegistrada_DebeCambiarEstadoA61()`
   - Venta con id_estado=60 → después de anular: id_estado=61

2. `Handle_ConVentaAnulada_DebeLlamarAnularMovimientosInventario()`
   - Verify: `AnularMovimientosVentaAsync(idVenta)` llamado `Times.Once`

3. `Handle_ConVentaYaAnulada_DebeLanzarException()`
   - Venta ya con id_estado=61 → lanza excepción de negocio

### `Unit/Eventos/VentaCreadaIntegracionHandlerTests.cs`

Instanciar `VentaCreadaIntegracionHandler` con `IInventarioServicio` mockeado.

1. `Handle_ConVentaCreada_DebeLlamarRegistrarSalidaPorCadaItem()`
   - Evento con 2 items → `RegistrarSalidaVentaAsync` llamado `Times.Exactly(2)`

2. `Handle_ConInventarioRetornandoFalse_DebeLoguearWarningYContinuar()`
   - Setup: inventario devuelve false → el handler NO lanza excepción, continúa con los siguientes items

3. `Handle_ConInventarioLanzandoException_DebeLoguearErrorYContinuar()`
   - Setup: inventario lanza `HttpRequestException` → el handler NO propaga la excepción

4. `Handle_ConVentaDe3Items_DebeLlamar3VecesInventario()`
   - Evento con 3 items → Verify Times.Exactly(3)

### `Unit/Integracion/InventarioServicioTests.cs`

Probar `InventarioServicio` (Ventas) con `HttpMessageHandler` mockeado.

**Patrón obligatorio:**
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

1. `RegistrarSalidaVentaAsync_ConRespuesta200_DebeRetornarTrue()`
2. `RegistrarSalidaVentaAsync_ConRespuesta500_DebeRetornarFalseYLoguear()`
3. `RegistrarSalidaVentaAsync_ConExcepcionRed_DebeRetornarFalse()`
   - Setup: handler lanza `HttpRequestException` → resultado = false (no lanza)
4. `AnularMovimientosVentaAsync_ConRespuesta200_DebeRetornarTrue()`
5. `RegistrarEntradaNotaCreditoAsync_DebeEnviarRequestAInventarioMovimientos()`
   - Verify: petición POST a URL con "inventario/movimientos"
6. `RegistrarSalidaNotaDebitoAsync_DebeEnviarRequestAInventarioMovimientos()`

---

## SUBGRUPO B — Sistema de Turnos

### `Unit/Turnos/AbrirTurnoHandlerTests.cs`

Leer `AbrirTurnoManejador` en `TurnosManejadores.cs`. Usa `IVentasDbContext` con `DbSet<TurnoVendedor>`. Para mockear el DbContext con EF Core, usar `MockDbSet` o `InMemoryDatabase`.

**Recomendación**: usar `Microsoft.EntityFrameworkCore.InMemory` para estos tests en lugar de Moq puro, ya que el handler hace queries LINQ sobre el DbSet.

```csharp
var options = new DbContextOptionsBuilder<VentasDbContext>()
    .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
    .Options;
var context = new VentasDbContext(options);
```

1. `Handle_ConUsuarioSinTurnoAbierto_DebeCrearTurnoAbierto()`
   - No hay turno abierto para el usuario → crear turno con Estado="ABIERTO"
   - Assert: turno guardado en context.TurnosVendedor con Estado="ABIERTO"

2. `Handle_ConUsuarioConTurnoYaAbierto_DebeLanzarException()`
   - Insertar turno existente con Estado="ABIERTO" para el mismo usuario
   - Assert: lanza `Exception` con mensaje que indique turno ya abierto

3. `Handle_ConCajaYMontoApertura_DebeAsignarALTurno()`
   - Comando con CajaId=5, MontoApertura=200
   - Assert: turno guardado tiene CajaId=5 y MontoApertura=200

### `Unit/Turnos/CerrarTurnoHandlerTests.cs`

Leer `CerrarTurnoManejador` en `TurnosManejadores.cs`. Usar InMemoryDatabase.

**Escenario de arqueo de referencia:**
```
MontoApertura:       200.00
Ventas efectivo:     800.00  (pagos con MetodoPago.Codigo="EFECTIVO")
Ingresos manuales:   100.00  (MovimientoCaja con Monto > 0, sin IdPagoRelacionado)
Egresos manuales:     50.00  (MovimientoCaja con Monto < 0, sin IdPagoRelacionado)
─────────────────────────────
MontoEsperado:     1,050.00
MontoFisicoContado: 1,020.00
DiferenciaArqueo:     -30.00  (faltante)
```

**Setup base:**
```csharp
// Crear métodos de pago
context.MetodosPago.AddRange(
    new MetodoPago { Id = 1, Codigo = "EFECTIVO", Nombre = "Efectivo" },
    new MetodoPago { Id = 2, Codigo = "TARJETA", Nombre = "Tarjeta" }
);
```

1. `Handle_ConTurnoAbierto_DebeCerrarTurnoConEstadoCerrado()`
   - Turno en BD con Estado="ABIERTO" → resultado.Estado debe ser "CONFIRMADO" (leer el manejador para el estado exacto)

2. `Handle_ConVentasEfectivo_DebeCalcularMontoEsperadoCorrectamente()`
   - Apertura=200, ventas efectivo=800 → MontoEsperado=1000

3. `Handle_ConMovimientosManualesIngreso_DebeAgregarAlMontoEsperado()`
   - Apertura=200, ingresos manuales=100 → MontoEsperado=300

4. `Handle_ConMovimientosManualesEgreso_DebeRestarDelMontoEsperado()`
   - Apertura=200, egresos manuales=50 → MontoEsperado=150

5. `Handle_ConArqueoCorrecto_DebeDiferenciaArqueoEnCero()`
   - MontoFisicoContado = MontoEsperado → DiferenciaArqueo=0

6. `Handle_ConArqueoConFaltante_DebeDiferenciaArqueoNegativa()`
   - MontoFisicoContado=1020, MontoEsperado=1050 → DiferenciaArqueo=-30

7. `Handle_ConVentasAnuladas_DebeExcluirlas_DelCalculoTotales()`
   - Turno con 2 ventas: una con id_estado=60 (activa, total=100) y otra con id_estado=61 (anulada, total=200)
   - Assert: TotalVentas del cierre = 100 (solo la activa)

8. `Handle_ConTurnoCerrado_DebeLanzarException()`
   - Turno con Estado="CERRADO" → lanza excepción

9. `Handle_ConTurnoDeOtroUsuario_DebeLanzarException()`
   - Turno pertenece a UsuarioVendedorId=1, comando con UsuarioVendedorId=2 → excepción

### `Unit/Turnos/ObtenerResumenPrevioCierreHandlerTests.cs`

Leer `ObtenerResumenPrevioCierreManejador`. Igual que CerrarTurno pero sin commit y devuelve `TurnoResumenPrevioDto`.

1. `Handle_ConTurnoAbierto_DebeRetornarResumenConTotales()`
   - Turno con ventas → resumen incluye TotalVentas, TotalEfectivo, etc.

2. `Handle_ConPagosPorMetodo_DebeDesglosarCorrectamente()`
   - 1 pago efectivo=300, 1 pago tarjeta=200 → TotalEfectivo=300, TotalTarjeta=200

3. `Handle_ConTurnoDeOtroUsuario_DebeLanzarException()`
   - UsuarioVendedorId no coincide → excepción

### `Unit/Turnos/RegistrarMovimientoCajaHandlerTests.cs`

Leer `RegistrarMovimientoCajaManejador`. Usar InMemoryDatabase.

1. `Handle_ConMontoPositivo_DebeRegistrarIngreso()`
   - Monto=100 → movimiento guardado con Monto=100

2. `Handle_ConMontoNegativo_DebeRegistrarEgreso()`
   - Monto=-50 → movimiento guardado con Monto=-50

3. `Handle_ConMontoCero_DebeLanzarException()`
   - Monto=0 → lanza excepción ("El monto no puede ser cero")

### `Unit/Turnos/ObtenerHistorialTurnosHandlerTests.cs`

`ObtenerHistorialTurnosManejador` usa Dapper con `COUNT(*) OVER()`. Para unit tests, mockear la conexión o usar InMemory + Dapper con SQLite.

1. `Handle_ConFiltroEstadoAbierto_DebeRetornarSoloAbiertos()`
2. `Handle_ConFiltroCaja_DebeRetornarSoloDeCaja()`
3. `Handle_ConPaginacion_DebeRetornarPagedResponse()`
   - PageNumber=1, PageSize=2, Total=5 → TotalPages=3

### `Unit/Cajas/CrearActualizarCajaHandlerTests.cs`

Leer `CrearCajaManejador`, `ActualizarCajaManejador`, `CambiarEstadoCajaManejador` en `TurnosManejadores.cs`.

1. `CrearCaja_ConDatosValidos_DebeCrearConEstado60()`
   - Caja creada con IdEstado=60 (Registrado)

2. `ActualizarCaja_ConCajaExistente_DebeActualizarNombreYAlmacen()`
   - Caja existente → actualizar NombreCaja e IdAlmacen

3. `ActualizarCaja_ConCajaInexistente_DebeRetornarNull()`
   - FindAsync devuelve null → handler devuelve null

4. `CambiarEstado_ConActivadoFalse_DebeDesactivarCaja()`
   - CambiarEstadoCajaRequest con Activado=false → Caja.Activado=false

---

## SUBGRUPO C — Integration Endpoints

### `Integration/Endpoints/TurnosEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Registrar `IInventarioServicio` como mock en el builder.

Antes de cada test de turno, registrar el header `X-User-Id` o usar token con el userId correcto.

1. `POST_Turnos_Abrir_ConTokenVendedor_DebeRetornar200ConTurnoAbierto()`
   - POST /api/turnos/abrir con body `{cajaId, montoApertura}` → 200 OK, body tiene `estado: "ABIERTO"`

2. `POST_Turnos_Abrir_ConTurnoYaAbierto_DebeRetornar400()`
   - Abrir 2 veces con mismo usuario → segundo intento devuelve 400 o 500

3. `POST_Turnos_Cerrar_ConMontoFisico_DebeRetornar200ConCierreTurno()`
   - Abrir turno primero, luego POST /api/turnos/cerrar → 200 OK con DiferenciaArqueo

4. `GET_Turnos_Actual_ConTokenVendedor_DebeRetornarTurnoAbierto()`
   - Abrir turno, GET /api/turnos/actual → 200 OK con Estado="ABIERTO"

5. `GET_Turnos_Actual_SinTurnoAbierto_DebeRetornar404()`
   - Sin turno abierto, GET /api/turnos/actual → 404

6. `GET_Turnos_ResumenPrevio_DebeRetornarTotalesPorMetodoPago()`
   - Abrir turno, GET /api/turnos/resumen-previo/{turnoId} → 200 OK con totales

7. `GET_Turnos_Historial_ConFiltros_DebeRetornarPaginado()`
   - GET /api/turnos/historial?pageNumber=1&pageSize=10 → 200 OK con PagedResponse

### `Integration/Endpoints/CajaEndpointTests.cs`

1. `GET_Cajas_DebeRetornarTodasLasCajas()`
   - GET /api/cajas → 200 OK

2. `GET_Cajas_PorId_ConIdValido_DebeRetornarDetalle()`
   - Crear caja, GET /api/cajas/{id} → 200 OK

3. `POST_Cajas_ConDatosValidos_DebeCrear()`
   - POST /api/cajas con `{nombreCaja, idAlmacen}` y token Admin → 201

4. `PUT_Cajas_ConDatosValidos_DebeActualizar()`
   - PUT /api/cajas/{id} → 200 OK

5. `PATCH_Cajas_Estado_DebeActivarDesactivar()`
   - PATCH /api/cajas/{id}/estado con `{activado: false}` → 200 OK

6. `POST_Cajas_Movimientos_ConMontoPositivo_DebeRegistrar()`
   - POST /api/cajas/{cajaId}/movimientos con `{monto: 100, concepto: "Ingreso manual"}` → 201

7. `GET_Cajas_Movimientos_ConTurnoId_DebeRetornarMovimientos()`
   - GET /api/cajas/{cajaId}/movimientos?turnoId={id} → 200 OK

### `Integration/Endpoints/VentasEndpointTests.cs`

Registrar `IInventarioServicio` como mock para que no llame al servicio real.

1. `GET_Ventas_DebeRetornarListaPaginada()`
   - GET /api/ventas → 200 OK

2. `POST_Ventas_Factura_ConClienteRuc_DebeRetornar201()`
   - POST con TipoComprobante=Factura, cliente con RUC → 201

3. `POST_Ventas_Boleta_ConClienteDni_DebeRetornar201()`
   - POST con TipoComprobante=Boleta, cliente con DNI → 201

4. `POST_Ventas_SinCliente_DebeRetornar400()`
   - POST sin IdCliente → 400

5. `PUT_Ventas_Anular_ConMotivoValido_DebeAnular()`
   - Crear venta, PUT /api/ventas/{id}/anular → 200 OK, estado=61

### `Integration/Endpoints/ReportesVentasEndpointTests.cs`

1. `GET_RankingProductos_SinFiltros_UsaUltimos30Dias()`
   - GET /api/ventas/reportes/ranking-productos → 200 OK

2. `GET_RankingProductos_ConTop5_DebeRetornarMaximo5()`
   - GET /api/ventas/reportes/ranking-productos?top=5 → lista con ≤ 5 elementos

3. `GET_TopClientes_SinFiltros_DebeRetornarLista()`
   - GET /api/ventas/reportes/top-clientes → 200 OK

4. `GET_TopClientes_ConFechas_DebeRetornarEnRango()`
   - Con fechaInicio y fechaFin → 200 OK

---

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`) — NO usar `Assert.Equal()`
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Para handlers con DbContext: usar `UseInMemoryDatabase` de EF Core
- Para `InventarioServicio`: usar `Moq.Protected` en `HttpMessageHandler`
- En integration tests registrar el mock:
  ```csharp
  services.AddScoped<IInventarioServicio>(_ => inventarioMock.Object);
  ```
- Tolerancia en decimales: `.Should().BeApproximately(valor, 0.01m)`

## Verificación final

```
dotnet build tests/Ventas.API.Tests/Ventas.API.Tests.csproj
dotnet test tests/Ventas.API.Tests/Ventas.API.Tests.csproj --filter "Category!=Integration"
```
