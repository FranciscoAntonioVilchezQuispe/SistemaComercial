import { apiConfiguracion } from "@/lib/axios";
import { ToReturnList } from "@/types/api.types";

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
  getAll: async (): Promise<ToReturnList<TipoDocumento>> => {
    // Usando el endpoint existente que ya devuelve los tipos de documento
    return await apiConfiguracion.get("/reglasdocumentos/reglas");
  },
};
