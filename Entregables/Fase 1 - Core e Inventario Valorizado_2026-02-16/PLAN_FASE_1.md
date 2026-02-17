# Fase 1: Núcleo de Inventario y Gestión de Documentos

Esta fase se centra en establecer la base técnica para la valorización de inventarios (Kardex) y la gestión de series requerida por SUNAT, además de preparar el terreno para las Notas de Crédito/Débito.

## Revision de Usuario Requerida

> [!IMPORTANT]
> Se ha detectado que la tabla `configuracion.series_comprobantes` ya existe en el dump SQL, por lo que se utilizará la estructura actual ajustando solo lo necesario para el backend.
>
> [!WARNING]
> La implementación del **Costo Promedio Ponderado (CPP)** alterará el flujo de grabación de Ventas, ya que cada venta deberá "consumir" el costo actual calculado en el Kardex.

## Cambios Propuestos

### Componente: Base de Datos (PostgreSQL)

#### [MODIFY] [Kardex Valorizado]

Añadir campos a la tabla `inventario.movimientos_inventario`:

- `saldo_cantidad`: Cantidad acumulada después del movimiento.
- `saldo_valorizado`: Valor total del stock acumulado después del movimiento.
- `costo_promedio_actual`: Costo promedio calculado al momento del movimiento.

#### [NEW] [Notas Electrónicas]

Crear tablas para Notas de Crédito y Débito en los esquemas `compras` y `ventas`:

- `ventas.notas_credito` y `ventas.detalle_notas_credito`.
- `compras.notas_credito` y `compras.detalle_notas_credito`.

---

### Componente: Backend (.NET Core)

#### [MODIFY] [Inventario.API](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Inventario.API)

- Actualizar `MovimientoInventario.cs` con los nuevos campos de saldos.
- Modificar `CrearMovimientoInventarioManejador.cs` para implementar la fórmula de CPP:
  - `Nuevo Costo Promedio = (Saldo Valorizado Anterior + Valor Entrada) / (Saldo Cantidad Anterior + Cantidad Entrada)`

#### [MODIFY] [Ventas.API](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Ventas.API)

- Implementar la lógica para consultar el `SeriesComprobantes` antes de grabar una venta.
- Actualizar el registro de venta para que al enviar el movimiento al inventario, recupere y almacene el costo de venta.

#### [MODIFY] [Compras.API](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Compras.API)

- Asegurar que cada ingreso por compra envíe al Inventario el costo unitario real (sin IGV) para la correcta valorización.

---

### Componente: Frontend (React)

#### [MODIFY] [Kardex View]

- Actualizar la interfaz de Kardex para mostrar 3 grupos de columnas:
  - **Entradas**: Cantidad, Costo Unit., Total.
  - **Salidas**: Cantidad, Costo Unit., Total.
  - **Saldos**: Cantidad, Costo Unit. Promedio, Total Valorizado.

#### [NEW] [Selector de Series]

- Añadir selectors en los formularios de Ventas para que el usuario elija la serie (F001, B001, etc.) y se visualice el correlativo siguiente.

## Plan de Verificación

### Pruebas Automatizadas

- Ejecutar pruebas unitarias de cálculo CPP (se crearán en `Inventario.API.Tests`).
- Validar via comandos SQL que los saldos en `movimientos_inventario` sean consistentes.

### Verificación Manual

1. Registrar una Compra con costo X.
2. Verificar en Kardex que el Saldo Valorizado sea correcto.
3. Registrar una Venta.
4. Verificar que la Salida en Kardex use el costo promedio calculado y que el Saldo final disminuya proporcionalmente.
5. Comprobar que el correlativo de la Serie aumente en +1.
