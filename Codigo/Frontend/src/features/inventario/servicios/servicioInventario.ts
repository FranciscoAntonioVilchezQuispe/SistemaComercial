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
    return response.datos || response;
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
    return response.datos || response;
  },

  /**
   * Realiza un ajuste de stock directo
   */
  ajustarStock: async (ajuste: AjusteStockDTO) => {
    const response: any = await apiInventario.post(
      `${API_URL}/stock/ajuste`,
      ajuste,
    );
    return response.datos || response;
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
    return response.datos || response;
  },

  /**
   * Obtiene los tipos de movimientos configurados
   */
  obtenerTiposMovimiento: async () => {
    const response: any = await apiInventario.get(
      `${API_URL}/tipos-movimiento`,
    );
    return response.datos || response;
  },

  /**
   * Obtiene la lista de almacenes disponibles
   */
  obtenerAlmacenes: async () => {
    const response: any = await apiInventario.get(`${API_URL}/almacenes`);
    return response.datos || response;
  },

  /**
   * Ejecuta la sincronización masiva de compras y ventas históricas
   */
  sincronizarHistorico: async (reiniciar: boolean = true) => {
    const response: any = await apiInventario.post(
      `${API_URL}/movimientos/sincronizar-compras?reiniciar=${reiniciar}`,
    );
    return response.mensaje || response;
  },
};
