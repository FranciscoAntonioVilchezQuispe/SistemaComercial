# Implementación - Módulos Configuración Base

Se ha completado la implementación de los módulos fundamentales de configuración.

## 🏢 Módulo de Empresa

- **Backend**: Endpoint único GET/PUT.
- **Frontend**: Página `/configuracion/empresa` para gestión de datos corporativos.

## 🏪 Módulo de Sucursales

- **Backend**: CRUD completo (incluyendo Delete).
- **Frontend**: Página `/configuracion/sucursales`, gestión de tiendas/almacenes.

## 💰 Módulo de Impuestos

- **Backend**: CRUD completo.
- **Frontend**: Página `/configuracion/impuestos`, gestión de tasas (IGV, IVA).

## 💳 Módulo de Métodos de Pago

- **Backend**: CRUD completo.
- **Frontend**: Página `/configuracion/metodos-pago`. Integración visual (Efectivo/Tarjeta).

## 📄 Módulo de Comprobantes (Series y Tipos)

- **Backend**:
  - Nueva entidad `TipoComprobante` para reglas de negocio (Kardex: Entrada/Salida).
  - Integración `SerieComprobante` -> `TipoComprobante`.
  - CRUD para ambos.
- **Frontend**:
  - Página `/configuracion/comprobantes` con interfaz de pestañas (Tabs).
  - Gestión unificada de Tipos (Definición) y Series (Numeración).
  - Formulario con lógica condicional para movimiento de stock.

## 🔗 Próximos pasos

- **Siguiente Prioridad**: Módulo de **Gestión de Usuarios y Permisos** (Identidad).
