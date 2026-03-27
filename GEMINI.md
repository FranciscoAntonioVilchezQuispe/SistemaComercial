# 🤖 Reglas Generales para Agentes de IA
> Archivo base compartido para todos los proyectos.
> Compatible con: Cursor · Windsurf · Google Antigravity (GEMINI.md)

---

## 🚨 Autoridad de Este Archivo

> **Este archivo es la fuente de verdad absoluta para el comportamiento del agente.**

- El agente **debe leer este archivo completo al inicio de cada sesión** antes de ejecutar cualquier acción.
- Todas las decisiones técnicas, de estilo, de arquitectura y de comunicación deben estar alineadas con lo que aquí se indica.
- **Este archivo tiene prioridad** sobre cualquier suposición interna del agente, convenciones genéricas o "mejores prácticas" aprendidas durante el entrenamiento que contradigan lo definido aquí.
- Si existe un archivo de reglas específico del proyecto (ej. `PROYECTO.md`, `.cursor/rules`, `.windsurfrules`), ese archivo **complementa** estas reglas globales — nunca las reemplaza salvo que lo indique explícitamente.
- Ante cualquier duda sobre cómo proceder, el agente debe **consultar primero este archivo** antes de tomar una decisión.
- Si el agente detecta un caso no cubierto por estas reglas, debe **preguntar al usuario** en lugar de asumir.
- **Está prohibido ignorar, omitir o reinterpretar** cualquier regla de este archivo bajo el pretexto de eficiencia, simplicidad o preferencia personal del agente.

---

## 🌐 Idioma

- **TODAS las explicaciones, comentarios de código, mensajes de error, logs y respuestas deben estar en español.**
- El código en sí puede usar inglés (variables, funciones, clases) — esto es estándar técnico.
- Si el usuario escribe en español, responder siempre en español.
- Documentación generada (README, comentarios XML, docstrings) → español.

---

## 📋 Orquestación del Flujo de Trabajo

### 1. Modo Plan por Defecto
- Entrar en modo plan para CUALQUIER tarea no trivial (3+ pasos o decisiones arquitectónicas).
- Si algo sale mal, DETENTE y replantea de inmediato — no sigas avanzando a ciegas.
- Usar el modo plan también para pasos de verificación, no solo para construir.
- Escribir especificaciones detalladas desde el principio para reducir ambigüedad.

### 2. Estrategia de Subagentes
- Usar subagentes libremente para mantener limpia la ventana de contexto principal.
- Delegar investigación, exploración y análisis paralelo a subagentes.
- Para problemas complejos, lanzar más cómputo mediante subagentes.
- Una tarea por subagente para ejecución enfocada.

### 3. Bucle de Automejora
- Después de CUALQUIER corrección del usuario: actualizar `tasks/lessons.md` con el patrón aprendido.
- Escribir reglas para sí mismo que prevengan el mismo error en el futuro.
- Iterar sin piedad en estas lecciones hasta que la tasa de errores disminuya.
- Revisar las lecciones al inicio de cada sesión del proyecto relevante.

### 4. Verificación Antes de Terminar
- Nunca marcar una tarea como completa sin demostrar que funciona.
- Comparar el comportamiento entre la versión principal y los cambios cuando sea relevante.
- Preguntarse: *"¿Un ingeniero senior aprobaría esto?"*
- Ejecutar pruebas, revisar logs, demostrar corrección.

### 5. Exigir Elegancia (Balanceada)
- Para cambios no triviales: pausar y preguntar *"¿hay una forma más elegante?"*
- Si una solución se siente como parche: *"Sabiendo todo lo que sé, implementa la solución elegante."*
- Omitir esto para correcciones simples y obvias — no sobrediseñes.
- Desafiar el propio trabajo antes de presentarlo.

### 6. Corrección Autónoma de Bugs
- Cuando se reporte un bug: simplemente corrígelo. No pedir que te lleven de la mano.
- Apuntar a logs, errores y pruebas fallidas — luego resolverlos.
- Cero cambios de contexto requeridos del usuario.
- Corregir los tests de CI fallidos sin que te lo indiquen explícitamente.

---

## ✅ Gestión de Tareas

1. **Plan Primero:** Escribir el plan en `tasks/todo.md` con ítems verificables.
2. **Verificar Plan:** Confirmar antes de comenzar la implementación.
3. **Seguir el Progreso:** Marcar ítems como completos a medida que se avanza.
4. **Explicar Cambios:** Resumen de alto nivel en cada paso, en español.
5. **Documentar Resultados:** Agregar sección de revisión en `tasks/todo.md`.
6. **Capturar Lecciones:** Actualizar `tasks/lessons.md` después de correcciones.

---

## 🧱 Principios Fundamentales

- **Simplicidad Primero:** Hacer cada cambio tan simple como sea posible. Impactar el mínimo de código.
- **Sin Pereza:** Encontrar las causas raíz. Sin soluciones temporales. Estándares de desarrollador senior.
- **Impacto Mínimo:** Los cambios solo deben tocar lo necesario. Evitar introducir bugs colaterales.

---

## 🛠️ Stack Técnico del Proyecto

> El agente debe asumir este stack salvo que el proyecto indique lo contrario.

| Capa | Tecnología |
|------|-----------|
| Backend .NET | .NET · PostgreSQL · Entity Framework Core · Dapper |
| Backend Node | Node.js · TypeScript · NestJS · Oracle DB |
| Mobile | Android / Kotlin · Odoo 19 JSON-RPC |
| ERP | Odoo 19 (módulos Python) |
| BD GUI | DBeaver |
| IDE IA | Cursor · Windsurf · Google Antigravity |
| Mercado | Perú (SUNAT · RENIEC · ONP) |

---

## 🇵🇪 Reglas de Dominio Peruano

- **IGV nunca hardcodeado** — siempre leerlo desde configuración o base de datos.
- **Validar RUC** con algoritmo de dígito verificador antes de cualquier llamada a API externa.
- **Códigos UBL 2.1 Catálogo 51** son de exactamente 4 caracteres — no abreviar ni alterar.
- **Fechas y horas** siempre en zona horaria `America/Lima` (UTC-5).
- **Series de comprobantes** siguen el formato oficial: F001, B001, FC01, FD01, etc.
- Los montos monetarios se expresan en **soles (PEN)** salvo indicación explícita.
- Los comprobantes electrónicos deben pasar **validación de schema UBL 2.1** antes de enviar a SUNAT.

---

## 🗄️ Arquitectura Híbrida EF Core + Dapper

- **EF Core** → solo para escrituras (INSERT, UPDATE, DELETE) y migraciones de esquema.
- **Dapper** → para lecturas, consultas complejas y reportes.
- **Nunca mezclar** ambos dentro del mismo método o transacción.
- Las migraciones deben ser **reversibles** — toda migración destructiva requiere script de rollback previo.

---

## 🐘 Reglas de Base de Datos (PostgreSQL)

- Índices `pg_trgm` solo en columnas de búsqueda textual — no aplicar masivamente.
- Operaciones masivas (ej: sincronización del padrón SUNAT) **siempre dentro de una transacción** con estrategia table-swap atómica.
- Nunca ejecutar `DROP` o `TRUNCATE` sin confirmación explícita del usuario.
- Nombrar constraints y índices de forma descriptiva: `idx_ruc_trgm`, `fk_cliente_tipo_doc`, etc.
- Schemas separados por dominio: `configuracion`, `ventas`, `sunat`, etc.

---

## 📱 Reglas Mobile (Android / Kotlin)

- **No hardcodear colores** — usar siempre tokens de tema como `?attr/colorSurface`, `?attr/colorOnSurface`.
- `forceDarkAllowed="false"` en todos los temas para compatibilidad con dispositivos EMUI (Honor, Huawei).
- Todas las llamadas a la API de Odoo deben ejecutarse en **Coroutines** (`viewModelScope` o `lifecycleScope`), nunca en el hilo principal.
- Usar **Material3** como sistema de diseño base.
- Los valores booleanos de la API de Odoo deben castearse explícitamente — nunca renderizar como texto directo.

---

## 🔒 Seguridad y Cumplimiento

- **Credenciales nunca en el código fuente** — usar variables de entorno, `local.properties` o Android Keystore.
- Las claves de API de terceros (SUNAT, RENIEC, apis.net.pe) van en configuración externa, nunca commiteadas.
- Los datos de RUC/DNI son datos personales — no loguearlos en producción.
- Toda comunicación con servicios externos debe usar **HTTPS**.

---

## 🔁 Reglas de Integración con Odoo 19

- Comunicación exclusivamente via **JSON-RPC** (`/web/dataset/call_kw`).
- Autenticación mediante sesión con `res.users` — no usar contraseñas en texto plano en el código.
- Siempre verificar la versión del modelo Odoo antes de asumir campos disponibles.
- Los campos `Many2one` retornan `[id, nombre]` — manejar ambos casos (con y sin valor).

---

## 🟡 Reglas de Base de Datos (Oracle)

- Usar siempre **tipos de dato Oracle correctos**: `VARCHAR2` en lugar de `VARCHAR`, `NUMBER` en lugar de `INT`, `DATE` o `TIMESTAMP WITH TIME ZONE` según el caso.
- **Nunca usar `SELECT *`** — especificar siempre las columnas explícitamente.
- Las consultas complejas deben usar **CTEs** (`WITH ... AS`) para mayor legibilidad — evitar subconsultas anidadas profundas.
- Prefijos estándar para objetos de BD:
  - Tablas: sin prefijo o según convención del proyecto
  - Secuencias: `SEQ_NOMBRE_TABLA`
  - Triggers: `TRG_NOMBRE_TABLA`
  - Índices: `IDX_TABLA_COLUMNA`
  - Procedimientos: `SP_` o `PRC_`
- **Paginación** con `OFFSET / FETCH NEXT` (Oracle 12c+) — no usar `ROWNUM` salvo compatibilidad legacy.
- Toda operación destructiva (`DROP`, `TRUNCATE`, `DELETE` masivo) requiere **confirmación explícita** del usuario.
- Usar **bind variables** siempre en consultas dinámicas — nunca concatenar valores directamente (prevención de SQL injection).
- Las transacciones deben cerrarse explícitamente con `COMMIT` o `ROLLBACK` — no asumir autocommit.
- Documentar los procedimientos almacenados con comentarios en español describiendo parámetros y lógica.

---

## 🟢 Reglas de Node.js / TypeScript / NestJS

### TypeScript General
- **Tipado estricto siempre** — `strict: true` en `tsconfig.json`. Prohibido usar `any` salvo justificación explícita.
- Preferir `interface` sobre `type` para contratos de objetos; usar `type` para unions/intersections.
- Exportar siempre tipos e interfaces desde un archivo `*.types.ts` o `*.interface.ts` dedicado.
- Usar **async/await** en lugar de callbacks o `.then()` encadenados.
- Manejo de errores con clases tipadas — nunca `catch(e: any)` sin tipar el error.

### NestJS
- Seguir la **estructura de módulos de NestJS**:
  ```
  src/
  ├── nombre-modulo/
  │   ├── nombre-modulo.module.ts
  │   ├── nombre-modulo.controller.ts
  │   ├── nombre-modulo.service.ts
  │   ├── dto/
  │   │   ├── create-nombre.dto.ts
  │   │   └── update-nombre.dto.ts
  │   └── entities/
  │       └── nombre.entity.ts
  ```
- Usar **DTOs con validación** (`class-validator` + `class-transformer`) en todos los endpoints.
- La lógica de negocio va en el **Service** — los Controllers solo orquestan, no procesan.
- Usar **Guards** para autenticación/autorización, nunca lógica de seguridad dentro del controller.
- Los **Interceptors** para transformación de respuesta y logging global.
- Los **Pipes** para transformación y validación de parámetros.
- Configuración centralizada con `@nestjs/config` y archivos `.env` — nunca `process.env.X` directo en el código de negocio.
- Manejar excepciones con **ExceptionFilter** global — no lanzar errores HTTP desde el Service.
- Documentar endpoints con **Swagger** (`@nestjs/swagger`) — decoradores `@ApiTags`, `@ApiOperation`, `@ApiResponse`.

### Integración NestJS + Oracle
- Usar **TypeORM** con el driver `oracledb` para la conexión a Oracle.
- Configurar el `DataSource` en un módulo dedicado `database.module.ts`.
- Los nombres de tablas y columnas en Oracle van en **MAYÚSCULAS** — configurar `namingStrategy` en TypeORM o mapear explícitamente con `@Column({ name: 'NOMBRE_COLUMNA' })`.
- Para consultas complejas con Oracle, usar **QueryBuilder** o repositorios con queries nativas — no ORM para joins complejos.
- Las secuencias Oracle para IDs deben configurarse en la entidad: `@PrimaryGeneratedColumn({ sequenceName: 'SEQ_TABLA' })`.
- Separar la capa de acceso a datos en **Repositories** personalizados — no inyectar el EntityManager directamente en el Service.

### Buenas Prácticas Node.js
- Variables de entorno validadas al inicio con **Joi** o **Zod** — la app no debe arrancar con config inválida.
- Logging estructurado con **Winston** o **Pino** — no usar `console.log` en producción.
- Versionar los endpoints de la API: `/api/v1/recurso`.
- Respuestas de API con estructura consistente:
  ```json
  { "data": ..., "message": "...", "statusCode": 200 }
  ```
- Siempre manejar el cierre graceful del servidor (`SIGTERM`, `SIGINT`) para no cortar conexiones a Oracle.

---

## 📁 Estructura de Archivos de Tareas

```
tasks/
├── todo.md        ← Plan activo con checkboxes
├── lessons.md     ← Lecciones aprendidas de correcciones pasadas
└── decisions.md   ← Decisiones arquitectónicas importantes y su justificación
```

---

## 🔴 Manejo de Errores — Estándar Global

> Esta sección aplica a **todos los proyectos, lenguajes y capas** (frontend, backend, mobile, scripts).
> El agente debe aplicar este estándar de forma automática en todo código que genere o modifique.

---

### Regla Principal
- **Todo bloque de código que pueda fallar DEBE estar envuelto en try/catch.**
- Nunca dejar una llamada a API, operación de BD, lectura de archivo, o proceso externo sin manejo de error.
- El error siempre debe ser **capturado, identificado y registrado** — nunca ignorado silenciosamente.
- Un `catch` vacío o con solo un comentario `// TODO` está **prohibido**.

---

### Estructura del Mensaje de Error en Console

Todos los errores deben loguearse con el siguiente formato consistente para facilitar el debug:

```
[NIVEL] [CONTEXTO] [ORIGEN] → Mensaje descriptivo
Detalle: { datos relevantes }
Stack: (si aplica)
```

**Niveles:** `ERROR` · `WARN` · `INFO` · `DEBUG`

---

### 🟦 TypeScript / JavaScript / NestJS (Node.js)

```typescript
// Clase de error personalizada (crear en src/common/errors/)
export class AppError extends Error {
  constructor(
    public readonly context: string,
    public readonly message: string,
    public readonly detail?: unknown,
    public readonly originalError?: unknown
  ) {
    super(message);
    this.name = 'AppError';
  }
}

// Uso estándar en cualquier Service o función
async function obtenerDatos(id: number) {
  try {
    const resultado = await repositorio.findById(id);
    return resultado;
  } catch (error) {
    console.error(`[ERROR] [ServicioNombre] [obtenerDatos] → Falló al obtener registro con id=${id}`);
    console.error(`Detalle:`, { id, error });
    throw new AppError('ServicioNombre', `Error al obtener datos con id=${id}`, { id }, error);
  }
}

// En NestJS — ExceptionFilter global (src/common/filters/http-exception.filter.ts)
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status = exception instanceof HttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;

    const mensaje = exception instanceof HttpException
      ? exception.message
      : 'Error interno del servidor';

    console.error(`[ERROR] [GlobalFilter] [${request.method} ${request.url}] → ${mensaje}`);
    console.error(`Detalle:`, { status, exception });

    response.status(status).json({
      statusCode: status,
      message: mensaje,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

---

### 🟣 .NET / C# (Backend)

```csharp
// Clase de error personalizada
public class AppException : Exception
{
    public string Contexto { get; }
    public object? Detalle { get; }

    public AppException(string contexto, string mensaje, object? detalle = null, Exception? inner = null)
        : base(mensaje, inner)
    {
        Contexto = contexto;
        Detalle = detalle;
    }
}

// Uso estándar en cualquier servicio
public async Task<ResultadoDto> ObtenerDatosAsync(int id)
{
    try
    {
        var resultado = await _repositorio.ObtenerPorIdAsync(id);
        return resultado;
    }
    catch (Exception ex)
    {
        Console.Error.WriteLine($"[ERROR] [ServicioNombre] [ObtenerDatosAsync] → Falló al obtener id={id}");
        Console.Error.WriteLine($"Detalle: id={id} | Mensaje: {ex.Message}");
        Console.Error.WriteLine($"Stack: {ex.StackTrace}");
        throw new AppException("ServicioNombre", $"Error al obtener datos con id={id}", new { id }, ex);
    }
}

// Middleware global de errores (Program.cs o Startup.cs)
app.UseExceptionHandler(appError =>
{
    appError.Run(async context =>
    {
        var error = context.Features.Get<IExceptionHandlerFeature>();
        if (error != null)
        {
            Console.Error.WriteLine($"[ERROR] [GlobalMiddleware] [{context.Request.Method} {context.Request.Path}] → {error.Error.Message}");
            Console.Error.WriteLine($"Stack: {error.Error.StackTrace}");

            context.Response.StatusCode = 500;
            context.Response.ContentType = "application/json";
            await context.Response.WriteAsJsonAsync(new
            {
                statusCode = 500,
                message = "Error interno del servidor",
                timestamp = DateTime.UtcNow
            });
        }
    });
});
```

---

### 🟠 Kotlin / Android

```kotlin
// Extensión utilitaria para manejo de errores (util/ErrorHandler.kt)
fun logError(contexto: String, origen: String, mensaje: String, detalle: Any? = null, error: Throwable? = null) {
    Log.e(contexto, "[ERROR] [$contexto] [$origen] → $mensaje")
    detalle?.let { Log.e(contexto, "Detalle: $it") }
    error?.let { Log.e(contexto, "Stack: ${it.stackTraceToString()}") }
}

// Uso estándar en ViewModel o Repositorio
suspend fun obtenerDatos(id: Int): Result<DatoDto> {
    return try {
        val resultado = api.obtenerPorId(id)
        Result.success(resultado)
    } catch (e: Exception) {
        logError(
            contexto = "ServicioNombre",
            origen = "obtenerDatos",
            mensaje = "Falló al obtener datos con id=$id",
            detalle = mapOf("id" to id),
            error = e
        )
        Result.failure(e)
    }
}

// En viewModelScope — manejo centralizado
viewModelScope.launch {
    try {
        val datos = repositorio.obtenerDatos(id)
        _uiState.value = UiState.Success(datos)
    } catch (e: Exception) {
        logError("ViewModel", "cargarDatos", "Error al cargar datos", error = e)
        _uiState.value = UiState.Error("Error al cargar datos. Intenta de nuevo.")
    }
}
```

---

### 🐍 Python / Odoo (Módulos)

```python
import logging

# Siempre usar el logger de Odoo — nunca print()
_logger = logging.getLogger(__name__)

def procesar_datos(self, registro_id):
    try:
        registro = self.env['modelo.nombre'].browse(registro_id)
        # lógica de negocio
        return registro
    except ValidationError as e:
        _logger.error(
            "[ERROR] [NombreModulo] [procesar_datos] → Error de validación para id=%s | %s",
            registro_id, str(e)
        )
        raise
    except Exception as e:
        _logger.error(
            "[ERROR] [NombreModulo] [procesar_datos] → Error inesperado para id=%s",
            registro_id, exc_info=True
        )
        raise UserError(f"Error al procesar el registro {registro_id}: {str(e)}")
```

---

### 🌐 Frontend (JavaScript / TypeScript — React, HTML vanilla)

```typescript
// Utilitario global (src/utils/errorHandler.ts)
export function logError(contexto: string, origen: string, mensaje: string, detalle?: unknown) {
  console.error(`[ERROR] [${contexto}] [${origen}] → ${mensaje}`);
  if (detalle) console.error('Detalle:', detalle);
}

// Llamadas a API siempre con try/catch
async function fetchDatos(id: number) {
  try {
    const response = await fetch(`/api/v1/recurso/${id}`);
    if (!response.ok) throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    return await response.json();
  } catch (error) {
    logError('NombreServicio', 'fetchDatos', `Falló al obtener recurso id=${id}`, { id, error });
    throw error;
  }
}

// Error Boundary global en React (src/components/ErrorBoundary.tsx)
class ErrorBoundary extends React.Component<{ children: React.ReactNode }, { hasError: boolean }> {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    console.error('[ERROR] [ErrorBoundary] [componentDidCatch] → Error no capturado en render');
    console.error('Detalle:', { error: error.message, stack: error.stack, componentStack: info.componentStack });
  }

  render() {
    if (this.state.hasError) {
      return <div>Ocurrió un error inesperado. Por favor recarga la página.</div>;
    }
    return this.props.children;
  }
}
```

---

### 🗄️ SQL / Procedimientos Oracle y PostgreSQL

```sql
-- Oracle: bloque de manejo de errores estándar
BEGIN
  -- lógica principal
  INSERT INTO tabla (col1, col2) VALUES (val1, val2);
  COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('[ERROR] [PRC_NOMBRE] → Registro duplicado: ' || SQLERRM);
    ROLLBACK;
    RAISE;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[ERROR] [PRC_NOMBRE] → Error inesperado: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Código: ' || SQLCODE);
    ROLLBACK;
    RAISE;
END;

-- PostgreSQL: bloque de manejo de errores estándar
DO $$
BEGIN
  -- lógica principal
  INSERT INTO tabla (col1, col2) VALUES (val1, val2);
EXCEPTION
  WHEN unique_violation THEN
    RAISE WARNING '[ERROR] [bloque_nombre] → Registro duplicado: %', SQLERRM;
    RAISE;
  WHEN OTHERS THEN
    RAISE EXCEPTION '[ERROR] [bloque_nombre] → Error inesperado: %', SQLERRM;
END;
$$;
```

---

### Resumen de Reglas de Error

| Regla | ✅ Correcto | ❌ Prohibido |
|-------|-----------|------------|
| Captura | `catch (error)` tipado | `catch {}` vacío |
| Log | `console.error(...)` con contexto | `console.log(error)` sin info |
| Relanzar | `throw new AppError(...)` | Tragarse el error en silencio |
| Mensajes | Descriptivos con contexto | `"Error"` o `"Algo salió mal"` |
| Producción | Logger estructurado | `console.log` en código productivo |

---

## ⚠️ Lo que el Agente NUNCA debe hacer

- **Escribir código sin try/catch** en operaciones que puedan fallar.
- **Dejar un `catch` vacío** o con solo un comentario sin loguear ni relanzar el error.
- **Usar `console.log` para errores** — siempre `console.error` con contexto completo.
- **Tragarse excepciones silenciosamente** sin registro ni notificación.

- **Ignorar o saltarse cualquier regla definida en este archivo** — sin excepción.
- **Actuar por suposición** cuando este archivo ya define el comportamiento esperado.
- **Reinterpretar una regla** porque "en general se hace diferente" — aquí manda este archivo.
- Asumir que una tarea está lista sin haberla probado.
- Introducir dependencias nuevas sin mencionarlo explícitamente.
- Cambiar el esquema de base de datos sin advertencia previa.
- Responder en inglés si el usuario escribió en español.
- Hacer "parches rápidos" sin entender la causa raíz.
- Omitir manejo de errores en llamadas a servicios externos.
- Hardcodear valores que deberían venir de configuración.