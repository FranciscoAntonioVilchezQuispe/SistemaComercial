# Plan de Corrección: CRUD Completo y Gestión de Estado de Almacenes

Se implementará el ciclo de vida completo (CRUD) para la entidad Almacén, asegurando la consistencia en las respuestas mediante wrappers y permitiendo la gestión del estado (activar/desactivar).

## Cambios Propuestos

### Microservicio: Inventario.API

#### [MODIFY] [AlmacenDto.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Inventario.API/Inventario.API.Application/DTOs/AlmacenDto.cs)

- Agregar propiedad `public bool Activado { get; set; }`.

#### [MODIFY] [AlmacenEndpoints.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Inventario.API/Inventario.API.API/Endpoints/AlmacenEndpoints.cs)

- **GET** `/{id}`: Retornar un almacén específico usando `ToReturn`.
- **PUT** `/{id}`: Actualizar todos los campos de un almacén.
- **PATCH** `/{id}/estado`: Alternar el estado `Activado` del almacén.
- **DELETE** `/{id}`: Eliminar físicamente o desactivar (según convención, se implementará eliminación con validación).
- **Manejo de Errores**: Envolver las operaciones en `try-catch` y usar `ToReturnError` en caso de excepciones.
- **Consistencia**: Usar `ToReturnNoEncontrado` cuando el ID no exista.

## Plan de Verificación

### Pruebas Automatizadas (vía Swagger/cURL)

1.  **GET por ID**: Verificar que devuelve `200 OK` con el wrapper `ToReturn`.
2.  **PUT**: Verificar actualización de campos y respuesta `200 OK` con los datos actualizados.
3.  **PATCH Estado**: Verificar que el campo `Activado` cambia correctamente.
4.  **Error 404**: Intentar actualizar/obtener un ID inexistente y verificar `ToReturnNoEncontrado`.

### Pruebas Manuales (Frontend)

1.  **Edición**: Probar el botón de editar en la lista de almacenes.
2.  **Toggle Estado**: (Si existe el UI) Verificar que el switch de activado funcione correctamente.
