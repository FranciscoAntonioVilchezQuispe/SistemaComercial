import { apiConfiguracion } from "@/lib/axios";
import { ToReturnList } from "@/types/api.types";

import { TipoComprobante } from "../tipos/tipoComprobante.types";

export const tipoComprobanteService = {
  getAll: async (modulo?: string): Promise<ToReturnList<TipoComprobante>> => {
    return await apiConfiguracion.get("/tipos-comprobante", {
      params: { modulo },
    });
  },
};
