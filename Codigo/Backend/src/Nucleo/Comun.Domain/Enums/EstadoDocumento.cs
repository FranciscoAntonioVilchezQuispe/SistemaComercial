namespace Nucleo.Comun.Domain.Enums
{
    /// <summary>
    /// Estados de un Documento Comercial (Compra, Nota de Crédito, Nota de Débito) (Tabla General 15)
    /// </summary>
    public enum EstadoDocumento : long
    {
        Registrado = 60,
        AnuladoDirecto = 61,
        Rechazado = 62,
        Pendiente = 63,
        AnuladoNotaCredito = 64,
        AnuladoNotaDebito = 65,
        Completado = 66
    }
}
