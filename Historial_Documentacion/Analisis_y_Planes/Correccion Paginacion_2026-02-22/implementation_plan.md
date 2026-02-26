# Solucionar el error "PageNumber missing" en Minimal APIs

El error `Required parameter "int PageNumber" was not provided from query string` ocurre porque la Minimal API usa `[AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest`. En ASP.NET Core 7+, los tipos de valor no nulos (como `int`) se consideran obligatorios si se mapean desde el query string. Cuando el frontend (`servicioProductos.ts`) hace una petición sin especificar explícitamente la página, el backend devuelve error.

## Cambios Propuestos

### Backend

1. **`Nucleo.Comun.Application.Paginacion.PagedRequest`**
   - Modificar `public int PageNumber` -> `public int? PageNumber`
   - Modificar `public int PageSize` -> `public int? PageSize`
   - Esto evita que ASP.NET Core devuelva un error si la solicitud del cliente no incluye estos valores.

2. **Endpoints (`ProductoEndpoints.cs`, `MarcaEndpoints.cs`, `CategoriaEndpoints.cs`)**
   - Actualizar el uso de `request.PageNumber` a `request.PageNumber ?? 1`
   - Actualizar el uso de `request.PageSize` a `request.PageSize ?? 10`
   - Esto asegura que los repositorios sigan recibiendo valores `int` válidos mediante un predeterminado seguro.

### Frontend

1. **`servicioProductos.ts` y `servicioMarcas.ts`**
   - Asegurar que `pageNumber` y `pageSize` se agreguen de manera robusta usando fallback al momento de agregarlos a los params, por ejemplo: `params.append("pageNumber", (req?.pageNumber || 1).toString());`

## Plan de Verificación

### Verificación Manual

1. Ejecutaré `dotnet build` en los microservicios correspondientes para verificar que todo compila con éxito.
2. El usuario podrá revisar los cambios visualizando que el frontend muestra el listado de productos de forma satisfactoria sin arrojar errores tipo 500 al navegar por la aplicación.
