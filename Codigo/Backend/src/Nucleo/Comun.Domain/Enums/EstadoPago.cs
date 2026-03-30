namespace Nucleo.Comun.Domain.Enums
{
    /// <summary>
    /// Estados de Pago de una Venta (Tabla General 13)
    /// </summary>
    public enum EstadoPago : long
    {
        Pagado = 46,
        Parcial = 47,
        Credito = 48,
        Pendiente = 49,
        Anulado = 50
    }
}
