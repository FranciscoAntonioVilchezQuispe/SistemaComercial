import { apiVentas } from "@/lib/axios";
import {
  Venta,
  VentaFormData,
  VentaFiltros,
  RespuestaVentas,
} from "../tipos/ventas.types";

const BASE_URL = "/ventas";

export const servicioVentas = {
  obtenerVentas: async (
    filtros?: VentaFiltros,
    pagina: number = 1,
    elementosPorPagina: number = 10,
  ): Promise<RespuestaVentas> => {
    const params = new URLSearchParams();

    if (filtros?.fechaInicio) params.append("fechaInicio", filtros.fechaInicio);
    if (filtros?.fechaFin) params.append("fechaFin", filtros.fechaFin);
    if (filtros?.idCliente)
      params.append("idCliente", filtros.idCliente.toString());
    if (filtros?.idEstado)
      params.append("idEstado", filtros.idEstado.toString());
    if (filtros?.idEstadoPago)
      params.append("idEstadoPago", filtros.idEstadoPago.toString());
    if (filtros?.numeroComprobante)
      params.append("numeroComprobante", filtros.numeroComprobante);

    params.append("pagina", pagina.toString());
    params.append("elementosPorPagina", elementosPorPagina.toString());

    const response: any = await apiVentas.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerVentaPorId: async (id: number): Promise<Venta> => {
    const response: any = await apiVentas.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  crearVenta: async (datos: VentaFormData): Promise<Venta> => {
    const response: any = await apiVentas.post(BASE_URL, datos);
    return response.data;
  },

  anularVenta: async (id: number, motivo: string): Promise<Venta> => {
    const response: any = await apiVentas.patch(`${BASE_URL}/${id}/anular`, {
      motivo,
    });
    return response.data;
  },

  obtenerVentasDelDia: async (): Promise<Venta[]> => {
    const response: any = await apiVentas.get(`${BASE_URL}/hoy`);
    return response.data;
  },

  obtenerEstadisticas: async (fechaInicio: string, fechaFin: string) => {
    const response: any = await apiVentas.get(`${BASE_URL}/estadisticas`, {
      params: { fechaInicio, fechaFin },
    });
    return response.data;
  },
};
