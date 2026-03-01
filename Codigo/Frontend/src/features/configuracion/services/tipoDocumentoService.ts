import { apiConfiguracion } from "@/lib/axios";

export interface TipoDocumento {
  id: number;
  codigo: string;
  nombre: string;
  longitud: number;
  esNumerico: boolean;
  estado: boolean;
  activado: boolean;
}

export const tipoDocumentoService = {
  /** Obtiene los tipos de documento desde la tabla configuracion.tipo_documento */
  getAll: async (): Promise<TipoDocumento[]> => {
    const response: any = await apiConfiguracion.get("/tipos-documento");
    return response.datos || response.data || [];
  },
};
