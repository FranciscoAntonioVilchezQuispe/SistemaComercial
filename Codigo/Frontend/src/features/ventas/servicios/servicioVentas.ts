import { apiVentas } from "@/lib/axios";
import {
  Venta,
  VentaFormData,
  VentaFiltros,
} from "../tipos/ventas.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/ventas";

export const servicioVentas = {
  obtenerVentas: async (
    params?: PagedRequest,
  ): Promise<PagedResponse<Venta>> => {
    const response: any = await apiVentas.get(BASE_URL, { params });
    // Handle both cases: response.datos or the response itself being the PagedResponse
    return response.datos ? response : (response.data || response);
  },

  obtenerVentaPorId: async (id: number): Promise<Venta> => {
    const response: any = await apiVentas.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crearVenta: async (datos: VentaFormData): Promise<Venta> => {
    const response: any = await apiVentas.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  anularVenta: async (id: number, motivo: string): Promise<Venta> => {
    const response: any = await apiVentas.patch(`${BASE_URL}/${id}/anular`, {
      motivo,
    });
    return response.datos || response.data;
  },

  obtenerVentasDelDia: async (): Promise<Venta[]> => {
    const response: any = await apiVentas.get(`${BASE_URL}/hoy`);
    return response.datos || response.data;
  },

  obtenerEstadisticas: async (fechaInicio: string, fechaFin: string) => {
    const response: any = await apiVentas.get(`${BASE_URL}/estadisticas`, {
      params: { fechaInicio, fechaFin },
    });
    return response.datos || response.data;
  },

  obtenerSeries: async (
    idTipoComprobante: number,
    idAlmacen?: number,
  ): Promise<any[]> => {
    const response: any = await apiVentas.get(`${BASE_URL}/series`, {
      params: { idTipoComprobante, idAlmacen },
    });
    return response.datos || response.data || [];
  },

  obtenerCotizaciones: async (
    params?: PagedRequest,
  ): Promise<PagedResponse<any>> => {
    const response: any = await apiVentas.get("/cotizaciones", { params });
    return response.datos ? response : (response.data || response);
  },
};
