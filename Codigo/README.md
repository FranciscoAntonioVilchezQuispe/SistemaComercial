# 🛒 Sistema Comercial

Sistema de gestión comercial integral y modular diseñado para administrar ventas (POS), compras, inventario, facturación, catálogos y configuración multi-sucursal bajo una arquitectura robusta de microservicios.

## 🏷 Badges
![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-0.1.0-blue)
![License](https://img.shields.io/badge/license-Propietario-red)

## 🛠 Stack Tecnológico

| Componente | Lenguaje / Herramienta | Versión |
| :--- | :--- | :--- |
| **Backend** | C# / .NET | 8.0 |
| **Frontend** | TypeScript / React | 18.3.1 |
| **Framework CSS** | Tailwind CSS / Radix UI | 3.4.7 |
| **Bundler Frontend**| Vite | 5.4.0 |
| **Base de Datos** | PostgreSQL | 14 |
| **Containerización**| Docker / Docker Compose | 3.8 |
| **Gestores Estado** | Zustand / Redux Toolkit | 5.0.10 / 2.2.7 |

## 📋 Requisitos Previos

- [.NET SDK 8.0](https://dotnet.microsoft.com/download/dotnet/8.0) o superior
- [Node.js](https://nodejs.org/) v18+ (o TypeScript compatible)
- [PostgreSQL 14+](https://www.postgresql.org/) o [Docker Desktop](https://www.docker.com/) para levantar la base de datos contenerizada
- PowerShell (para ejecución de scripts de despliegue local)

## ⚙️ Configuración del Entorno

1. Clona el repositorio a tu máquina local:
```bash
git clone [URL_DEL_REPOSITORIO]
cd SistemaComercial/Codigo
```

2. Configura las variables en el base de datos desde `appsettings.json` o usa Docker:
Asegúrate de configurar los credenciales correctas en `Backend\src\[Microservicio]\appsettings.json`.

3. Levanta la Base de Datos usando Docker Compose:
```bash
docker-compose up -d postgres-db
```

4. Instala las dependencias del frontend:
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
Puedes construir e iniciar las imágenes configuradas:
```bash
docker-compose up -d
```

## 📁 Estructura del Proyecto

```text
├── Backend/        # Código fuente de los microservicios e infraestructura
│   └── src/        # Solución .NET (Clean Architecture x Dominio)
│       ├── Catalogo.API/       # Microservicio de catálogo
│       ├── Clientes.API/       # Microservicio de clientes
│       ├── Compras.API/        # Microservicio de compras
│       ├── Configuracion.API/  # Microservicio de configuraciones generales
│       ├── Contabilidad.API/   # Microservicio de contabilidad
│       ├── Gateway.API/        # API Gateway unificador central
│       ├── Identidad.API/      # Microservicio de autorización e identidad
│       ├── Inventario.API/     # Microservicio de stock y almacén
│       ├── Ventas.API/         # Microservicio de ventas (POS) y facturación
│       └── Nucleo/             # Librería de Kernel / Core compartida
├── BaseDeDatos/    # Scripts y recursos de la BD
├── Frontend/       # Single Page Application (React + Vite)
│   └── src/
│       ├── features/   # Módulos segregados (Catalogo, Ventas, Compras...)
│       ├── configuracion/ # Ruteador general de la App
│       ├── compartido/ # Componentes UI genéricos
│       └── componentes/# Componentes base interactivos (Radix UI)
├── docker-compose.yml  # Manifiesto para despliegue de base de datos e imágenes base
└── start_services.ps1  # Script automatizado de ejecución de todos los servicios locales
```

## 🏛 Arquitectura y Decisiones Técnicas

- **Backend basado en Microservicios y Clean Architecture:** 
  Cada módulo (Catálogo, Clientes, Ventas, etc.) se aloja en su propia solución segregada con sus capas en una Arquitectura Limpia/Hexagonal (`API`, `Application`, `Domain` e `Infrastructure`). Esto garantiza alto desacoplamiento.
- **Patrón CQRS y MediatR:**
  Implementación en C# usando `MediatR` para dividir claramente las operaciones de lectura (Queries) y modificación de datos (Commands).
- **Frontend modularizado mediante Lazy Loading:**
  Reducción masiva en la carga inicial de React a través de carga perezosa de rutas usando `lazy()` y `<Suspense>` por funcionalidad (Kardex, Dashboards, Catálogo, POS).
- **Agnóstico UI con Headless Components:**
  Uso de Radix UI combinado con Tailwind CSS para generar componentes estables, escalables y con accesibilidad priorizada, sin depender de un framework monolítico visual.

## 🖥 Pantallas / Vistas Principales (Frontend)

| Pantalla/Módulo | Ruta Relativa | Descripción General |
| :--- | :--- | :--- |
| **Dashboard** | `/dashboard` | Panel principal e indicadores |
| **Punto de Venta POS**| `/ventas/pos` | Interfaz rápida y ágil para facturación y cajeros |
| **Ventas Lista** | `/ventas/lista` | Listado general de boletas, facturas y transacciones |
| **Gestión Inventario** | `/inventario/*` | Control de stock, movimientos, kardex y almacenes |
| **Catálogo** | `/catalogo/*` | Mantenimiento de productos, marcas, listas de precios y unidades de medida |
| **Compras / Proveedores** | `/compras/*` | Control logístico de ingresos y requerimientos por proveedor |
| **Configuraciones Generales** | `/configuracion/*` | Matriz de datos de la empresa, sucursales e impuestos |
| **Directorio de Clientes** | `/clientes` | Mantenimiento y registro de compradores |

## ⚙️ Variables de Entorno y Configuración

Variables extraíbles y leídas desde los respectivos archivos de entorno (`appsettings.json` de cada microservicio):

| Nombre / Clave | Descripción | Obligatorio |
| :--- | :--- | :--- |
| `ConnectionStrings:DefaultConnection` | Cadena conexión a PostgreSQL por defecto | Sí |
| `FrontendUrl` | Origen permitido explícito (CORS) apuntando al web client local o productivo | Opcional |
| `Logging:LogLevel` | Jerarquía y detalle de los logs del microservicio | Opcional |

## 🧪 Cómo Correr los Tests

```bash
[COMANDOS PARA TESTS NO DISPONIBLES EN EL CÓDIGO ACTUAL]
```

## 🤝 Cómo Contribuir

1. Crea tu Feature Branch (`git checkout -b feature/CaracteristicaIncreible`).
2. Haz honor a la convención de Commits Semánticos (`feat:`, `fix:`, `docs:`, `chore:`).
3. Asegura y revisa la calidad base de tu código:
   - Compilación exitosa de componentes C# (`dotnet build`).
   - Sin errores ni warnings severos del Linter React (`npm run lint`).
4. Haz push de tus cambios a la rama remota correspondiente (`git push origin feature/CaracteristicaIncreible`).
5. Abre y solicita un Pull Request contra la rama de base/mainline con el detalle del cambio cubierto.

## ❓ FAQ / Problemas Comunes

1. **Error de Conexión a Base de Datos (Connection Refused):**
   *Causa común:* El contenedor PostgreSQL aún no fue iniciado.
   *Solución:* Corre `docker-compose up -d postgres-db` asegurándote de revisar la configuración de password definida en `appsettings.json`.

2. **Error de Puertos Ocupados (EADDRINUSE) al ejecutar el `start_services.ps1`:**
   *Causa común:* Procesos .NET de una prueba anterior quedaron almacenados en memoria ocupando los puertos de API expuestos (Ej. 5001, etc.).
   *Solución:* Eliminar/matar procesos dormidos ejecutando un `taskkill /IM "dotnet.exe" /F` o reiniciando la terminal.

3. **CORS Bloqueado en Frontend intentando acceder a la API:**
   *Causa común:* El proyecto de Vite expuso la GUI en un puerto secundario distinto pero predeterminado porque el por defecto (`:5180`) quedó trabado.
   *Solución:* Verifique que `FrontendUrl` en su `appsettings.json` de la API coincida plenamente con el endpoint que señala su terminal Vite (`http://localhost:[PUERTO]`).

## 📜 Licencia

Propietario - Todos los derechos reservados
