# Sistema Comercial (Retail & Mayorista)

Sistema de gestión comercial basado en Microservicios (.NET 8) y Frontend moderno (React).

## Estructura del Proyecto

- `Backend/`: Solución .NET con arquitectura limpia.
  - `src/Nucleo`: Núcleo compartido (DDD, EventBus).
  - `src/[Microservice].API`: APIs individuales (Catalogo, Ventas, etc.).
- `Frontend/`: Aplicación React + Vite.
- `Docker/`: Archivos de orquestación.

## Requisitos Previos

- .NET 8 SDK
- Node.js 18+
- Docker Desktop
- PostgreSQL 14+

## Cómo Iniciar (Desarrollo)

### 1. Generar Estructura

Ejecutar el script `scaffold.ps1` (ya ejecutado si ves las carpetas).

### 2. Base de Datos

Ejecutar el script `schema_full.sql` en tu instancia de PostgreSQL.

### 3. Backend

Navegar a cada microservicio y ejecutar:

```bash
cd Backend/src/Catalogo.API
dotnet run
```

### 4. Frontend

```bash
cd Frontend
npm install
npm run dev
```

## Convenciones (Importante)

- **Idioma:** Todo el código en Español.
- **Arquitectura:** Clean Architecture + CQRS.
- **Nomenclatura:** PascalCase para csharp, camelCase variables.
