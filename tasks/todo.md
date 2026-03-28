# TODO: SistemaComercial

## Tareas Completadas ✅
- [x] Corregir errores de compilación en Backend (Inventario.API, Configuracion.API). <!-- id: 1 -->
- [x] Resolver error `TypeError: .map is not a function` en Frontend. <!-- id: 2 -->
- [x] Estandarizar acceso a `.datos` en componentes de búsqueda y formularios. <!-- id: 3 -->
- [x] Corregir lógica de eliminación de compras (Reversión de ValorTotal y Anulación de Kardex). <!-- id: 4 -->
- [x] Corregir esquema de base de datos para `Sucursal` (Backend) <!-- id: 7 -->
- [x] Corregir error de sintaxis en `DialogoFinalizarVenta.tsx` (Frontend) <!-- id: 8 -->
- [x] Reparar importación rota de `reglasDocumentoService` (Frontend) <!-- id: 9 -->
- [x] Implementar Sistema de Ubigeo Recursivo (Backend Dapper + Frontend Select Cascada). <!-- id: 12 -->
- [x] Integrar Ubigeos en Dashboard y Menú de Configuración (PaginaUbigeos). <!-- id: 13 -->
- [x] Generar Carga masiva de Ubigeos (2115 registros) desde CSV con ID corregido. <!-- id: 14 -->

## Tareas Pendientes 🚀
- [x] Consolidad scripts SQL en `Codigo/Backend/scripts/database_setup_master.sql`. <!-- id: 15 -->
- [x] Rediseñar Layout de Formularios Clientes/Proveedores (Alta Densidad) para evitar scroll. <!-- id: 16 -->
- [x] Corrección de errores de sintaxis JSX tras rediseño de formularios. <!-- id: 17 -->
- [ ] Implementar recálculo retroactivo de saldos de Kardex tras anulación. <!-- id: 5 -->
- [ ] Refactorizar el resto de módulos (Ventas, Contabilidad) al nuevo estándar `PagedResponse`. <!-- id: 6 -->
- [ ] Resolver los 26 errores restantes de TypeScript detectados durante el build. <!-- id: 10 -->
- [ ] Realizar prueba de flujo completo: Crear Venta -> Generar Comprobante -> Validar Stock. <!-- id: 11 -->
- [x] Herramientas: Botón de consulta SUNAT (Simulado)
- [x] Estabilización: Reseteo de secuencias en PostgreSQL
- [x] Documentación: Actualización de lessons.md y decisions.md

## Revisión Final
- [x] Compilación total de la solución (Backend).
- [x] Verificación de persistencia en BD para eliminación de compras.
- [x] Carga exitosa del módulo POS sin errores de importación dinámica.
