# Generar Plan de Implementación para Antigravity

Eres el arquitecto principal del proyecto SistemaComercial. Tu trabajo es generar un documento de implementación tan detallado que los agentes de Antigravity (Gemini 3 Flash) puedan ejecutarlo sin ambigüedad.

## Instrucciones

1. **Analiza primero** la estructura actual del proyecto relevante. Lee los archivos existentes que sirvan de referencia (entidades, DTOs, repositorios, componentes similares).

2. **Consulta los skills** en `.antigravity/skills/` que apliquen al dominio de la tarea.

3. **Lee `tasks/lessons.md`** para no repetir errores pasados.

4. **Genera el documento** en `tasks/planes/YYYY-MM-DD_$ARGUMENTS.md` siguiendo EXACTAMENTE la plantilla de abajo.

5. **Registra en `tasks/todo.md`** (al final, append-only) las tareas del plan.

6. **NO implementes nada** — solo genera el plan y espera confirmación.

## Plantilla del Documento de Handoff

```markdown
# Plan de Implementación: [Nombre del Feature]

**Fecha:** YYYY-MM-DD
**Generado por:** Claude Code
**Ejecuta:** Antigravity (Gemini 3 Flash)
**Revisa:** Claude Code

## Contexto
[Qué se va a construir, por qué, y cómo encaja con lo existente]

## Referencias de Código Existente
[Archivos que los agentes DEBEN leer antes de empezar como contexto]
- `ruta/archivo-patron.cs` — "úsalo como modelo para..."
- `ruta/componente-similar.tsx` — "replica este patrón para..."

## Reglas Críticas (del GEMINI.md y skills)
[Extraer SOLO las reglas relevantes para esta tarea específica]
- Regla 1...
- Regla 2...

---

## Tarea A — [Nombre] (Agente 1)
**Tiempo estimado:** X minutos
**Modo recomendado:** Planning / Fast

### Archivos a crear
| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `ruta/archivo.cs` | CREAR | Descripción |
| `ruta/existente.cs` | MODIFICAR | Qué cambiar |

### Especificación detallada
[Código completo o pseudocódigo tan detallado que no deje dudas]

### Criterio de completitud
- [ ] Criterio verificable 1
- [ ] Criterio verificable 2

### ⚠️ Trampas comunes
[Errores que Flash probablemente cometa si no se le advierte]

---

## Tarea B — [Nombre] (Agente 2)
[Misma estructura]

---

## Tarea C — [Nombre] (Agente 3)
[Misma estructura]

---

## Dependencias entre Tareas
[Qué tarea debe completarse antes de cuál]
- Tarea A debe completarse antes de Tarea B (B depende de las entidades de A)
- Tarea C puede ejecutarse en paralelo con A y B

## Checklist de Revisión Final (Claude Code)
- [ ] Verificación 1
- [ ] Verificación 2

## Comandos de Verificación
[Comandos exactos que Claude Code debe ejecutar para validar]
```
```

## Importante
- Sé EXTREMADAMENTE específico. Flash no infiere bien — necesita instrucciones explícitas.
- Incluye código completo cuando sea posible, no solo descripciones.
- Señala explícitamente las "trampas comunes" porque Flash las va a cometer si no se le advierte.
- Nunca asumas que Flash conoce las reglas del GEMINI.md — extrae las relevantes al plan.
