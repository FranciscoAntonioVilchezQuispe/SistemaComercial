/**
 * Calcula el IGV (18%) de un monto
 */
export const calcularIGV = (monto: number): number => {
  const IGV_TASA = 0.18;
  return monto * IGV_TASA;
};

/**
 * Calcula el subtotal a partir de un total que incluye IGV
 */
export const calcularSubtotalDesdeTotal = (total: number): number => {
  const IGV_TASA = 0.18;
  return total / (1 + IGV_TASA);
};

/**
 * Calcula el descuento de un monto
 */
export const calcularDescuento = (
  monto: number,
  porcentajeDescuento: number,
): number => {
  return monto * (porcentajeDescuento / 100);
};

/**
 * Calcula el subtotal de un item (precio * cantidad - descuento)
 */
export const calcularSubtotal = (
  precio: number,
  cantidad: number,
  porcentajeDescuento: number = 0,
): number => {
  const subtotalSinDescuento = precio * cantidad;
  const descuento = calcularDescuento(
    subtotalSinDescuento,
    porcentajeDescuento,
  );
  return subtotalSinDescuento - descuento;
};

/**
 * Calcula el total de una venta (subtotal + IGV)
 */
export const calcularTotal = (subtotal: number): number => {
  const igv = calcularIGV(subtotal);
  return subtotal + igv;
};

/**
 * Calcula todos los totales de una venta
 */
export interface TotalesVenta {
  subtotal: number;
  descuento: number;
  igv: number;
  total: number;
}

export const calcularTotalesVenta = (
  items: Array<{
    precio: number;
    cantidad: number;
    porcentajeDescuento?: number;
  }>,
): TotalesVenta => {
  let subtotalTotal = 0;
  let descuentoTotal = 0;

  items.forEach((item) => {
    const subtotalItem = item.precio * item.cantidad;
    const descuentoItem = calcularDescuento(
      subtotalItem,
      item.porcentajeDescuento || 0,
    );

    subtotalTotal += subtotalItem - descuentoItem;
    descuentoTotal += descuentoItem;
  });

  const igv = calcularIGV(subtotalTotal);
  const total = subtotalTotal + igv;

  return {
    subtotal: subtotalTotal,
    descuento: descuentoTotal,
    igv,
    total,
  };
};
