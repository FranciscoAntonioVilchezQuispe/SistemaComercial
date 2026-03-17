import { apiConfiguracion } from "@/lib/axios";
import {
  MatrizReglaSunat,
  MatrizReglaSunatFormData,
} from "../tipos/matrizRegla.types";

const BASE_URL = "/configuracion/matriz-sunat";

export const servicioMatrizRegla = {
  obtenerTodas: async (): Promise<MatrizReglaSunat[]> => {
    const response: any = await apiConfiguracion.get(BASE_URL);
    const lista = response.datos || response.data || response;
    return Array.isArray(lista) ? lista : [];
  },

  obtenerPorOperacion: async (codigo: string): Promise<MatrizReglaSunat[]> => {
    const response: any = await apiConfiguracion.get(
      `${BASE_URL}/operacion/${codigo}`,
    );
    const lista = response.datos || response.data || response;
    return Array.isArray(lista) ? lista : [];
  },

  crear: async (datos: MatrizReglaSunatFormData): Promise<MatrizReglaSunat> => {
    const response: any = await apiConfiguracion.post(BASE_URL, datos);
    return response.datos || response.data;
  },

  actualizar: async (
    id: number,
    datos: MatrizReglaSunatFormData,
  ): Promise<MatrizReglaSunat> => {
    const response: any = await apiConfiguracion.put(
      `${BASE_URL}/${id}`,
      datos,
    );
    return response.datos || response.data;
  },

  eliminar: async (id: number): Promise<void> => {
    await apiConfiguracion.delete(`${BASE_URL}/${id}`);
  },
};
