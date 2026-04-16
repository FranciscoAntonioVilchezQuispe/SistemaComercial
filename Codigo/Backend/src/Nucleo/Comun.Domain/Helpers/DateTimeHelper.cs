using System;
using System.Runtime.InteropServices;
using Nucleo.Comun.Domain.Constants;

namespace Nucleo.Comun.Domain.Helpers
{
    public static class DateTimeHelper
    {
        private static readonly TimeZoneInfo _peruTimeZone;

        static DateTimeHelper()
        {
            try
            {
                // Soporte cross-platform para zona horaria de Lima
                string tzId = RuntimeInformation.IsOSPlatform(OSPlatform.Windows) 
                    ? DateTimeConstants.TIMEZONE_LIMA 
                    : DateTimeConstants.TIMEZONE_LIMA_LINUX;

                _peruTimeZone = TimeZoneInfo.FindSystemTimeZoneById(tzId);
            }
            catch
            {
                // Fallback a offset fijo de -5 si falla la carga del sistema (poco probable pero seguro)
                _peruTimeZone = TimeZoneInfo.CreateCustomTimeZone("Lima-Fixed", TimeSpan.FromHours(-5), "Lima", "Lima");
            }
        }

        /// <summary>
        /// Obtiene la fecha y hora actual en la zona horaria de Lima (UTC-5).
        /// </summary>
        public static DateTime ObtenerAhoraLima()
        {
            return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, _peruTimeZone);
        }

        /// <summary>
        /// Obtiene solo la fecha actual de Lima (con hora 00:00:00).
        /// </summary>
        public static DateTime ObtenerFechaLima()
        {
            return ObtenerAhoraLima().Date;
        }

        /// <summary>
        /// Convierte un DateTime de Lima a UTC de forma segura para persistencia.
        /// </summary>
        public static DateTime AUtc(DateTime fechaLima)
        {
            if (fechaLima.Kind == DateTimeKind.Utc) return fechaLima;
            
            return TimeZoneInfo.ConvertTimeToUtc(fechaLima, _peruTimeZone);
        }

        /// <summary>
        /// Formatea una fecha para visualización en pantalla (dd/MM/yyyy).
        /// </summary>
        public static string FormatearParaPantalla(DateTime fecha)
        {
            return fecha.ToString(DateTimeConstants.FORMATO_FECHA_PANTALLA);
        }

        /// <summary>
        /// Formatea una fecha para base de datos (yyyy-MM-dd).
        /// </summary>
        public static string FormatearParaDB(DateTime fecha)
        {
            return fecha.ToString(DateTimeConstants.FORMATO_FECHA_DB);
        }
    }
}
