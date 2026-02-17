import { apiConfiguracion } from "@/lib/axios";
import { ToReturnList } from "@/types/api.types";

export interface TipoComprobante {
  id: number;
  codigo: string;
  nombre: string;
  mueveStock: boolean;
  tipoMovimientoStock: string;
  activado: boolean;
}

export const tipoComprobanteService = {
  getAll: async (): Promise<ToReturnList<TipoComprobante>> => {
    return await apiConfiguracion.get("/tipos-comprobante");
  },
};
