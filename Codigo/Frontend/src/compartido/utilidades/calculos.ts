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
  subtotalGravado: number;
  subtotalExonerado: number;
  subtotalInafecto: number;
  totalGratuito: number;
  descuento: number;
  igv: number;
  total: number;
}

export const calcularTotalesVenta = (
  items: Array<{
    precio: number;
    cantidad: number;
    porcentajeDescuento?: number;
    codigoAfectacion?: string; // Nuevo: Código SUNAT (10, 20, 30, etc.)
  }>,
): TotalesVenta => {
  let grabada = 0;
  let exonerada = 0;
  let inafecta = 0;
  let gratuita = 0;
  let descuentoTotal = 0;
  let totalTotal = 0;

  const IGV_TASA = 0.18;

  items.forEach((item) => {
    const afectacion = item.codigoAfectacion || "10";
    const esGravado = afectacion.startsWith("1");
    const esExonerado = afectacion.startsWith("2");
    const esInafecto = afectacion.startsWith("3") || afectacion === "40";
    const esGratuito = [
      "11", "12", "13", "14", "15", "16", // Gravados grat.
      "21", // Exonerado grat.
      "31", "32", "33", "34", "35", "36" // Inafectos grat.
    ].includes(afectacion);

    const montoBruto = item.precio * item.cantidad;
    const montoDescuento = calcularDescuento(
      montoBruto,
      item.porcentajeDescuento || 0,
    );

    const montoNeto = montoBruto - montoDescuento;
    
    if (esGratuito) {
      gratuita += montoNeto;
    } else {
      totalTotal += montoNeto;
      descuentoTotal += montoDescuento;

      if (esGravado) {
        grabada += montoNeto;
      } else if (esExonerado) {
        exonerada += montoNeto;
      } else if (esInafecto) {
        inafecta += montoNeto;
      }
    }
  });

  // Desglose del IGV solo de la parte gravada
  // El precio en el sistema ya incluye el impuesto
  const baseImponible = grabada / (1 + IGV_TASA);
  const igv = grabada - baseImponible;

  return {
    subtotal: Number((baseImponible + exonerada + inafecta).toFixed(2)),
    subtotalGravado: Number(baseImponible.toFixed(2)),
    subtotalExonerado: Number(exonerada.toFixed(2)),
    subtotalInafecto: Number(inafecta.toFixed(2)),
    totalGratuito: Number(gratuita.toFixed(2)),
    descuento: Number(descuentoTotal.toFixed(2)),
    igv: Number(igv.toFixed(2)),
    total: Number(totalTotal.toFixed(2)),
  };
};

