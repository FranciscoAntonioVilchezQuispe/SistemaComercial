# Revisar Implementación de Antigravity

Los agentes de Antigravity (Gemini Flash) acaban de ejecutar un plan de implementación. Tu trabajo es revisar TODO lo que hicieron con ojo crítico de ingeniero senior.

## Instrucciones

1. **Lee el plan original** en `tasks/planes/$ARGUMENTS` para saber qué se esperaba.

2. **Revisa cada archivo** listado en el plan — tanto los creados como los modificados.

3. **Ejecuta los comandos de verificación** del plan (build, tests, linting).

4. **Evalúa contra las reglas** de `CLAUDE.md` y los `.skill` relevantes.

5. **Genera un reporte** en `tasks/revisiones/YYYY-MM-DD_revision-$ARGUMENTS.md`.

6. **Si hay correcciones necesarias**, las aplicas tú directamente — no devuelvas a Antigravity.

7. **Actualiza `tasks/lessons.md`** con errores que Flash cometió para que el plan del próximo feature los prevenga.

## Checklist de Revisión Obligatoria

### Arquitectura
- [ ] DTOs de lista solo tienen columnas del grid — no campos extras
- [ ] DTOs de detalle tienen todos los campos necesarios
- [ ] Repositorio usa Dapper con `COUNT(*) OVER()`, no dos queries
- [ ] No se usa `QueryAsync<dynamic>` — solo DTOs tipados
- [ ] Conexión de Dapper sin `using` — solo abrir si está cerrada
- [ ] Validador `AbstractValidator<T>` presente por cada DTO de entrada
- [ ] No hay Data Annotations de validación si FluentValidation está presente

### Dominio Peruano
- [ ] IGV viene de configuración — no está hardcodeado
- [ ] RUC se valida con dígito verificador
- [ ] Series siguen formato `F001`/`B001`/`FC01`/`FD01`
- [ ] Fechas usan `DateTimeHelper.ObtenerAhoraLima()` — no `DateTime.Now`
- [ ] Unicidad condicional excluye anulados (61, 64, 65)

### Frontend
- [ ] Badges de estado usan los colores correctos por `id_estado`
- [ ] Acciones de anulación solo visibles si documento no está anulado
- [ ] Formulario en `readOnly` para documentos anulados
- [ ] Nunca se reusan datos del grid para formulario de edición
- [ ] `response.datos?.map(...)` — no `response.map(...)`

### Manejo de Errores
- [ ] Todo try/catch tiene logging con contexto `[NIVEL] [CONTEXTO] [ORIGEN]`
- [ ] No hay catch vacíos
- [ ] Errores se relanzan tipados (`AppException` / `AppError`)

### Seguridad
- [ ] No hay credenciales en código fuente
- [ ] Datos de RUC/DNI no se loguean
- [ ] Comunicación externa por HTTPS

### Auditoría y BD
- [ ] Campos de auditoría presentes (fecha_creacion, usuario_creacion, etc.)
- [ ] Auditoría delegada a `SaveChangesAsync` — no manual en Handlers
- [ ] Migración es reversible
- [ ] Constraints nombrados descriptivamente

## Formato del Reporte de Revisión

```markdown
# Revisión: [Nombre del Feature]
**Fecha:** YYYY-MM-DD
**Plan revisado:** `tasks/planes/archivo.md`
**Resultado:** ✅ Aprobado / ⚠️ Aprobado con correcciones / ❌ Requiere retrabajo

## Resumen
[1-2 párrafos]

## Problemas Encontrados
### 🔴 Críticos (corregidos por Claude Code)
| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|

### 🟡 Menores (corregidos por Claude Code)
| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|

### 💡 Mejoras Sugeridas (no bloqueantes)
| # | Archivo | Sugerencia |
|---|---------|-----------|

## Lecciones para Futuros Planes
[Qué agregar a las instrucciones del plan para que Flash no repita estos errores]
```
