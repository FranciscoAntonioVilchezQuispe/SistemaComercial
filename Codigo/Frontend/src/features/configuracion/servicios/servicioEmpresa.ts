import { apiConfiguracion } from "@/lib/axios";
import { Empresa, EmpresaFormData } from "../tipos/empresa.types";

const BASE_URL = "/empresa";

export const servicioEmpresa = {
  obtenerEmpresa: async (): Promise<Empresa> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    // response is the body (Wrapper). response.data is the entity.
    return response.data;
  },

  actualizarEmpresa: async (datos: EmpresaFormData): Promise<Empresa> => {
    const response: any = await apiConfiguracion.put(BASE_URL, datos);
    return response.data;
  },
};
