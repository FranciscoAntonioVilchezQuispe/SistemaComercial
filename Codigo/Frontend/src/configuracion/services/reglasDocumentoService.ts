import { apiConfiguracion } from "@/lib/axios";
import { TipoComprobante } from "@/features/configuracion/tipos/tipoComprobante.types";

export interface ReglaDocumento {
  id?: number;
  codigo: string;
  nombre: string;
  longitud: number;
  esNumerico: boolean;
  estado: boolean;
  activado: boolean;
}

export interface RelacionDocComprobante {
  id?: number;
  codigoDocumento: string;
  idTipoComprobante: number;
}

export interface ReglasResponse {
  reglas: ReglaDocumento[];
  relaciones: RelacionDocComprobante[];
}

export const reglasDocumentoService = {
  obtenerConfiguracion: async (): Promise<ReglasResponse> => {
    const respuesta: any = await apiConfiguracion.get("/reglasdocumentos");
    return respuesta.datos || respuesta.data || respuesta;
  },

  listarReglas: async (): Promise<ReglaDocumento[]> => {
    const respuesta: any = await apiConfiguracion.get(
      "/reglasdocumentos/reglas",
    );
    return respuesta.datos || respuesta.data || [];
  },

  guardarRegla: async (regla: ReglaDocumento): Promise<ReglaDocumento> => {
    if (regla.id && regla.id > 0) {
      const respuesta: any = await apiConfiguracion.put(
        `/reglasdocumentos/reglas/${regla.id}`,
        regla,
      );
      return respuesta.data;
    } else {
      const respuesta: any = await apiConfiguracion.post(
        "/reglasdocumentos/reglas",
        regla,
      );
      return respuesta.data;
    }
  },

  eliminarRegla: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`/reglasdocumentos/reglas/${id}`);
  },

  actualizarRelaciones: async (
    codigoDocumento: string,
    idsTiposComprobante: number[],
  ): Promise<void> => {
    await apiConfiguracion.post(
      `/reglasdocumentos/relaciones/${codigoDocumento}`,
      idsTiposComprobante,
    );
  },

  listarRelacionesPorDocumento: async (
    codigoDocumento: string,
  ): Promise<RelacionDocComprobante[]> => {
    const respuesta: any = await apiConfiguracion.get(
      `/reglasdocumentos/relaciones/${codigoDocumento}`,
    );
    return respuesta.datos || respuesta.data || [];
  },

  listarComprobantesPorDocumento: async (
    codigoDocumento: string,
  ): Promise<TipoComprobante[]> => {
    const respuesta: any = await apiConfiguracion.get(
      `/reglasdocumentos/comprobantes/${codigoDocumento}`,
    );
    return respuesta.datos || respuesta.data || [];
  },
};
