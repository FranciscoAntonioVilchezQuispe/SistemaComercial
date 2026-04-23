# AGENTE-FE-4 — Carrito de Ventas (Zustand) Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el store de carrito de ventas (Zustand). El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe. Este agente NO usa MSW porque el carrito es estado local puro (Zustand).

## Tu misión

Crear `src/features/ventas/__tests__/useCarrito.test.ts` con tests completos para el store de Zustand del carrito de compras, incluyendo cálculos de totales con afectación SUNAT.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/ventas/hooks/useCarrito.ts
src/compartido/utilidades/calculos.ts
src/compartido/configuracion/fiscal.config.ts
```

Lee los tres archivos completos antes de escribir cualquier test.

## Conocimiento del dominio

### Códigos de afectación IGV (SUNAT)
| Código | Tipo | Descripción |
|--------|------|-------------|
| `10` | Gravado | Se calcula IGV 18% |
| `20` | Exonerado | Sin IGV |
| `30` | Inafecto | Sin IGV |
| `11`–`16` | Gratuito gravado | No suma al total cobrado |
| `21` | Gratuito exonerado | No suma al total cobrado |
| `31`–`36` | Gratuito inafecto | No suma al total cobrado |

### Cálculo de totales (cómo funciona el carrito)
El carrito llama a `calcularTotalesVenta(items)` donde cada item tiene:
- `precio`: precio del producto (puede incluir o no IGV, depende de implementación)
- `cantidad`: unidades
- `porcentajeDescuento`: 0-100
- `codigoAfectacion`: código SUNAT

### Estado del carrito
```typescript
{
  items: ItemCarrito[],
  subtotal: number,
  subtotalGravado: number,
  subtotalExonerado: number,
  subtotalInafecto: number,
  totalGratuito: number,
  descuento: number,
  igv: number,
  total: number,
}
```

### Estructura de ItemCarrito
```typescript
{
  producto: ProductoResumen,
  cantidad: number,
  precioUnitario: number,
  descuento: number,
  subtotal: number,
}
```

### Producto mínimo para tests
```typescript
const productoGravado = {
  id: 1,
  nombre: 'Producto Gravado',
  precioVentaPublico: 118.00,
  idTipoAfectacionIgv: 10,  // código afectación SUNAT
  activo: true,
  stock: 100,
}

const productoExonerado = {
  id: 2,
  nombre: 'Producto Exonerado',
  precioVentaPublico: 100.00,
  idTipoAfectacionIgv: 20,
  activo: true,
  stock: 100,
}

const productoGratuito = {
  id: 3,
  nombre: 'Producto Gratuito',
  precioVentaPublico: 50.00,
  idTipoAfectacionIgv: 15,  // gratuito
  activo: true,
  stock: 100,
}
```

## Tests que debes implementar

```typescript
import { describe, it, expect, beforeEach } from 'vitest'
import { act } from '@testing-library/react'

// Importar el store de Zustand — ajustar según el nombre real exportado en useCarrito.ts
// import { useCarrito } from '../hooks/useCarrito'
// O puede ser: import useCarritoStore from '../hooks/useCarrito'
```

### Grupo: `agregarProducto`

1. `agregarProducto_ConProductoNuevo_AgregaItemAlCarrito()`
   ```typescript
   // Arrange
   useCarrito.getState().limpiarCarrito() // o el método real para limpiar

   // Act
   act(() => {
     useCarrito.getState().agregarProducto(productoGravado, 1)
   })

   // Assert
   const estado = useCarrito.getState()
   expect(estado.items).toHaveLength(1)
   expect(estado.items[0].cantidad).toBe(1)
   ```

2. `agregarProducto_ConProductoYaExistente_SumaCantidad()`
   ```typescript
   // Agregar 2 veces el mismo producto
   act(() => {
     useCarrito.getState().agregarProducto(productoGravado, 2)
     useCarrito.getState().agregarProducto(productoGravado, 3)
   })

   const estado = useCarrito.getState()
   expect(estado.items).toHaveLength(1) // sigue siendo 1 item único
   expect(estado.items[0].cantidad).toBe(5) // 2 + 3 = 5
   ```

3. `agregarProducto_ConProductoGravado_CalculaIGV()`
   ```typescript
   act(() => {
     useCarrito.getState().agregarProducto(productoGravado, 1)
   })

   const estado = useCarrito.getState()
   expect(estado.igv).toBeGreaterThan(0)
   expect(estado.subtotalGravado).toBeGreaterThan(0)
   ```

4. `agregarProducto_ConProductoExonerado_NoCalculaIGV()`
   ```typescript
   act(() => {
     useCarrito.getState().agregarProducto(productoExonerado, 1)
   })

   const estado = useCarrito.getState()
   expect(estado.igv).toBe(0)
   expect(estado.subtotalExonerado).toBeGreaterThan(0)
   ```

5. `agregarProducto_ConProductoGratuito_NoSumaAlTotalCobrado()`
   ```typescript
   act(() => {
     useCarrito.getState().agregarProducto(productoGratuito, 1)
   })

   const estado = useCarrito.getState()
   expect(estado.total).toBe(0)
   expect(estado.totalGratuito).toBeGreaterThan(0)
   ```

6. `agregarProducto_ConDescuento_AplicaDescuentoAlSubtotal()`
   ```typescript
   act(() => {
     useCarrito.getState().agregarProducto(productoExonerado, 1, 10) // 10% descuento
   })

   const estado = useCarrito.getState()
   // Precio original: 100, con 10% descuento: 90
   expect(estado.total).toBeCloseTo(90, 1)
   ```

### Grupo: `actualizarCantidad`

7. `actualizarCantidad_ConNuevaCantidad_ActualizaYRecalcula()`
   ```typescript
   // Arrange
   act(() => { useCarrito.getState().agregarProducto(productoExonerado, 1) })

   // Act
   act(() => {
     useCarrito.getState().actualizarCantidad(productoExonerado.id, 3)
   })

   // Assert
   const estado = useCarrito.getState()
   expect(estado.items[0].cantidad).toBe(3)
   expect(estado.total).toBeCloseTo(300, 1) // 100 × 3
   ```

8. `actualizarCantidad_ConCantidadCeroONegativa_EliminaElItem()`
   ```typescript
   // Arrange
   act(() => { useCarrito.getState().agregarProducto(productoExonerado, 1) })

   // Act — cantidad 0 debe eliminar el item
   act(() => {
     useCarrito.getState().actualizarCantidad(productoExonerado.id, 0)
   })

   // Assert
   expect(useCarrito.getState().items).toHaveLength(0)
   ```

### Grupo: `actualizarDescuento`

9. `actualizarDescuento_ConPorcentaje10_ReduceElTotal()`
   ```typescript
   act(() => { useCarrito.getState().agregarProducto(productoExonerado, 1) })

   act(() => {
     useCarrito.getState().actualizarDescuento(productoExonerado.id, 10)
   })

   const estado = useCarrito.getState()
   // 100 con 10% descuento = 90
   expect(estado.total).toBeCloseTo(90, 1)
   expect(estado.descuento).toBeGreaterThan(0)
   ```

### Grupo: `eliminarProducto`

10. `eliminarProducto_ConId_RemueveElItemDelCarrito()`
    ```typescript
    act(() => {
      useCarrito.getState().agregarProducto(productoGravado, 1)
      useCarrito.getState().agregarProducto(productoExonerado, 2)
    })

    act(() => {
      useCarrito.getState().eliminarProducto(productoGravado.id)
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(1)
    expect(estado.items[0].producto.id).toBe(productoExonerado.id)
    ```

11. `eliminarProducto_ConId_RecalculaTotales()`
    ```typescript
    act(() => {
      useCarrito.getState().agregarProducto(productoExonerado, 1) // 100
      useCarrito.getState().agregarProducto(productoGravado, 1)   // 118
    })

    const totalAntes = useCarrito.getState().total

    act(() => {
      useCarrito.getState().eliminarProducto(productoGravado.id)
    })

    const totalDespues = useCarrito.getState().total
    expect(totalDespues).toBeLessThan(totalAntes)
    ```

### Grupo: `limpiarCarrito`

12. `limpiarCarrito_ConItemsEnElCarrito_VaciaElCarritoYResetaTotales()`
    ```typescript
    act(() => {
      useCarrito.getState().agregarProducto(productoGravado, 2)
      useCarrito.getState().agregarProducto(productoExonerado, 1)
    })

    act(() => {
      useCarrito.getState().limpiarCarrito()
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(0)
    expect(estado.total).toBe(0)
    expect(estado.igv).toBe(0)
    expect(estado.subtotal).toBe(0)
    ```

### Grupo: `obtenerCantidadItems`

13. `obtenerCantidadItems_ConMultiplesItems_DevuelveSumaDeCantidades()`
    ```typescript
    act(() => {
      useCarrito.getState().agregarProducto(productoGravado, 3)
      useCarrito.getState().agregarProducto(productoExonerado, 2)
    })

    const cantidad = useCarrito.getState().obtenerCantidadItems()
    expect(cantidad).toBe(5) // 3 + 2
    ```

14. `obtenerCantidadItems_SinItems_DevuelveCero()`
    ```typescript
    expect(useCarrito.getState().obtenerCantidadItems()).toBe(0)
    ```

### Grupo: totales mezclados

15. `carrito_ConItemsGravadosYExonerados_DistribuyeCorrectamente()`
    ```typescript
    // Arrange: 1 gravado (118) + 1 exonerado (100)
    act(() => {
      useCarrito.getState().agregarProducto(productoGravado, 1)
      useCarrito.getState().agregarProducto(productoExonerado, 1)
    })

    const estado = useCarrito.getState()
    expect(estado.total).toBeCloseTo(218, 0) // 118 + 100
    expect(estado.igv).toBeGreaterThan(0)    // solo del gravado
    expect(estado.subtotalExonerado).toBeCloseTo(100, 0)
    expect(estado.subtotalGravado).toBeGreaterThan(0)
    ```

## Reglas obligatorias

- `beforeEach(() => useCarrito.getState().limpiarCarrito())` — limpiar entre tests
- Siempre envolver mutaciones del store en `act(...)`
- Leer el nombre exacto del store y sus métodos en `useCarrito.ts` antes de importar
- Si el store usa `.setState()` en lugar de métodos, adaptar los tests
- Patrón AAA en cada test
- Nombres: `[metodo]_[condicion]_[resultadoEsperado]`

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/ventas/__tests__/useCarrito.test.ts
```
