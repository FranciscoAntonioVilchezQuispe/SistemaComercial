import { create } from "zustand";
import { Producto } from "@features/catalogo";
import { ItemCarrito, Carrito } from "../tipos/ventas.types";
import { calcularTotalesVenta } from "@compartido/utilidades/calculos";

interface EstadoCarrito extends Carrito {
  subtotalGravado: number;
  subtotalExonerado: number;
  subtotalInafecto: number;
  totalGratuito: number;
  agregarProducto: (
    producto: Producto,
    cantidad: number,
    descuento?: number,
  ) => void;
  actualizarCantidad: (idProducto: number, cantidad: number) => void;
  actualizarDescuento: (idProducto: number, descuento: number) => void;
  eliminarProducto: (idProducto: number) => void;
  limpiarCarrito: () => void;
  obtenerCantidadItems: () => number;
}

const calcularTotales = (items: ItemCarrito[]): Omit<Carrito, "items"> => {
  const itemsParaCalculo = items.map((item) => ({
    precio: item.precioUnitario,
    cantidad: item.cantidad,
    porcentajeDescuento: item.descuento,
    codigoAfectacion: item.producto.idTipoAfectacionIgv === 2 ? "20" : 
                     item.producto.idTipoAfectacionIgv === 3 ? "30" : "10", // Fallback básico si no hay fetch de maestros
  }));


  const totales = calcularTotalesVenta(itemsParaCalculo);

  return {
    subtotal: totales.subtotal,
    subtotalGravado: totales.subtotalGravado,
    subtotalExonerado: totales.subtotalExonerado,
    subtotalInafecto: totales.subtotalInafecto,
    totalGratuito: totales.totalGratuito,
    descuento: totales.descuento,
    igv: totales.igv,
    total: totales.total,
  };
};

export const useCarrito = create<EstadoCarrito>((set, get) => ({
  items: [],
  subtotal: 0,
  subtotalGravado: 0,
  subtotalExonerado: 0,
  subtotalInafecto: 0,
  totalGratuito: 0,
  descuento: 0,
  igv: 0,
  total: 0,

  agregarProducto: (producto, cantidad, descuento = 0) => {
    const items = get().items;
    const itemExistente = items.find(
      (item) => item.producto.id === producto.id,
    );

    let nuevosItems: ItemCarrito[];

    if (itemExistente) {
      // Actualizar cantidad si ya existe
      nuevosItems = items.map((item) =>
        item.producto.id === producto.id
          ? {
              ...item,
              cantidad: item.cantidad + cantidad,
              subtotal:
                (item.cantidad + cantidad) *
                item.precioUnitario *
                (1 - item.descuento / 100),
            }
          : item,
      );
    } else {
      // Agregar nuevo item
      const nuevoItem: ItemCarrito = {
        producto,
        cantidad,
        precioUnitario: producto.precioVentaPublico,
        descuento,
        subtotal:
          cantidad * producto.precioVentaPublico * (1 - descuento / 100),
      };
      nuevosItems = [...items, nuevoItem];
    }

    const totales = calcularTotales(nuevosItems);
    set({ items: nuevosItems, ...totales });
  },

  actualizarCantidad: (idProducto, cantidad) => {
    const items = get().items;

    if (cantidad <= 0) {
      get().eliminarProducto(idProducto);
      return;
    }

    const nuevosItems = items.map((item) =>
      item.producto.id === idProducto
        ? {
            ...item,
            cantidad,
            subtotal:
              cantidad * item.precioUnitario * (1 - item.descuento / 100),
          }
        : item,
    );

    const totales = calcularTotales(nuevosItems);
    set({ items: nuevosItems, ...totales });
  },

  actualizarDescuento: (idProducto, descuento) => {
    const items = get().items;
    const nuevosItems = items.map((item) =>
      item.producto.id === idProducto
        ? {
            ...item,
            descuento,
            subtotal:
              item.cantidad * item.precioUnitario * (1 - descuento / 100),
          }
        : item,
    );

    const totales = calcularTotales(nuevosItems);
    set({ items: nuevosItems, ...totales });
  },

  eliminarProducto: (idProducto) => {
    const items = get().items;
    const nuevosItems = items.filter((item) => item.producto.id !== idProducto);
    const totales = calcularTotales(nuevosItems);
    set({ items: nuevosItems, ...totales });
  },

  limpiarCarrito: () => {
    set({
      items: [],
      subtotal: 0,
      subtotalGravado: 0,
      subtotalExonerado: 0,
      subtotalInafecto: 0,
      totalGratuito: 0,
      descuento: 0,
      igv: 0,
      total: 0,
    });
  },

  obtenerCantidadItems: () => {
    return get().items.reduce((total, item) => total + item.cantidad, 0);
  },
}));
