# Guía de Ejecución de Tests — Backend

Esta guía detalla los pasos para ejecutar la suite de pruebas del Sistema Comercial de forma manual.

## Requisitos Previos
- Tener instalado el **SDK de .NET 8.0** o superior.
- Estar en la raíz del proyecto (`d:\Personal\Proyectos\SistemaComercial`).

## 1. Ejecución Global (Recomendado)
Para ejecutar todos los tests de todos los microservicios en un solo comando:

```powershell
# Desde la carpeta raíz
dotnet test Codigo/Backend/tests
```

Este comando buscará automáticamente todos los proyectos de test (`*.Tests.csproj`) y los ejecutará secuencialmente.

## 2. Ejecución por Microservicio
Si desea probar un módulo específico, puede navegar a su carpeta o especificar la ruta:

### Identidad.API
```powershell
dotnet test Codigo/Backend/tests/Identidad.API.Tests
```

### Ventas.API
```powershell
dotnet test Codigo/Backend/tests/Ventas.API.Tests
```

### Compras.API
```powershell
dotnet test Codigo/Backend/tests/Compras.API.Tests
```

### Inventario.API (Kardex/Stock)
```powershell
dotnet test Codigo/Backend/tests/Inventario.API.Tests
```

### Configuracion.API
```powershell
dotnet test Codigo/Backend/tests/Configuracion.API.Tests
```

## 3. Opciones Útiles de Ejecución

### Ver resultados detallados
Si desea ver el nombre de cada test mientras se ejecuta:
```powershell
dotnet test Codigo/Backend/tests --logger "console;verbosity=detailed"
```

### Ejecutar solo tests fallidos
Si está corrigiendo errores y solo quiere re-ejecutar los que fallaron:
```powershell
dotnet test Codigo/Backend/tests --filter "FullyQualifiedName~Error"
```

### Ejecutar sin re-compilar
Si no ha hecho cambios en el código y quiere ganar tiempo:
```powershell
dotnet test Codigo/Backend/tests --no-build
```

## 4. Estructura de los Tests
- **Unit**: Pruebas de lógica pura (Manejadores, Validadores, Entidades) usando `InMemoryDatabase`.
- **Integration**: Pruebas de Endpoints reales usando `WebApplicationFactory`.
- **Shared**: Infraestructura común, fixtures de base de datos y helpers de autenticación.

---
**Nota**: Los tests de integración utilizan una base de datos en memoria (`InMemoryDatabase`), por lo que no requieren tener instalado PostgreSQL ni realizar migraciones reales para su ejecución.
