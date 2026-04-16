# Historial de SesiÃ³n: EstandarizaciÃ³n Global y AuditorÃ­a
**Fecha:** 2026-04-13

## Objetivo
Realizar una auditorÃ­a completa y refactorizaciÃ³n del proyecto (Backend + Frontend) para eliminar valores hardcodeados, centralizar constantes de negocio y unificar la lÃ³gica de auditorÃ­a de base de datos.

## Cambios Realizados

### Backend (.NET)
- **CentralizaciÃ³n Fiscal**: Se creÃ³ `FiscalConstants.cs` en `Nucleo.Comun.Domain` con `PORCENTAJE_IGV = 18.00m` y cÃ³digos tributarios SUNAT.
- **AuditorÃ­a Centralizada**: Se implementÃ³ `DbContextAuditHelper.cs` para unificar el registro de metadatos (Usuario, Fecha, Estado) en `SaveChangesAsync`.
- **RefactorizaciÃ³n de DbContexts**: Actualizados todos los contextos de datos para usar el helper de auditorÃ­a, garantizando el uso de `DateTimeHelper.ObtenerAhoraLima()`.
- **Limpieza de UtcNow**: Se eliminaron mÃ¡s de 25 asignaciones manuales de `DateTime.UtcNow` en Endpoints y Repositorios para evitar inconsistencias horarias.

### Frontend (React/TS)
- **ConfiguraciÃ³n Fiscal**: Se creÃ³ `src/compartido/configuracion/fiscal.config.ts`.
- **Variables de Entorno**: Se implementÃ³ soporte para `.env` y `.env.development`.
- **Red**: Refactorizado `axios.ts` para utilizar `VITE_API_URL`.
- **RefactorizaciÃ³n de UI**: Se actualizaron formularios de productos, compras y el POS para consumir el IGV desde la configuraciÃ³n centralizada.

## Resultados y VerificaciÃ³n
- [x] El IGV ahora es configurable en un solo punto por capa.
- [x] Todas las transacciones de base de datos registran automÃ¡ticamente la hora de Lima (UTC-5).
- [x] El frontend ya no tiene URLs hardcodeadas hacia el backend.
- [x] La soluciÃ³n compila correctamente tras la refactorizaciÃ³n masiva de DbContexts.

## Lecciones Aprendidas
- La auditorÃ­a distribuida en Endpoints genera inconsistencias rÃ¡pidamente; la centralizaciÃ³n en el `DbContext` es el patrÃ³n mÃ¡s resiliente.
- El uso de `import.meta.env` de Vite es superior a las constantes hardcodeadas para la gestiÃ³n de infraestructuras hÃ­bridas.
