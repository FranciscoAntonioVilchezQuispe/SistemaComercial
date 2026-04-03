import { apiVentas } from "@/lib/axios";
import {
  VentaResumen,
  VentaDetalle,
  VentaFormData,
  CotizacionResumen,
  CotizacionDetalle,
} from "../tipos/ventas.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/ventas";

export const servicioVentas = {
  obtenerVentas: async (
    params?: PagedRequest,
  ): Promise<PagedResponse<VentaResumen>> => {
    const response: any = await apiVentas.get(BASE_URL, { params });
    // Handle both cases: response.datos or the response itself being the PagedResponse
    return response.datos ? response : (response.data || response);
  },

  obtenerVentaPorId: async (id: number): Promise<VentaDetalle> => {
    const response: any = await apiVentas.get(`${BASE_URL}/${id}`);
    return response.datos || response.data;
  },

  crearVenta: async (datos: VentaFormData): Promise<VentaDetalle> => {
    const response: any = await apiVentas.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  anularVenta: async (id: number, motivo: string): Promise<any> => {
    const response: any = await apiVentas.patch(`${BASE_URL}/${id}/anular`, {
      motivo,
    });
    return response.datos || response.data;
  },

  obtenerVentasDelDia: async (): Promise<any[]> => {
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
  ): Promise<PagedResponse<CotizacionResumen>> => {
    const response: any = await apiVentas.get("/cotizaciones", { params });
    return response.datos ? response : (response.data || response);
  },

  obtenerCotizacionPorId: async (id: number): Promise<CotizacionDetalle> => {
    const response: any = await apiVentas.get(`/cotizaciones/${id}`);
    return response.datos || response.data;
  },

  crearNotaCredito: async (datos: any): Promise<any> => {
    const response: any = await apiVentas.post("/notas/credito", datos);
    return response.datos || response.data;
  },

  crearNotaDebito: async (datos: any): Promise<any> => {
    const response: any = await apiVentas.post("/notas/debito", datos);
    return response.datos || response.data;
  },

  obtenerMotivosCredito: async (): Promise<any[]> => {
    const response: any = await apiVentas.get("/notas/catalogos/motivos-credito");
    return response.datos || response.data || [];
  },

  obtenerMotivosDebito: async (): Promise<any[]> => {
    const response: any = await apiVentas.get("/notas/catalogos/motivos-debito");
    return response.datos || response.data || [];
  },

  obtenerEstadosCpe: async (): Promise<any[]> => {
    const response: any = await apiVentas.get("/notas/catalogos/estado-cpe");
    return response.datos || response.data || [];
  },

  obtenerNotasCredito: async (params?: PagedRequest): Promise<PagedResponse<any>> => {
    const response: any = await apiVentas.get("/notas/credito", { params });
    return response.datos ? response : (response.data || response);
  },

  obtenerNotasDebito: async (params?: PagedRequest): Promise<PagedResponse<any>> => {
    const response: any = await apiVentas.get("/notas/debito", { params });
    return response.datos ? response : (response.data || response);
  },
};
