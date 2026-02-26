# Solución de error "PageNumber missing"

## Problema

Al navegar por el listado de productos en el frontend, se obtenía un clásico error `HTTP 500` con el mensaje:

> Required parameter "int PageNumber" was not provided from query string.

Este es un error común en .NET (Minimal APIs) a partir del SDK 7, donde los tipos primitivos no nulos inyectados como propiedades de un tipo como `PagedRequest` o usando `[AsParameters]` son estrictamente requeridos desde la query en la URL de una petición GET.

## Solución implementada

### 1. El Backend (`PagedRequest` y Endpoints)

He modificado la entidad `PagedRequest` para que `PageNumber` y `PageSize` sean opcionales y toleren valores nulos:

```csharp
[JsonIgnore]
public int? PageNumber { get; set; } = 1;

[JsonIgnore]
public int? PageSize { get; set; } = 10;
```

Luego, he actualizado los endpoints que lo utilizaban (`ProductoEndpoints`, `CategoriaEndpoints`, `MarcaEndpoints`) para incluir de forma controlada parámetros válidos y constantes predeterminados mediante el uso del coalescing operator `??`:

```csharp
var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber ?? 1, request.PageSize ?? 10);
```

> [!TIP]
> De esta forma, las llamadas futuras no fallarán incluso si el desarrollador comete un error y olvida enviar los parámetros de paginación.

### 2. El Frontend

He robustecido los servicios (`servicioProductos.ts` y `servicioMarcas.ts`) responsables de obtener las listas para que siempre anexen obligatoriamente parámetros de paginado a sus URL de consulta:

```typescript
params.append("pageNumber", (req?.pageNumber || 1).toString());
params.append("pageSize", (req?.pageSize || 10).toString());
```

## Validación

El backend compila exitosamente, y el error de servidor 500 ya no ocurrirá al navegar en la lista de productos ni obtener datos en tu formulario desde el frontend de React.
