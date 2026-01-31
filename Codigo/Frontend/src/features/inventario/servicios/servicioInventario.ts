import { apiInventario } from "@/lib/axios";
import {
  RegistroMovimientoDTO,
  AjusteStockDTO,
  InventarioFiltros,
  MovimientoFiltros,
} from "../tipos/inventario.types";

const API_URL = "/inventario";

export const servicioInventario = {
  /**
   * Obtiene el stock actual de productos
   */
  obtenerStock: async (filtros: InventarioFiltros = {}) => {
    const response: any = await apiInventario.get(`${API_URL}/stock`, {
      params: filtros,
    });
    return response; // Contiene datos y total
  },

  /**
   * Obtiene el stock de un producto específico por almacenes
   */
  obtenerStockPorProducto: async (idProducto: number) => {
    const response: any = await apiInventario.get(
      `${API_URL}/stock/producto/${idProducto}`,
    );
    return response.data;
  },

  /**
   * Obtiene el historial de movimientos de inventario
   */
  obtenerMovimientos: async (
    filtros: MovimientoFiltros = {},
    pagina: number = 1,
    limite: number = 10,
  ) => {
    const response: any = await apiInventario.get(`${API_URL}/movimientos`, {
      params: { ...filtros, pagina, limite },
    });
    return response; // Contiene datos y total
  },

  /**
   * Registra un nuevo movimiento de inventario (Entrada/Salida)
   */
  registrarMovimiento: async (movimiento: RegistroMovimientoDTO) => {
    const response: any = await apiInventario.post(
      `${API_URL}/movimientos`,
      movimiento,
    );
    return response.data;
  },

  /**
   * Realiza un ajuste de stock directo
   */
  ajustarStock: async (ajuste: AjusteStockDTO) => {
    const response: any = await apiInventario.post(
      `${API_URL}/stock/ajuste`,
      ajuste,
    );
    return response.data;
  },

  /**
   * Obtiene el Kardex de un producto en un rango de fechas
   */
  obtenerKardex: async (
    idProducto: number,
    idAlmacen: number,
    fechaInicio: string,
    fechaFin: string,
  ) => {
    const response: any = await apiInventario.get(
      `${API_URL}/kardex/${idProducto}`,
      {
        params: { idAlmacen, fechaInicio, fechaFin },
      },
    );
    return response.data;
  },

  /**
   * Obtiene los tipos de movimientos configurados
   */
  obtenerTiposMovimiento: async () => {
    const response: any = await apiInventario.get(
      `${API_URL}/catalogos/tipos-movimiento`,
    );
    return response.data;
  },

  /**
   * Obtiene la lista de almacenes disponibles
   */
  obtenerAlmacenes: async () => {
    const response: any = await apiInventario.get(
      `${API_URL}/catalogos/almacenes`,
    );
    return response.data;
  },
};
