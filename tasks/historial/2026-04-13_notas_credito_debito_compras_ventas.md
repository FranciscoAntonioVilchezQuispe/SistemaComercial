# Historial — 2026-04-13 — Notas de Crédito y Débito

## Contexto
Se requiere habilitar la gestión completa (listado, detalle y creación) de Notas de Crédito y Débito en los módulos de Compras y Ventas, asegurando la consistencia de los datos fiscales y el impacto correcto en el inventario.

## Tareas Iniciales
- [ ] Backend: Ventas.API - Endpoints de Detalle
- [ ] Backend: Ventas.API - Refactorizar CrearNotaDebitoManejador
- [ ] Backend: Compras.API - Listado y Detalle
- [ ] Backend: Compras.API - Refactorizar Manejadores
- [ ] Frontend: Componentes compartidos y páginas de listado

## Detalles Técnicos
- Se implementará el recálculo de totales en el backend para evitar discrepancias con el frontend.
- Se usará el sistema de correlativos automáticos por serie.
- Se estandarizará el impacto en inventario basado en el módulo (Ventas vs Compras).
