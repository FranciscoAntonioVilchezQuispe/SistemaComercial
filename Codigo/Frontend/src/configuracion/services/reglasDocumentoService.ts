import { apiConfiguracion } from "@/lib/axios";

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
};
