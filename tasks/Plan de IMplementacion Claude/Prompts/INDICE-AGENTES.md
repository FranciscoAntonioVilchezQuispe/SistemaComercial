# Índice de Agentes — Plan de Tests Backend

**Proyecto**: `D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`
**Fecha**: 2026-04-23
**Total de agentes**: 10 (AGENTE-0 al AGENTE-9)

---

## Orden de ejecución obligatorio

```
AGENTE-0
    └─► AGENTE-1
              ├─► AGENTE-2 ─┐
              ├─► AGENTE-3  ├─► (paralelos, sin dependencias entre sí)
              ├─► AGENTE-4 ─┘
              └─► AGENTE-5
                        ├─► AGENTE-6 ─┐
                        └─► AGENTE-7 ─┴─► AGENTE-8 ─┐
                                                      └─► AGENTE-9
```

**Regla**: Un agente solo puede iniciar cuando su predecesor en la cadena ha terminado y compilado sin errores.

---

## Tabla de agentes

| Agente | Archivo de prompt | Carpeta de salida | Depende de |
|--------|------------------|-------------------|------------|
| AGENTE-0 | `AGENTE-0-Nucleo-Shared.md` | `tests/Nucleo.Tests.Shared/` y `tests/Nucleo.Tests/` | — |
| AGENTE-1 | `AGENTE-1-Identidad.md` | `tests/Identidad.API.Tests/` | AGENTE-0 |
| AGENTE-2 | `AGENTE-2-Configuracion.md` | `tests/Configuracion.API.Tests/` | AGENTE-1 |
| AGENTE-3 | `AGENTE-3-Catalogo.md` | `tests/Catalogo.API.Tests/` | AGENTE-1 |
| AGENTE-4 | `AGENTE-4-Clientes.md` | `tests/Clientes.API.Tests/` | AGENTE-1 |
| AGENTE-5 | `AGENTE-5-Inventario.md` | `tests/Inventario.API.Tests/` | AGENTE-1 |
| AGENTE-6 | `AGENTE-6-Compras.md` | `tests/Compras.API.Tests/` | AGENTE-5 |
| AGENTE-7 | `AGENTE-7-Ventas.md` | `tests/Ventas.API.Tests/` | AGENTE-5 |
| AGENTE-8 | `AGENTE-8-Contabilidad.md` | `tests/Contabilidad.API.Tests/` | AGENTE-7 |
| AGENTE-9 | `AGENTE-9-Gateway.md` | `tests/Gateway.API.Tests/` | AGENTE-8 |

---

## Instrucción para cada agente

Cada agente debe:

1. **Leer su archivo de prompt** completo antes de escribir código.
2. **Leer todos los archivos fuente** listados en la sección "Archivos fuente que DEBES leer primero".
3. **Crear los archivos** exactamente en las rutas indicadas.
4. **NO modificar** ningún archivo dentro de `src/`.
5. **Verificar que compila** con `dotnet build` antes de terminar.
6. **Reportar** si algún archivo fuente de referencia no existe.

---

## Reglas globales aplicables a todos los agentes

### Convención de nombres de tests
```
[Metodo]_[Condicion]_[ResultadoEsperado]

Ejemplos:
  Handle_ConDatosValidos_DebeCrearProducto()
  GET_SinToken_DebeRetornar401()
  POST_ConArqueoNegativo_DebePermitirConObservacion()
```

### Patrón AAA obligatorio en cada test
```csharp
[Fact]
public async Task NombreDelTest()
{
    // Arrange
    // ... preparar datos y mocks

    // Act
    var resultado = await _handler.Handle(comando, CancellationToken.None);

    // Assert
    resultado.Should().NotBeNull();
}
```

### Paquetes NuGet permitidos (no agregar otros)
```
xunit 2.9.0
xunit.runner.visualstudio 2.8.2
Microsoft.NET.Test.Sdk 17.11.0
Moq 4.20.72
FluentAssertions 6.12.1
Testcontainers.PostgreSql 3.10.0
Microsoft.AspNetCore.Mvc.Testing 8.0.8
Microsoft.EntityFrameworkCore.InMemory 8.0.8
Bogus 35.6.1
AutoFixture 4.18.1
AutoFixture.AutoMoq 4.18.1
```

### Patterns de mocking frecuentes

**Mock de HttpMessageHandler (para servicios HTTP):**
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
```

**DbContext InMemory (para handlers con EF Core):**
```csharp
var options = new DbContextOptionsBuilder<MiDbContext>()
    .UseInMemoryDatabase(Guid.NewGuid().ToString())
    .Options;
using var context = new MiDbContext(options);
```

**Mock de IInventarioServicio (AGENTES 6 y 7):**
```csharp
var inventarioMock = new Mock<IInventarioServicio>();
inventarioMock
    .Setup(s => s.RegistrarSalidaVentaAsync(
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<decimal>(),
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<string>(),
        It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<string>()))
    .ReturnsAsync(true);
```

**Registrar mock en WebApplicationFactory:**
```csharp
var factory = new WebApplicationFactory<Program>()
    .WithWebHostBuilder(builder =>
    {
        builder.ConfigureServices(services =>
        {
            services.AddScoped<IInventarioServicio>(_ => inventarioMock.Object);
        });
    });
```

### Tipos de movimiento de inventario (referencia para AGENTES 6 y 7)
| ID | Nombre | Origen |
|----|--------|--------|
| 19 | ING_COM | Compra |
| 20 | SAL_VEN | Venta |
| 24 | DevolucionCompra | NC Compra |
| 25 | DevolucionVenta | NC Venta |
| 26 | NotaDebitoCompra | ND Compra |
| 27 | NotaDebitoVenta | ND Venta |

### Estados de documentos (referencia general)
| ID | Estado | Excluido de cálculos |
|----|--------|---------------------|
| 60 | Registrado | No |
| 61 | Anulado Directo | Sí |
| 62 | Rechazado | No |
| 63 | Pendiente | No |
| 64 | Anulado NC | Sí |
| 65 | Anulado ND | Sí |
| 66 | Completado | No |

---

## Comandos de verificación por agente

Ejecutar después de que cada agente termine:

```bash
# AGENTE-0
dotnet build tests/Nucleo.Tests.Shared/Nucleo.Tests.Shared.csproj
dotnet build tests/Nucleo.Tests/Nucleo.Tests.csproj

# AGENTE-1
dotnet build tests/Identidad.API.Tests/Identidad.API.Tests.csproj

# AGENTE-2
dotnet build tests/Configuracion.API.Tests/Configuracion.API.Tests.csproj

# AGENTE-3
dotnet build tests/Catalogo.API.Tests/Catalogo.API.Tests.csproj

# AGENTE-4
dotnet build tests/Clientes.API.Tests/Clientes.API.Tests.csproj

# AGENTE-5
dotnet build tests/Inventario.API.Tests/Inventario.API.Tests.csproj

# AGENTE-6
dotnet build tests/Compras.API.Tests/Compras.API.Tests.csproj

# AGENTE-7
dotnet build tests/Ventas.API.Tests/Ventas.API.Tests.csproj

# AGENTE-8
dotnet build tests/Contabilidad.API.Tests/Contabilidad.API.Tests.csproj

# AGENTE-9
dotnet build tests/Gateway.API.Tests/Gateway.API.Tests.csproj

# Ejecutar solo unit tests (todos los proyectos)
dotnet test Codigo/Backend/ --filter "Category!=Integration&Category!=E2E"
```
