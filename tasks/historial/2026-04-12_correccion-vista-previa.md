# Sesión: Corrección de Vista Previa de Venta y Cumplimiento SUNAT
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Ventas (Backend .NET / Frontend React)
**Modelo de IA usado:** Gemini 3 Flash

---

## Objetivo de la sesión
Atender el reporte del usuario sobre la vista previa de ventas: nombres de productos genéricos, totales en 0.00 y falta de datos del cliente para cumplimiento de SUNAT.

## Tareas completadas
- [x] Investigación inicial de la arquitectura de la vista previa de ventas.
- [x] Consulta de skills de dominio (`peru-sunat-compliance` y `frontend-documentos`).
- [x] Identificación de brechas en `VentaDetalleDto`, `VentaRepositorio` y `ModalVistaPreviaVenta.tsx`.
- [x] Creación del plan de trabajo en `tasks/todo.md` y `implementation_plan.md`.

## Tareas pendientes (pasan al siguiente todo.md)
- Ninguna.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `VentaDetalleDto.cs` | MODIFY | Añadida `DireccionCliente`. |
| `VentaRepositorio.cs` | MODIFY | Actualizada consulta SQL para dirección y `COALESCE` en descripción. |
| `ventas.types.ts` | MODIFY | Añadida `direccionCliente` al tipo `VentaDetalle`. |
| `ModalVistaPreviaVenta.tsx` | MODIFY | Mejorada UI con datos de cliente, descripciones reales y etiquetas SUNAT. |
| `tasks/todo.md` | MODIFY | Actualizado estado de tareas. |
| `task.md` | CREATE | Seguimiento de ejecución. |

## Notas y observaciones
Se detectó que el frontend usaba propiedades inexistentes en el item (`subtotal`) y fallback genérico para el nombre del producto, ignorando el campo `descripcionProducto` del backend.
