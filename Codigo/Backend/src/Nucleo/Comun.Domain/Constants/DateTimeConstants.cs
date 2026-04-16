namespace Nucleo.Comun.Domain.Constants
{
    public static class DateTimeConstants
    {
        // Timezone para Perú (No aplica Horario de Verano)
        // En Windows: "SA Pacific Standard Time"
        // En Linux: "America/Lima"
        public const string TIMEZONE_LIMA = "SA Pacific Standard Time";
        public const string TIMEZONE_LIMA_LINUX = "America/Lima";

        // Formatos de Fechas
        public const string FORMATO_FECHA_DB = "yyyy-MM-dd";
        public const string FORMATO_DATETIME_DB = "yyyy-MM-dd HH:mm:ss";
        public const string FORMATO_FECHA_PANTALLA = "dd/MM/yyyy";
        public const string FORMATO_DATETIME_PANTALLA = "dd/MM/yyyy HH:mm:ss";
        public const string FORMATO_HORA = "HH:mm:ss";
    }
}
