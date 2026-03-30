namespace Nucleo.Comun.Domain.Enums
{
    /// <summary>
    /// Tipos de Movimiento de Inventario (Tabla General 6)
    /// </summary>
    public enum TipoMovimientoInventario : long
    {
        IngresoCompra = 19,
        SalidaVenta = 20,
        AjustePositivo = 21,
        AjusteNegativo = 22,
        TransferenciaAlmacen = 23
    }
}
