# CLAUDE.md — Reglas para Claude Code
> Fuente de verdad para el comportamiento de Claude Code en todos los proyectos.
> Adaptado desde GEMINI.md para las capacidades específicas de Claude Code CLI.

---

## 🚨 Autoridad de Este Archivo

- Claude Code **debe leer este archivo completo al inicio de cada sesión**.
- Este archivo tiene **prioridad sobre cualquier suposición interna** del modelo.
- Si existe un archivo de reglas específico del proyecto (ej: `PROYECTO.md`), ese archivo **complementa** estas reglas — nunca las reemplaza.
- Ante cualquier duda, **consultar primero este archivo** antes de tomar una decisión.
- Si se detecta un caso no cubierto, **preguntar al usuario** en lugar de asumir.
- **Prohibido ignorar, omitir o reinterpretar** cualquier regla bajo pretexto de eficiencia.

---

## 🌐 Idioma

- **TODAS las explicaciones, comentarios de código, mensajes de error, logs y respuestas deben estar en español.**
- El código en sí puede usar inglés (variables, funciones, clases) — estándar técnico.
- Documentación generada (README, comentarios XML, docstrings) → español.

---

## 📋 Orquestación del Flujo de Trabajo

### 1. Modo Plan por Defecto
- Entrar en modo plan para CUALQUIER tarea no trivial (3+ pasos o decisiones arquitectónicas).
- Si algo sale mal, DETENTE y replantea — no avanzar a ciegas.
- Escribir especificaciones detalladas desde el principio para reducir ambigüedad.

### 2. Estrategia de Subagentes
- Usar subagentes (`Task`) para mantener limpia la ventana de contexto principal.
- Delegar investigación, exploración y análisis paralelo a subagentes.
- Una tarea por subagente para ejecución enfocada.
- Usar `Task` para operaciones verbosas como ejecución de tests y lectura de logs.

### 3. Gestión del Contexto
- Cuando la conversación se alarga, usar `/compact` para resumir y liberar contexto.
- Limpiar contexto al cambiar de tarea para mantener rendimiento.
- Claude Code empieza a degradarse al ~50% del context window — actuar antes de llegar ahí.

### 4. Bucle de Automejora
- Después de CUALQUIER corrección del usuario: actualizar `tasks/lessons.md` con el patrón aprendido.
- Escribir reglas que prevengan el mismo error en el futuro.
- Revisar las lecciones al inicio de cada sesión del proyecto relevante.

### 5. Verificación Antes de Terminar
- Nunca marcar una tarea como completa sin demostrar que funciona.
- Preguntarse: *"¿Un ingeniero senior aprobaría esto?"*
- Ejecutar pruebas, revisar logs, demostrar corrección.

### 6. Exigir Elegancia (Balanceada)
- Para cambios no triviales: pausar y preguntar *"¿hay una forma más elegante?"*
- Omitir esto para correcciones simples y obvias — no sobrediseñar.

### 7. Corrección Autónoma de Bugs
- Cuando se reporte un bug: simplemente corregirlo. No pedir que te guíen.
- Apuntar a logs, errores y pruebas fallidas — luego resolverlos.

---

## 🧠 Capa de Habilidades (Skills / Domain Memory)

> Conocimiento profundo de dominios específicos del negocio y patrones técnicos complejos.

- **Ubicación:** Todos los archivos de dominio residen en `.antigravity/skills/*.skill`.
- **Uso Obligatorio:** Buscar y leer el archivo `.skill` relevante antes de proponer cambios en módulos críticos (Compras, Ventas, SUNAT).
- **Mantenimiento:** Si se descubre un patrón de negocio nuevo o se cambia una regla de dominio, actualizar el `.skill` correspondiente inmediatamente.
- **Prioridad de Consulta:** `CLAUDE.md` (Reglas Globales) → `.antigravity/skills/*.skill` (Reglas de Dominio) → `tasks/lessons.md` (Correcciones Puntuales).

### Skills Disponibles

| Skill | Archivo | Cuándo Consultar |
|-------|---------|-----------------|
| `db-purchase-workflow` | `.antigravity/skills/db-purchase-workflow.skill` | Diseño de BD, estados duales, unicidad condicional, soft-delete, anulación, EF Core + Dapper |
| `frontend-documentos` | `.antigravity/skills/frontend-documentos.skill` | Grids de documentos, badges de estado, modales de anulación, formularios, errores 409, campos deshabilitados |

---

## 🧱 Principios Fundamentales

- **Simplicidad Primero:** Cada cambio tan simple como sea posible. Impacto mínimo de código.
- **Sin Pereza:** Encontrar las causas raíz. Sin soluciones temporales. Estándares de desarrollador senior.
- **Impacto Mínimo:** Los cambios solo deben tocar lo necesario. Evitar bugs colaterales.

---

## 🛠️ Stack Técnico del Proyecto

| Capa | Tecnología |
|------|-----------|
| Backend .NET | .NET · PostgreSQL · Entity Framework Core · Dapper |
| Backend Node | Node.js · TypeScript · NestJS · Oracle DB |
| Frontend | React · TypeScript · Vite · Radix UI · Tailwind CSS · TanStack Query · Zustand · Redux Toolkit |
| Mobile | Android / Kotlin · Odoo 19 JSON-RPC |
| ERP | Odoo 19 (módulos Python) |
| BD GUI | DBeaver |
| Mercado | Perú (SUNAT · RENIEC · ONP) |

### Mapa de Microservicios

| Microservicio | Responsabilidad |
|---|---|
| **Ventas.API** | Cotizaciones, Ventas, Notas de Crédito/Débito, Cajas |
| **Compras.API** | Proveedores, Órdenes de Compra, Compras |
| **Inventario.API** | Stock, Almacenes, Movimientos, Kardex |
| **Catalogo.API** | Productos, Categorías, Marcas, Precios |
| **Clientes.API** | Clientes y Contactos |
| **Configuracion.API** | Series, Tipos de Comprobante, Impuestos, Parámetros Globales |

---

## 🇵🇪 Reglas de Dominio Peruano (SUNAT)

- **IGV nunca hardcodeado** — siempre desde constantes globales, configuración o BD.
  - Backend .NET: `Nucleo.Comun.Domain.Constants.FiscalConstants.PORCENTAJE_IGV`
  - Frontend: `src/compartido/configuracion/fiscal.config.ts` (`FISCAL_CONFIG.PORCENTAJE_IGV`)
  - Fallback: `18.00m` marcado como pendiente de configuración.
  - BD: Configurado en `configuracion.impuestos` (ID 1000).
- **Validar RUC** con algoritmo de dígito verificador antes de cualquier llamada a API externa y en `AbstractValidator`. Longitud exacta: 11 dígitos.
- **Validar DNI**: exactamente 8 dígitos, solo numéricos.
- **Códigos UBL 2.1 Catálogo 51** son de exactamente 4 caracteres — no abreviar ni alterar.
- **Fechas y horas** siempre en zona horaria `America/Lima` (UTC-5).
  - Backend: Prohibido `DateTime.UtcNow` o `DateTime.Now` directo. Usar `DateTimeHelper.ObtenerAhoraLima()`.
  - Frontend: Prohibido `new Date()` o `.toISOString()` directo. Usar utilidades de `@/lib/datetime` y componente `DatePicker` unificado (protegido por ESLint).
- **Series de comprobantes**: `F001` (Factura), `B001` (Boleta), `FC01` (NC Factura), `FD01` (ND Factura).
- **Cálculos en Backend**: Subtotales, IGV y Totales se calculan SIEMPRE en el backend. El frontend solo muestra.
- **Moneda**: Soles (PEN) salvo indicación multimoneda explícita.
- **Comprobantes electrónicos**: Validación de schema UBL 2.1 antes de enviar a SUNAT.
- **Regla de Anulación**:
  - < 24h: Anulación Directa (`id_estado = 61`)
  - \> 24h o Factura: Requiere Nota de Crédito (`id_estado = 64`)
- **Notas de Crédito/Débito**: Cálculos SIEMPRE en backend. Validar monto NC ≤ saldo de venta referenciada. El cliente se obtiene de la venta, no del DTO del frontend. Hash estándar: `hash_cdr`.

---

## 🗄️ Arquitectura Híbrida EF Core + Dapper

- **EF Core** → solo para escrituras (INSERT, UPDATE, DELETE) y migraciones de esquema.
- **Dapper** → para lecturas, consultas complejas y reportes.
- **Nunca mezclar** ambos dentro del mismo método o transacción.

### Migraciones y Configuración
- **Migraciones Nucleares**: Usar bloques `DO $$ ... END $$` (PostgreSQL) para buscar y eliminar PKs/FKs dinámicamente.
- **Historial Aislado**: `MigrationsHistoryTable("__ef_migrations_history", "esquema")` para evitar colisiones multiesquema.
- **Normalización UTC**: `ConfigureConventions` con `ValueConverter<DateTime, DateTime>` para `DateTimeKind.Utc` global.
- **Auditoría Global**: Prohibido asignar manualmente campos de auditoría en Handlers si la entidad hereda de `AuditableEntity`. Usar:
  ```csharp
  _auditHelper.CargarAuditoria(ChangeTracker, _usuarioActualService.ObtenerUsuarioId());
  ```
- Migraciones deben ser **reversibles** — toda migración destructiva requiere script de rollback.

### Reglas de Consultas con Dapper

**Gestión de la Conexión:**
- **Nunca usar `using`** con la conexión del DbContext — disponer rompe la conexión que EF administra.
- Obtener y abrir solo si está cerrada:
  ```csharp
  var connection = _context.Database.GetDbConnection();
  if (connection.State != ConnectionState.Open)
      await connection.OpenAsync();
  ```

**Paginación Eficiente:**
- **Nunca dos queries separadas** (datos + count) — usar `COUNT(*) OVER()`:
  ```sql
  SELECT v.id_venta, v.serie, COUNT(*) OVER() AS total
  FROM ventas.ventas v
  ORDER BY v.fecha_emision DESC
  LIMIT @pageSize OFFSET @offset;
  ```
- Offset: `var offset = (pageNumber - 1) * pageSize;`
- Total: `var total = rows.FirstOrDefault()?.Total ?? 0;`

**Mapeo Tipado:**
- **Prohibido `QueryAsync<dynamic>`** — siempre DTO tipado plano.
- Habilitar snake_case → PascalCase una sola vez en Program.cs:
  ```csharp
  DefaultTypeMap.MatchNamesWithUnderscores = true;
  ```

**Separación de Responsabilidades:**
- El repositorio solo devuelve DTOs planos — no construir entidades de dominio.
- La conversión DTO → objeto de dominio/respuesta ocurre en la capa de aplicación (Service o Handler).

### Lo que NUNCA hacer con Dapper
- Usar `QueryAsync<dynamic>` y mapear manualmente.
- Ejecutar dos queries cuando `COUNT(*) OVER()` resuelve ambas.
- Disponer (`using`) la conexión del DbContext.
- Construir entidades de dominio con objetos anidados dentro del repositorio.
- Omitir `DefaultTypeMap.MatchNamesWithUnderscores = true`.

---

## 🗃️ Gestión de Estados (Tablas Generales)

Esquema `configuracion`, tabla `tablas_generales_detalle`.

### Estados de Documento/Compra (Tabla 15)
| ID | Estado | Excluido de Unicidad |
|----|--------|---------------------|
| 60 | Registrado | No |
| 61 | Anulado Directo | ✅ Sí |
| 62 | Rechazado | No |
| 63 | Pendiente | No |
| 64 | Anulado Nota Crédito | ✅ Sí |
| 65 | Anulado Nota Débito | ✅ Sí |
| 66 | Completado | No |

### Estados de Venta (Tabla 8)
| ID | Estado |
|----|--------|
| 29 | Completada |
| 30 | Anulada |
| 31 | Pendiente de Pago |

### Estados de Pago (Tabla 13)
| ID | Estado |
|----|--------|
| 46 | Pagado |
| 47 | Parcial |
| 48 | Crédito |
| 49 | Pendiente |
| 50 | Anulado |

### Estados de Orden de Compra
| ID | Estado |
|----|--------|
| 39 | Borrador |
| 40 | Pendiente |
| 41 | Aprobada |
| 42 | Rechazada |
| 100 | Facturada |

### Patrón Dual de Estados
- `activado` (boolean) → soft delete. `false` = registro eliminado lógicamente.
- `id_estado` (FK) → ciclo de vida del documento de negocio.
- Son conceptos DISTINTOS. Un documento anulado (`id_estado = 61`) sigue con `activado = true`.

---

## ✅ Validaciones — Backend .NET / C# (FluentValidation)

> Solo aplica a proyectos que ya tengan FluentValidation en el `.csproj`.

- **NUNCA usar Data Annotations** (`[Required]`, `[MaxLength]`, etc.) para validar lógica de negocio si FluentValidation está presente.
- **SIEMPRE crear `AbstractValidator<T>`** por cada DTO, Command o Request que reciba datos del usuario.
- Validadores en la misma carpeta que su DTO/Command o en subcarpeta `Validators/`.
- Registro en DI: `builder.Services.AddValidatorsFromAssemblyContaining<Program>();`
- No duplicar validaciones: el validador cubre formato/presencia; el dominio cubre reglas complejas.

### Validaciones de Dominio Peruano
```csharp
// RUC
RuleFor(x => x.Ruc)
    .NotEmpty().WithMessage("El RUC es obligatorio.")
    .Length(11).WithMessage("El RUC debe tener exactamente 11 dígitos.")
    .Must(ValidarDigitoVerificadorRuc).WithMessage("El RUC no es válido.");

// DNI
RuleFor(x => x.Dni)
    .NotEmpty().WithMessage("El DNI es obligatorio.")
    .Length(8).WithMessage("El DNI debe tener exactamente 8 dígitos.")
    .Matches("^[0-9]+$").WithMessage("El DNI solo debe contener dígitos.");

// Serie de comprobante
RuleFor(x => x.Serie)
    .NotEmpty().WithMessage("La serie es obligatoria.")
    .Matches(@"^[FBCET][A-Z0-9]{3}$").WithMessage("Formato inválido (ej: F001, B001).");
```

### Unicidad Condicional
La restricción `(RUC + Tipo + Serie + Numero)` no bloquea si el anterior fue anulado:
```csharp
.AnyAsync(c => c.Proveedor.NumeroDocumento == ruc
            && c.SerieComprobante == serie
            && c.NumeroComprobante == numero
            && c.Activado
            && c.IdEstado != 61 && c.IdEstado != 64);
```

---

## 🌐 Diseño de Endpoints REST — Lista vs Detalle

| Llamada | Cuándo | Qué devuelve |
|---------|--------|-------------|
| `GET /recurso` (paginado) | Al cargar el grid | Solo columnas visibles + `id` |
| `GET /recurso/{id}` | Al abrir vista previa o editar | Todos los campos necesarios |

- **Prohibido devolver campos innecesarios** en el endpoint de lista.
- **Nunca incluir** campos de texto largo, colecciones ni objetos anidados en el DTO de lista.
- **Nunca reusar** datos del grid para prellenar formularios de edición — siempre segunda llamada `GET /recurso/{id}`.
- DTOs separados: `XxxListDto` para lista, `XxxDetalleDto` para detalle.

---

## 🐘 Reglas de Base de Datos (PostgreSQL)

- Índices `pg_trgm` solo en columnas de búsqueda textual — no masivamente.
- Operaciones masivas dentro de una transacción con estrategia table-swap atómica.
- Nunca `DROP` o `TRUNCATE` sin confirmación explícita.
- Naming: `idx_ruc_trgm`, `fk_cliente_tipo_doc`, etc.
- Schemas separados por dominio: `configuracion`, `ventas`, `compras`, `inventario`, `sunat`.

### Índices Únicos Condicionales (Partial Index)
```sql
-- PostgreSQL: excluir anulados/inactivos de la unicidad
CREATE UNIQUE INDEX uq_documento_serie_ruc
  ON documentos (numero_serie, ruc)
  WHERE activado = true AND id_estado NOT IN (61, 64, 65);
```

---

## 🟡 Reglas de Base de Datos (Oracle)

- Tipos correctos: `VARCHAR2` (no VARCHAR), `NUMBER` (no INT).
- **Nunca `SELECT *`** — especificar columnas.
- CTEs (`WITH ... AS`) para consultas complejas — evitar subconsultas profundas.
- Prefijos: `SEQ_` (secuencias), `TRG_` (triggers), `IDX_` (índices), `SP_`/`PRC_` (procedimientos).
- Paginación con `OFFSET / FETCH NEXT` (Oracle 12c+).
- Bind variables siempre — nunca concatenar valores (prevención SQL injection).
- Transacciones con `COMMIT`/`ROLLBACK` explícito.

---

## 🟢 Reglas de Node.js / TypeScript / NestJS

### TypeScript
- `strict: true` en `tsconfig.json`. Prohibido `any` salvo justificación explícita.
- Preferir `interface` sobre `type` para contratos de objetos.
- Exportar tipos desde `*.types.ts` o `*.interface.ts`.
- Async/await siempre — no callbacks ni `.then()` encadenados.

### NestJS
- Estructura de módulos estándar: `module.ts`, `controller.ts`, `service.ts`, `dto/`, `entities/`.
- DTOs con `class-validator` + `class-transformer` en todos los endpoints.
- Lógica de negocio en el **Service** — Controllers solo orquestan.
- Guards para autenticación, Interceptors para transformación, Pipes para validación.
- Configuración con `@nestjs/config` y `.env` — nunca `process.env.X` directo en código de negocio.
- ExceptionFilter global para manejo de excepciones — no lanzar errores HTTP desde el Service.
- Documentar con Swagger: `@ApiTags`, `@ApiOperation`, `@ApiResponse`.

### NestJS + Oracle
- TypeORM con driver `oracledb`. DataSource en `database.module.ts`.
- Nombres de tablas/columnas en MAYÚSCULAS — configurar `namingStrategy` o mapear explícitamente.
- Secuencias: `@PrimaryGeneratedColumn({ sequenceName: 'SEQ_TABLA' })`.
- Repositorios personalizados — no inyectar EntityManager directo en el Service.

### Buenas Prácticas Node.js
- Variables de entorno validadas al inicio con Joi o Zod.
- Logging estructurado con Winston o Pino — no `console.log` en producción.
- Versionar endpoints: `/api/v1/recurso`.
- Respuestas con estructura consistente: `{ "data": ..., "message": "...", "statusCode": 200 }`
- Cierre graceful del servidor (`SIGTERM`, `SIGINT`).

---

## 📱 Reglas Mobile (Android / Kotlin)

- **No hardcodear colores** — usar tokens de tema: `?attr/colorSurface`, `?attr/colorOnSurface`.
- `forceDarkAllowed="false"` en todos los temas (compatibilidad EMUI).
- Llamadas a API Odoo en **Coroutines** (`viewModelScope`/`lifecycleScope`), nunca en hilo principal.
- **Material3** como sistema de diseño base.
- Booleanos de Odoo API → castear explícitamente, nunca renderizar como texto directo.

---

## 🔁 Reglas de Integración con Odoo 19

- Comunicación exclusivamente via **JSON-RPC** (`/web/dataset/call_kw`).
- Autenticación mediante sesión con `res.users` — no contraseñas en texto plano.
- Verificar versión del modelo Odoo antes de asumir campos disponibles.
- Campos `Many2one` retornan `[id, nombre]` — manejar ambos casos.
- **Extracción IA Multimodal**: Estrategia fallback: IA Vision → Notificación Confianza → Corrección Manual. Guardar JSON original de IA en campo de log antes de procesar.

---

## 🌐 Frontend — React + TypeScript

### Stack del Frontend
- UI: Radix UI + Tailwind CSS + CVA para variantes
- Estado servidor: `@tanstack/react-query`
- Formularios: `react-hook-form` + `zod`
- HTTP: Axios con interceptores centralizados (Gateway `localhost:5000/api`)
- Notificaciones: `sonner` (toast)
- Íconos: `lucide-react`
- Estado global: Zustand + Redux Toolkit
- Routing: `react-router-dom` v6

### Badges de Estado por Tipo de Documento

**Documentos de Venta/Compra:**
| `id_estado` | Enum | Color |
|-------------|------|-------|
| 66 Completado | `bg-green-100 text-green-700 border-green-200` | 🟢 Verde |
| 63 Pendiente | `bg-amber-100 text-amber-700 border-amber-200` | 🟡 Ámbar |
| 60 Registrado | `bg-blue-50 text-blue-700 border-blue-200` | 🔵 Azul |
| 61 AnuladoDirecto | `bg-red-100 text-red-700 border-red-200` | 🔴 Rojo |
| 64 AnuladoNC | `bg-orange-100 text-orange-700 border-orange-200` | 🟠 Naranja |
| 65 AnuladoND | `bg-purple-100 text-purple-700 border-purple-200` | 🟣 Púrpura |
| 62 Rechazado | `bg-gray-100 text-gray-700 border-gray-200` | ⚪ Gris |

**Estados de Pago:**
| `id_estado_pago` | Color |
|-------------------|-------|
| 46 Pagado | `bg-emerald-50 text-emerald-700 border-emerald-200` |
| 49 Pendiente | `bg-orange-50 text-orange-700 border-orange-200` |
| 47 Parcial | `bg-blue-50 text-blue-700 border-blue-200` |
| 48 Crédito | `bg-purple-50 text-purple-700 border-purple-200` |
| 50 Anulado | `bg-red-50 text-red-700 border-red-200` |

### Acciones por Estado
- Documento activo (no anulado): Vista Previa · Imprimir · Emitir Nota · Anular
- Documento anulado (61, 64, 65): **Solo** Vista Previa · Imprimir
- Documento anulado = TODO el formulario en modo `readOnly`

### Manejo de Errores del Frontend
- **Capa 1**: Interceptor Axios (global) → `capturadorErrores.capturar()`
- **Capa 2**: `manejadorErrores` (por hook/mutation) → errores por código HTTP
- **Capa 3**: `capturadorErrores` (logging estructurado, singleton, hasta 50 logs en sessionStorage)
- **Capa 4**: ErrorBoundary → errores de renderizado React

### Respuesta Paginada
```typescript
interface PagedResponse<T> {
  datos: T[];
  total: number;
  pageNumber: number;
  pageSize: number;
  totalPages: number;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
  status: number;
  message: string;
  transactionId: string;
}
```
- Acceso: siempre `response.datos?.map(...)` — nunca `response.map(...)`.

---

## 🔒 Seguridad y Cumplimiento

- **Credenciales nunca en código fuente** — variables de entorno, `local.properties` o Android Keystore.
- Claves API de terceros (SUNAT, RENIEC, apis.net.pe) en configuración externa, nunca commiteadas.
- Datos de RUC/DNI son datos personales — no loguearlos en producción.
- Toda comunicación con servicios externos: **HTTPS**.

---

## 🔴 Manejo de Errores — Estándar Global

### Formato Consistente de Log
```
[NIVEL] [CONTEXTO] [ORIGEN] → Mensaje descriptivo
Detalle: { datos relevantes }
Stack: (si aplica)
```

### Reglas
- Todo bloque que pueda fallar → `try/catch`.
- `catch` vacío o con solo `// TODO` → **prohibido**.
- Siempre capturar, identificar y registrar — nunca ignorar silenciosamente.

### Por Lenguaje

**C# (.NET):** Usar `AppException` con contexto y detalle. Middleware global en `Program.cs`.
**TypeScript/NestJS:** Usar `AppError` con contexto. `GlobalExceptionFilter` como `@Catch()`.
**Kotlin/Android:** Usar `logError(contexto, origen, mensaje, detalle?, error?)`. Manejo en `viewModelScope`.
**Python/Odoo:** Usar `_logger = logging.getLogger(__name__)` — nunca `print()`. `ValidationError` vs `UserError`.
**Frontend React:** Usar `capturadorErrores.capturar()`. ErrorBoundary para errores de render.

### Tabla Resumen
| Regla | ✅ Correcto | ❌ Prohibido |
|-------|-----------|------------|
| Captura | `catch (error)` tipado | `catch {}` vacío |
| Log | `console.error(...)` con contexto | `console.log(error)` sin info |
| Relanzar | `throw new AppError(...)` | Tragarse el error |
| Mensajes | Descriptivos con contexto | `"Error"` o `"Algo salió mal"` |
| Producción | Logger estructurado | `console.log` en código productivo |

---

## ✅ Gestión de Tareas

1. **Plan Primero:** Escribir el plan en `tasks/todo.md` con ítems verificables.
2. **Verificar Plan:** Confirmar antes de comenzar la implementación.
3. **Seguir Progreso:** Marcar ítems como completos.
4. **Explicar Cambios:** Resumen de alto nivel en cada paso, en español.
5. **Documentar Resultados:** Sección de revisión en `tasks/todo.md`.
6. **Capturar Lecciones:** Actualizar `tasks/lessons.md` después de correcciones.

---

## 📁 Gestión de tasks/ — REGLA ABSOLUTA

> El agente NO puede considerar ninguna tarea terminada sin seguir este protocolo.

### NUNCA SOBREESCRIBIR
- Todos los archivos de `tasks/` son **acumulativos** y crecen con el tiempo.
- `todo.md`: NUNCA borrar ítems completados — marcar `[x]` y dejar. Agregar nuevas tareas AL FINAL bajo encabezado de sesión.
- `lessons.md`: NUNCA borrar lecciones anteriores. Agregar al final con fecha.
- `decisions.md`: NUNCA modificar decisiones pasadas. Si cambian, agregar nueva entrada que referencie la anterior.
- `historial/`: NUNCA editar archivos de sesiones pasadas.

### Estructura
```
tasks/
├── todo.md          ← plan activo con checkboxes (acumulativo)
├── lessons.md       ← errores pasados y cómo evitarlos (acumulativo)
├── decisions.md     ← decisiones arquitectónicas (acumulativo)
└── historial/
    ├── YYYY-MM-DD_descripcion-breve.md
    └── index.md
```

### Al INICIAR sesión
1. Leer `tasks/todo.md` completo.
2. Leer `tasks/lessons.md` completo.
3. Leer `tasks/historial/index.md`.
4. Agregar plan de nueva sesión AL FINAL de `tasks/todo.md`.
5. Confirmar plan con el usuario.

### Al COMPLETAR tarea
1. Marcar `[x]` en `tasks/todo.md`.
2. Crear/actualizar entrada en `tasks/historial/YYYY-MM-DD_descripcion.md`.
3. Actualizar `tasks/historial/index.md`.

### Al recibir CORRECCIÓN
Agregar inmediatamente en `tasks/lessons.md`:
```markdown
---
## [YYYY-MM-DD] — [contexto]
**Error cometido:** descripción exacta
**Causa raíz:** por qué ocurrió
**Regla para el futuro:** instrucción concreta en imperativo
**Archivos afectados:** lista
**Proyecto:** nombre del microservicio
```

### Al tomar DECISIÓN arquitectónica
Registrar en `tasks/decisions.md` ANTES de implementar:
```markdown
---
## [YYYY-MM-DD] — [título]
**Decisión tomada:** qué se eligió
**Alternativas descartadas:** qué se evaluó
**Razón:** justificación técnica/negocio
**Impacto:** qué partes afecta
```

---

## 🚫 Comandos Personalizados (Slash Commands)

> Crear en `.claude/commands/` como archivos `.md`.

### Comandos Sugeridos
| Comando | Archivo | Descripción |
|---------|---------|-------------|
| `/revisar-pr` | `revisar-pr.md` | Revisa el PR enfocándose en seguridad y convenciones SUNAT |
| `/generar-migration` | `generar-migration.md` | Genera migración con patrón activado/id_estado |
| `/sunat-validar` | `sunat-validar.md` | Valida cumplimiento UBL 2.1 y normativa SUNAT |
| `/nuevo-endpoint` | `nuevo-endpoint.md` | Crea endpoint con DTOs lista/detalle, validador y repositorio |

---

## ⚠️ Lo que el Agente NUNCA debe hacer

- Escribir código sin try/catch en operaciones que puedan fallar.
- Dejar un `catch` vacío.
- Usar `console.log` para errores — siempre `console.error` con contexto.
- Tragarse excepciones silenciosamente.
- Ignorar o saltarse cualquier regla de este archivo.
- Actuar por suposición cuando este archivo define el comportamiento esperado.
- Asumir que una tarea está lista sin haberla probado.
- Introducir dependencias nuevas sin mencionarlo explícitamente.
- Cambiar el esquema de BD sin advertencia previa.
- Responder en inglés si el usuario escribió en español.
- Hacer "parches rápidos" sin entender la causa raíz.
- Omitir manejo de errores en llamadas a servicios externos.
- Hardcodear valores que deberían venir de configuración.
- Devolver todos los campos en el endpoint de lista "por si acaso".
- Reutilizar datos del grid para prellenar formularios.
- Crear un único DTO gigante para lista y detalle.
- Borrar o reducir el contenido de archivos en `tasks/`.

---

## 🤝 Colaboración con Antigravity (Agent Manager)

> Claude Code y Antigravity trabajan como equipo en el mismo proyecto.

### Flujo Recomendado
1. **Claude Code (terminal)**: Planificación, análisis de arquitectura, diseño técnico.
2. **Antigravity (Agent Manager)**: Ejecución paralela de implementación con múltiples agentes.
3. **Claude Code (terminal)**: Revisión de código, seguridad, consistencia, Git.

### Archivos Compartidos
- `CLAUDE.md` — leído por Claude Code al inicio de cada sesión.
- `GEMINI.md` / `AGENTS.md` — leído por Antigravity/agentes de Gemini.
- `.antigravity/skills/*.skill` — consultados por ambos según el dominio.
- `tasks/` — compartido, acumulativo, append-only.

### Regla de No Conflicto
- Ambas herramientas respetan las convenciones de `tasks/` (append-only).
- Si Claude Code detecta que Antigravity hizo cambios sin documentar, registrar en `tasks/lessons.md`.
- Los archivos `.skill` son la fuente de verdad de dominio para ambas herramientas.
