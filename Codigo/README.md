# 🛒 Sistema Comercial

Sistema de gestión comercial integral y modular diseñado para administrar ventas (POS), compras, inventario, facturación, catálogos y configuración multi-sucursal bajo una arquitectura robusta de microservicios. Cumple con normativa SUNAT UBL 2.1 y está optimizado para el mercado peruano.

## 🏷 Badges
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-0.10.0-blue)
![.NET](https://img.shields.io/badge/.NET-8.0-512BD4)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791)
![React](https://img.shields.io/badge/React-18.3-61DAFB)
![License](https://img.shields.io/badge/license-Propietario-red)

## 🛠 Stack Tecnológico

| Componente | Lenguaje / Herramienta | Versión |
| :--- | :--- | :--- |
| **Backend** | C# / .NET | 8.0 |
| **ORM Escritura** | Entity Framework Core | 8.x |
| **ORM Lectura** | Dapper | 2.x |
| **Frontend** | TypeScript / React | 18.3.1 |
| **Framework CSS** | Tailwind CSS / Radix UI | 3.4.7 |
| **Bundler Frontend** | Vite | 5.4.0 |
| **Base de Datos** | PostgreSQL | 14+ |
| **Containerización** | Docker / Docker Compose | 3.8 |
| **Gestores Estado** | Zustand / TanStack Query | 5.x / 5.x |
| **Validación Backend** | FluentValidation | 11.x |
| **Validación Frontend** | Zod | 3.x |
| **Animaciones** | Framer Motion | 11.x |
| **Iconografía** | Lucide React | 0.4x |
| **Migraciones EF** | dotnet-ef CLI | 10.x |

## 📋 Requisitos Previos

- [.NET SDK 8.0](https://dotnet.microsoft.com/download/dotnet/8.0) o superior
- [Node.js](https://nodejs.org/) v18+ (o TypeScript compatible)
- [PostgreSQL 14+](https://www.postgresql.org/) o [Docker Desktop](https://www.docker.com/) para levantar la base de datos contenerizada
- PowerShell (para ejecución de scripts de despliegue local)
- [EF Core CLI](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) (`dotnet tool install --global dotnet-ef`)

## ⚙️ Configuración del Entorno

1. Clona el repositorio a tu máquina local:
```bash
git clone [URL_DEL_REPOSITORIO]
cd SistemaComercial/Codigo
```

2. Configura la conexión a la base de datos en `appsettings.json` de cada microservicio:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Port=5432;Database=sistema_comercial;User Id=postgres;Password=TU_PASSWORD;"
  }
}
```

3. Levanta la Base de Datos usando Docker Compose:
```bash
docker-compose up -d postgres-db
```

4. Ejecuta los scripts de inicialización en orden:
```bash
# Desde BaseDeDatos/Scripts/
psql -U postgres -d sistema_comercial -f 01_esquema_completo.sql
psql -U postgres -d sistema_comercial -f 02_datos_maestros.sql
# ... hasta el script 13
```

5. Aplica las migraciones de EF Core en cada microservicio:
```powershell
.\apply_migrations.ps1
```

6. Instala las dependencias del frontend:
```bash
cd Frontend
npm install
```

## 🚀 Cómo correr el proyecto

### Modo Rápido (Todos los microservicios + Frontend)
Desde la raíz (`Codigo`), ejecuta el script de PowerShell:
```powershell
.\start_services.ps1
```
*(Lanzará cada microservicio de la solución y la SPA en ventanas separadas mediante `dotnet run --no-build`)*

### Desarrollo Manual

**Para el Backend:**
Navega a la carpeta del microservicio (ej. `Catalogo`) y corre la API:
```bash
cd Backend\src\Catalogo.API\Catalogo.API
dotnet run
```

**Para el Frontend:**
```bash
cd Frontend
npm run dev
```

### Producción (Build)
**Frontend:**
```bash
cd Frontend
npm run build
```

**Backend (Docker Compose):**
```bash
docker-compose up -d
```

## 📁 Estructura del Proyecto

```text
SistemaComercial/
├── Codigo/
│   ├── Backend/                    # Código fuente de los microservicios
│   │   ├── SistemaComercial.sln    # Solución .NET principal
│   │   ├── src/                    # Clean Architecture por Dominio
│   │   │   ├── Catalogo.API/       # Productos, marcas, unidades de medida
│   │   │   │   ├── Catalogo.API/           # Capa API (Controllers)
│   │   │   │   ├── Catalogo.Application/   # Casos de uso (CQRS/MediatR)
│   │   │   │   ├── Catalogo.Domain/        # Entidades y DTOs de dominio
│   │   │   │   └── Catalogo.Infrastructure/# Repositorios (EF Core + Dapper)
│   │   │   ├── Clientes.API/       # Gestión de clientes y contactos
│   │   │   ├── Compras.API/        # Órdenes de compra y proveedores
│   │   │   ├── Configuracion.API/  # Tablas maestras, impuestos, series,
│   │   │   │                       # métodos de pago, ubigeos, empresa
│   │   │   ├── Contabilidad.API/   # Asientos y reportes contables
│   │   │   ├── Gateway.API/        # API Gateway central (proxy reverso)
│   │   │   ├── Identidad.API/      # Autenticación y autorización (JWT)
│   │   │   ├── Inventario.API/     # Stock, almacenes, movimientos, kardex
│   │   │   ├── Ventas.API/         # POS, facturas, boletas, notas, pagos
│   │   │   ├── Nucleo/             # Librería compartida (EntidadBase, Enums,
│   │   │   │                       # PagedRequest/Response, utilidades)
│   │   │   └── Tools/              # Herramientas auxiliares (SqlRunner)
│   │   └── scripts/                # Scripts utilitarios del backend
│   │
│   ├── BaseDeDatos/                # Scripts SQL organizados por orden
│   │   └── Scripts/
│   │       ├── 01_esquema_completo.sql     # DDL completo (todos los esquemas)
│   │       ├── 02_datos_maestros.sql       # Seed data inicial
│   │       ├── 03_vistas_sistema.sql       # Vistas y materialized views
│   │       ├── 04_sincronizacion_ef.sql    # Sync EF Core con esquema físico
│   │       ├── 05_carga_ubigeos.sql        # 2115 registros de ubigeos Perú
│   │       ├── 06-13_*.sql                 # Scripts incrementales
│   │       ├── SCRIPTS_GUIDE.md            # Guía de ejecución de scripts
│   │       └── archive/                    # Scripts históricos
│   │
│   ├── Frontend/                   # SPA React + TypeScript + Vite
│   │   └── src/
│   │       ├── features/           # Módulos por dominio:
│   │       │   ├── catalogo/       #   Productos, marcas, precios
│   │       │   ├── clientes/       #   Directorio de clientes
│   │       │   ├── compras/        #   Órdenes y recepción
│   │       │   ├── configuracion/  #   Maestros del sistema
│   │       │   ├── dashboard/      #   Panel principal
│   │       │   ├── identidad/      #   Login y permisos
│   │       │   ├── inventario/     #   Stock y kardex
│   │       │   └── ventas/         #   POS y facturación
│   │       ├── compartido/         # Componentes, hooks, enums compartidos
│   │       ├── componentes/        # Componentes base (Radix UI wrappers)
│   │       ├── configuracion/      # Router, rutas, configuración de la app
│   │       └── config/             # Menú, rutas, constantes globales
│   │
│   ├── LogErrores/                 # Logs de errores del sistema
│   ├── docker-compose.yml          # PostgreSQL contenerizado
│   ├── start_services.ps1          # Lanzador de todos los servicios
│   ├── apply_migrations.ps1        # Aplicador de migraciones EF Core
│   └── export_all_migrations.ps1   # Exportador de scripts SQL desde EF
│
└── tasks/                          # Seguimiento del proyecto
    ├── todo.md                     # Lista de tareas (completadas/pendientes)
    ├── lessons.md                  # Lecciones aprendidas por sesión
    └── decisions.md                # Decisiones arquitectónicas (ADRs)
```

## 🗄️ Esquemas de Base de Datos

El sistema utiliza esquemas separados por dominio en una única base de datos PostgreSQL:

| Esquema | Propósito | Microservicio Dueño |
| :--- | :--- | :--- |
| `configuracion` | Tablas maestras globales (empresa, impuestos, series, métodos de pago, ubigeos, tipos de comprobante) | Configuracion.API |
| `catalogo` | Productos, marcas, categorías, unidades de medida, listas de precios | Catalogo.API |
| `clientes` | Clientes, contactos, direcciones | Clientes.API |
| `compras` | Órdenes de compra, detalles, proveedores | Compras.API |
| `ventas` | Ventas, detalles, pagos, cotizaciones, notas de crédito/débito, cajas | Ventas.API |
| `inventario` | Stock, almacenes, movimientos, kardex valorizado | Inventario.API |
| `contabilidad` | Asientos contables, plan de cuentas | Contabilidad.API |
| `seguridad` | Usuarios, roles, permisos, sesiones | Identidad.API |

> **Regla**: Las tablas de catálogo compartido (métodos de pago, tipos de comprobante) viven exclusivamente en `configuracion`. Otros microservicios las referencian con `ExcludeFromMigrations()`.

## 🏛 Arquitectura y Decisiones Técnicas

### Backend
- **Arquitectura Híbrida EF Core + Dapper:**
  Uso de **EF Core** para la capa de persistencia de escritura (Migraciones, Insert, Update, Delete) y **Dapper** para la capa de lectura (Queries complejas, Reportes, Paginación con `COUNT(*) OVER()`). Esta separación garantiza el máximo rendimiento en consultas masivas sin perder la potencia de modelado del ORM.
- **Microservicios y Clean Architecture:**
  Cada módulo se aloja en su propia solución segregada con capas `API`, `Application`, `Domain` e `Infrastructure`.
- **Normalización UTC:**
  Todos los DbContexts usan `ConfigureConventions` con `ValueConverter` para normalizar automáticamente `DateTimeKind.Utc` en todas las propiedades `DateTime`.
- **Enums Centralizados:**
  Estados de dominio (`EstadoVenta`, `EstadoPago`, `TipoMovimiento`) definidos como Enums tipados en `Nucleo.Comun.Domain`, sincronizados con los IDs de `Tablas Generales` en la base de datos.
- **Validación con FluentValidation:**
  Todos los DTOs y Commands usan `AbstractValidator<T>`. Data Annotations prohibidas para lógica de negocio.
- **Estandarización de Paginación:**
  Todas las APIs de listado utilizan `PagedRequest` / `PagedResponse<T>`, delegando la carga computacional (`LIMIT/OFFSET`) al motor PostgreSQL.

### Frontend
- **Modular por Features:**
  Cada dominio (`ventas`, `compras`, `catalogo`, etc.) es un módulo independiente con sus propias páginas, hooks, servicios y tipos.
- **React Query (TanStack Query):**
  Sincronización automática del estado del servidor con caché inteligente e invalidación.
- **UI Premium:**
  Uso mandatorio de Lucide Icons, animaciones de Framer Motion y componentes base de Radix UI.
- **Tipado Estricto:**
  Validación con Zod en formularios, enums sincronizados con backend en `src/compartido/enums`.

## 🇵🇪 Cumplimiento Normativo (SUNAT)

- **IGV no hardcodeado**: Se lee siempre desde la tabla `configuracion.impuestos`.
- **Validación de RUC**: Algoritmo de dígito verificador implementado en FluentValidation.
- **Códigos UBL 2.1 Catálogo 51**: Exactamente 4 caracteres, sin abreviar.
- **Series de comprobantes**: Formato oficial (F001, B001, FC01, FD01).
- **Ubigeos**: 2115 registros de Perú (departamentos, provincias, distritos) con jerarquía recursiva.
- **Zona horaria**: `America/Lima` (UTC-5) normalizada a UTC en persistencia.

## 🖥 Pantallas / Vistas Principales

| Pantalla/Módulo | Ruta | Descripción |
| :--- | :--- | :--- |
| **Dashboard** | `/dashboard` | Panel principal e indicadores |
| **Punto de Venta POS** | `/ventas/pos` | Interfaz rápida para facturación y cajeros |
| **Ventas Lista** | `/ventas/lista` | Listado de boletas, facturas, notas |
| **Cotizaciones** | `/ventas/cotizaciones` | Gestión de proformas y cotizaciones |
| **Gestión Inventario** | `/inventario/*` | Stock, movimientos, kardex y almacenes |
| **Catálogo** | `/catalogo/*` | Productos, marcas, listas de precios, unidades |
| **Compras** | `/compras/*` | Control de ingresos y requerimientos por proveedor |
| **Configuración** | `/configuracion/*` | Empresa, sucursales, impuestos, series, métodos de pago, ubigeos |
| **Clientes** | `/clientes` | Directorio de compradores |

## ⚙️ Variables de Entorno y Configuración

Variables leídas desde `appsettings.json` de cada microservicio:

| Clave | Descripción | Obligatorio |
| :--- | :--- | :--- |
| `ConnectionStrings:DefaultConnection` | Cadena conexión a PostgreSQL | Sí |
| `FrontendUrl` | Origen permitido CORS (ej: `http://localhost:5180`) | Sí |
| `Logging:LogLevel` | Nivel de detalle de logs | No |

## 📜 Estándares de Desarrollo

### Backend (.NET)
1. **Arquitectura Híbrida:** EF Core para escrituras y Dapper para lecturas de alto rendimiento.
2. **Paginación Global:** `PagedRequest` obligatorio en controladores; `COUNT(*) OVER()` en queries Dapper (un solo round-trip).
3. **DTOs Tipados:** Prohibido usar `QueryAsync<dynamic>` con Dapper. Siempre DTO plano con `DefaultTypeMap.MatchNamesWithUnderscores = true`.
4. **Conexión Dapper:** No disponer (`using`) la conexión obtenida de `_context.Database.GetDbConnection()`.
5. **Idempotencia SQL:** Todo script debe incluir `ON CONFLICT DO NOTHING` / `IF NOT EXISTS`.
6. **Validación:** FluentValidation (`AbstractValidator<T>`) — Data Annotations prohibidas.
7. **Logging:** Serilog con `InnerException` capturada vía middleware global.
8. **Separación Lista/Detalle:** El endpoint de lista solo devuelve columnas visibles en el grid + `id`.

### Frontend (React/TS)
1. **Estructura por Features:** `src/features/{dominio}/{paginas,hooks,servicios,tipos}`.
2. **Caché y Estado:** TanStack Query para datos del servidor; Zustand para estado local.
3. **Enums Sincronizados:** IDs numéricos en `src/compartido/enums` idénticos a los del backend.
4. **UI Dinámica:** Lucide Icons + Framer Motion + Radix UI.
5. **Validación:** Esquemas Zod sincronizados con tipos TypeScript.

## 🤝 Cómo Contribuir

1. Crear Feature Branch (`git checkout -b feature/CaracteristicaIncreible`).
2. Seguir convención de Commits Semánticos (`feat:`, `fix:`, `docs:`, `chore:`).
3. Asegurar calidad base:
   - Backend: `dotnet build SistemaComercial.sln` sin errores.
   - Frontend: `npx tsc --noEmit` sin errores.
4. Push a rama remota y abrir Pull Request con detalle del cambio.

## ❓ FAQ / Problemas Comunes

1. **Error `42P01: no existe la relación`:**
   *Causa:* Las migraciones de EF Core no han sido aplicadas o el nombre de tabla difiere del mapeo.
   *Solución:* Ejecutar `dotnet ef database update` en el microservicio correspondiente. Verificar que `OnModelCreating` tenga mapeos `.ToTable()` explícitos.

2. **Error de Conexión a Base de Datos (Connection Refused):**
   *Causa:* El contenedor PostgreSQL no fue iniciado.
   *Solución:* `docker-compose up -d postgres-db`. Verificar password en `appsettings.json`.

3. **Error de Puertos Ocupados (EADDRINUSE):**
   *Causa:* Procesos .NET previos quedaron en memoria.
   *Solución:* `taskkill /IM "dotnet.exe" /F` o reiniciar terminal.

4. **CORS Bloqueado en Frontend:**
   *Causa:* Vite expuso la GUI en un puerto distinto al configurado.
   *Solución:* Verificar que `FrontendUrl` en `appsettings.json` coincida con el puerto de `npm run dev`.

5. **Error `DateTimeKind.Unspecified` de Npgsql:**
   *Causa:* El DbContext no tiene los ValueConverters de UTC configurados.
   *Solución:* Agregar `ConfigureConventions` con `DateTimeToUtcConverter` en el DbContext.

## 📜 Licencia

Propietario - Todos los derechos reservados
