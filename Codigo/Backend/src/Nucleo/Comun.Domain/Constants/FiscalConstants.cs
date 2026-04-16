namespace Nucleo.Comun.Domain.Constants
{
    public static class FiscalConstants
    {
        /// <summary>
        /// Porcentaje de IGV estándar en Perú (18.00%)
        /// </summary>
        public const decimal PORCENTAJE_IGV = 18.00m;

        /// <summary>
        /// Factor divisor para obtener la base imponible (1.18)
        /// </summary>
        public const decimal FACTOR_IGV = 1.18m;

        /// <summary>
        /// Símbolo de la moneda nacional (Soles)
        /// </summary>
        public const string MONEDA_NACIONAL_SIMBOLO = "S/";

        /// <summary>
        /// Código ISO de la moneda nacional (PEN)
        /// </summary>
        public const string MONEDA_NACIONAL_ISO = "PEN";

        /// <summary>
        /// Código de tributo para el IGV según Catálogo 05 de SUNAT
        /// </summary>
        public const string CODIGO_TRIBUTO_IGV = "1000";

        /// <summary>
        /// Nombre del tributo IGV según SUNAT
        /// </summary>
        public const string NOMBRE_TRIBUTO_IGV = "IGV";

        /// <summary>
        /// Código internacional del tributo IGV (VAT)
        /// </summary>
        public const string CODIGO_INTERNACIONAL_TRIBUTO_IGV = "VAT";
    }
}
