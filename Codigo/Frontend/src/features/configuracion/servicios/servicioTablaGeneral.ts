import { apiConfiguracion } from "@/lib/axios";
import {
  TablaGeneral,
  TablaGeneralFormData,
  TablaGeneralDetalle,
  TablaGeneralDetalleFormData,
  RespuestaTablasGenerales,
} from "../tipos/tablaGeneral.types";
import { PagedRequest } from "@/types/pagination.types";

const BASE_URL = "/tablas-generales";

export const servicioTablaGeneral = {
  obtenerTablas: async (
    req?: PagedRequest,
  ): Promise<RespuestaTablasGenerales> => {
    const params = new URLSearchParams();
    if (req?.pageNumber) params.append("pageNumber", req.pageNumber.toString());
    if (req?.pageSize) params.append("pageSize", req.pageSize.toString());
    if (req?.search) params.append("search", req.search);

    const response: any = await apiConfiguracion.get(
      `${BASE_URL}?${params.toString()}`,
    );

    // Permitir flexibilidad en la estructura de respuesta
    const data = response.data || response;

    if (!data) {
      throw new Error("No data received from API");
    }

    // Normalizar datos/items
    if (!data.datos && data.items) {
      data.datos = data.items;
    }

    // Normalizar total/totalCount
    if (data.total === undefined && data.totalCount !== undefined) {
      data.total = data.totalCount;
    }

    // Si es un array directo, envolverlo en estructura paginada
    if (Array.isArray(data)) {
      return {
        datos: data.map((t: any) => ({
          ...t,
          id: t.id ?? t.idTabla ?? 0,
        })),
        total: data.length,
        pageNumber: 1,
        pageSize: data.length,
        totalPages: 1,
        hasPreviousPage: false,
        hasNextPage: false,
        status: 200,
        message: "",
        transactionId: "",
      };
    }

    // Mapear IDs si es necesario
    if (data.datos && Array.isArray(data.datos)) {
      data.datos = data.datos.map((t: any) => ({
        ...t,
        id: t.id ?? t.idTabla ?? 0,
      }));
    }

    return data;
  },

  obtenerTablaPorId: async (id: number): Promise<TablaGeneral> => {
    const response: any = await apiConfiguracion.get(`${BASE_URL}/${id}`);
    const d = response.data;
    return {
      ...d,
      id: d.id ?? d.idTabla ?? 0,
    };
  },

  crearTabla: async (datos: TablaGeneralFormData): Promise<TablaGeneral> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    const d = response.data;
    return {
      ...d,
      id: d.id ?? d.idTabla ?? 0,
    };
  },

  actualizarTabla: async (
    id: number,
    datos: TablaGeneralFormData,
  ): Promise<TablaGeneral> => {
    const response: any = await apiConfiguracion.put(
      `${BASE_URL}/${id}`,
      datos,
    );
    const d = response.data;
    return {
      ...d,
      id: d.id ?? d.idTabla ?? 0,
    };
  },

  eliminarTabla: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },

  // DETALLES

  obtenerDetalles: async (idTabla: number): Promise<TablaGeneralDetalle[]> => {
    console.log("ID tabla:", idTabla);
    console.log("URL:", `${BASE_URL}/${idTabla}/detalles`);
    const response: any = await apiConfiguracion.get(
      `${BASE_URL}/${idTabla}/detalles`,
    );
    console.log("Respuesta detalles:", response);

    const raw = response.data ?? response;

    // La API de backend envuelve los resultados en un ToReturnList<T>
    // Normalizamos para devolver SIEMPRE un array de TablaGeneralDetalle
    let lista: any[] = [];

    if (Array.isArray(raw)) {
      lista = raw;
    } else if (Array.isArray(raw.data)) {
      // Caso típico: { success, message, data: [...] }
      lista = raw.data;
    } else if (Array.isArray(raw.datos)) {
      // Por si el wrapper usa 'datos'
      lista = raw.datos;
    } else if (Array.isArray(raw.items)) {
      // Por si el wrapper usa 'items'
      lista = raw.items;
    }

    // Adaptar nombres del DTO del backend a los que usa el frontend
    return lista.map((d) => ({
      id: d.id ?? d.idDetalle ?? 0,
      idTabla: d.idTabla,
      codigo: d.codigo,
      nombre: d.nombre,
      orden: d.orden,
      estado: d.estado,
    })) as TablaGeneralDetalle[];
  },

  crearDetalle: async (
    idTabla: number,
    datos: TablaGeneralDetalleFormData,
  ): Promise<TablaGeneralDetalle> => {
    const response: any = await apiConfiguracion.post(
      `${BASE_URL}/${idTabla}/detalles`,
      datos,
    );
    return response.data;
  },

  actualizarDetalle: async (
    idDetalle: number,
    datos: TablaGeneralDetalleFormData,
  ): Promise<TablaGeneralDetalle> => {
    const response: any = await apiConfiguracion.put(
      `${BASE_URL}/detalles/${idDetalle}`,
      datos,
    );
    return response.data;
  },

  eliminarDetalle: async (idDetalle: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/detalles/${idDetalle}`);
  },
};
