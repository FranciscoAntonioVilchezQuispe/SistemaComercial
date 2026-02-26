# Guía de Pruebas: Kardex Valorizado (Formato 13.1)

Esta guía detalla el flujo completo para probar el Kardex Valorizado, desde la configuración inicial en la base de datos hasta la emisión del reporte oficial de la SUNAT, garantizando que los módulos de Compras y Ventas están correctamente integrados con Inventarios.

---

## ⚙️ 1. Configuraciones Previas Obligatorias

Antes de iniciar cualquier transacción, asegúrate de que el entorno esté preparado:

1. **Apertura de Periodo (Kardex):**
   No se pueden registrar movimientos si el periodo en curso está cerrado o no existe.
   - **Endpoint:** `POST http://localhost:[PUERTO_INVENTARIO]/api/kardex/periodos/abrir`
   - **Body JSON:**
     ```json
     {
       "periodo": "2026-02",
       "usuarioId": 1
     }
     ```
     _(Nota: Asegúrate de usar el mes y año actual en el formato `YYYY-MM`)_.

2. **Existencia de Almacenes y Catálogos:**
   - Asegúrate de tener al menos **un Almacén** registrado.
   - Deben existir **Tipos de Comprobantes** (`01` Factura, `03` Boleta) en la BD.

---

## 📦 2. Creación del Producto

El Kardex lleva el control por Producto. Necesitamos crear un artículo nuevo para ver el Kardex limpio.

1. **Ir al Frontend (Módulo Catálogo > Productos)** o usar la API correspondiente.
2. **Crear Producto:**
   - Nombre: `Laptop Lenovo ThinkPad T14` (o cualquiera de prueba).
   - Código: `LAP-001`
   - Unidad de Medida: Seleccionar `NIU` (Unidades) o la que esté disponible.
   - Método de Valuación (si el UI lo permite): Asegurarse que el backend lo mapea por defecto a Promedio Ponderado (`PP` o `9`).
3. Anota el **ID del Producto** y el **ID del Almacén** para usarlos en el reporte al final.

---

## 🛒 3. Flujo de Compras (Entradas)

Simularemos la adquisición oficial del producto para inyectar stock valorizado.

1. **Ir al Frontend (Módulo Compras > Nueva Compra).**
2. **Llenar Datos de Cabecera:**
   - **Proveedor:** Seleccionar un proveedor existente.
   - **Tipo Documento:** `Factura` (Código SUNAT `01`).
   - **Serie y Número:** Ejemplo: `F001` - `0000123`.
3. **Agregar el Producto (`LAP-001`):**
   - **Cantidad:** `10`
   - **Costo Unitario (Precio de Compra):** `3500.00`
   - **Total:** `35000.00`
4. **Finalizar Compra:**
   - Al guardar, el módulo de Compras lanzará el evento `CompraCreadaEvento`.
   - El manejador interceptará y registrará en la DB de Inventarios (`inv_kardex_movimiento`) una **ENTRADA** con Motivo SUNAT `02`, asignando `3500.00` al Costo Promedio Unitario.

---

## 🏬 4. Flujo de Ventas (Salidas)

Ahora, venderemos parte de ese stock. El sistema debe calcular el costo de venta usando el Costo Promedio Ponderado (CPP) que es `3500.00`.

1. **Ir al Frontend (Módulo Ventas > POS o Nueva Venta).**
2. **Llenar Datos de Cabecera:**
   - **Cliente:** Seleccionar un cliente.
   - **Tipo Documento:** `Boleta` (Código SUNAT `03`).
   - **Serie y Número:** Ejemplo: `B001` - `0000555`.
3. **Agregar el Producto (`LAP-001`):**
   - **Cantidad:** `3`
   - **Precio de Venta (PVP):** `4200.00` _(Nota: El Precio de Venta NO afecta al Kardex, el Kardex se rige por Costos)_.
4. **Finalizar Venta:**
   - Al guardar, el módulo de Ventas lanza el `VentaCreadaEvento`.
   - Inventario registra una **SALIDA** con Motivo SUNAT `01`.
   - El sistema calculará internamente que esas 3 laptops salieron a un costo de `3500.00` cada una (Costo Total de Salida = `10500.00`).
   - El **Saldo Final** en el Kardex deberá quedar en `7` unidades a `3500.00` (Total Saldo: `24500.00`).

---

## 📊 5. Visualización del Kardex (Formato 13.1)

Finalmente, consultaremos el reporte para constatar que todo cuadra matemáticamente y tributariamente.

1. **Consumir Endpoint GET:**
   - Puedes usar Postman, Swagger o el navegador si tienes los IDs.
   - **URL de ejemplo:**
     `http://localhost:[PUERTO_INVENTARIO]/api/kardex/reporte?almacenId=1&productoId=[ID_PRODUCTO]&desde=2026-02-01T00:00:00&hasta=2026-02-28T23:59:59`
2. **Analizar la Respuesta JSON:**
   - **Cabecera:** Debes notar datos básicos como `Periodo` y `MetodoValuacion: "9"` (Promedio).
   - **Array `Detalles`:** Aquí verás el libro en formato de tabla SUNAT.
     - **Fila 1 (Compra):**
       - `tipoDocumentoSunat`: "01" (Factura) / `serieDocumento`: "F001" / `numeroDocumento`: "0000123"
       - `tipoOperacionSunat`: "02" (Compra)
       - `entradaCantidad`: 10 / `entradaCostoUnitario`: 3500 / `entradaCostoTotal`: 35000
       - `saldoCantidad`: 10 / `saldoCostoUnitario`: 3500 / `saldoCostoTotal`: 35000
     - **Fila 2 (Venta):**
       - `tipoDocumentoSunat`: "03" (Boleta) / `serieDocumento`: "B001" / `numeroDocumento`: "0000555"
       - `tipoOperacionSunat`: "01" (Venta)
       - `salidaCantidad`: 3 / `salidaCostoUnitario`: 3500 / `salidaCostoTotal`: 10500
       - `saldoCantidad`: 7 / `saldoCostoUnitario`: 3500 / `saldoCostoTotal`: 24500

---

## 🧪 Casos de Prueba Adicionales (Opcionales)

Para poner a prueba la robustez del motor de recálculo:

- **Compra con nuevo costo:** Compra 5 laptops más a `4000.00` cada una. El Kardex recalculará automáticamente el nuevo Costo Promedio Unitario para las 12 laptops resultantes.
- **Stock Negativo (Validación):** Intenta vender 20 unidades. Si la configuración del sistema no permite stock negativo (`PermiteStockNegativo = false`), la venta o el Kardex deberían bloquear la transacción.
