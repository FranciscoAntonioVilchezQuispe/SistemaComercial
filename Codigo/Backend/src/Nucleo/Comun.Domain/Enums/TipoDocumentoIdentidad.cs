using System;

namespace Nucleo.Comun.Domain.Enums
{
    /// <summary>
    /// Identificadores primarios de la tabla configuracion.tipo_documento.
    /// Basado en el sembrado inicial del sistema.
    /// </summary>
    public enum TipoDocumentoIdentidad : long
    {
        SinDocumento = 1,      // Código SUNAT: 0
        DNI = 2,               // Código SUNAT: 1
        CarnetExtranjeria = 3, // Código SUNAT: 4
        RUC = 4,               // Código SUNAT: 6
        Pasaporte = 5,         // Código SUNAT: 7
        CedulaDiplomatica = 6  // Código SUNAT: A
    }
}
