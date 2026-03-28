import { apiConfiguracion } from "@/lib/axios";
import { ToReturn, ToReturnList } from "@/types/api.types";
import { ValorCatalogo, Catalogo } from "@/types/catalogo.types";

export const servicioCatalogo = {
  /**
   * Obtiene todos los catálogos (cabeceras)
   */
  obtenerTodos: async (): Promise<ToReturnList<Catalogo>> => {
    return await apiConfiguracion.get("/catalogos");
  },

  /**
   * Obtiene un catálogo por su código incluyendo sus valores
   */
  obtenerPorCodigo: async (
    codigo: string,
  ): Promise<ToReturn<Catalogo & { detalles: ValorCatalogo[] }>> => {
    return await apiConfiguracion.get(`/catalogos/${codigo}`);
  },

  /**
   * Obtiene todos los valores de un catálogo específico por su código (p.ej. 'TIPO_PRODUCTO')
   */
  obtenerValoresPorCodigo: async (
    codigo: string,
  ): Promise<ToReturnList<ValorCatalogo>> => {
    return await apiConfiguracion.get(`/catalogos/${codigo}/valores`);
  },

  /**
   * Obtiene un valor específico de catálogo por su ID
   */
  obtenerValorPorId: async (id: number): Promise<ToReturn<ValorCatalogo>> => {
    return await apiConfiguracion.get(`/catalogos/valores/${id}`);
  },
};
