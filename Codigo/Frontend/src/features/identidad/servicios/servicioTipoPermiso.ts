import { apiIdentidad } from "@/lib/axios";
import type { TipoPermiso } from "@/types/permisos.types";

export const tipoPermisoService = {
  obtenerTiposPermiso: async (): Promise<TipoPermiso[]> => {
    const response: any = await apiIdentidad.get("/tipos-permiso");
    return response.data;
  },

  obtenerTipoPermisoPorId: async (id: number): Promise<TipoPermiso> => {
    const response: any = await apiIdentidad.get(`/tipos-permiso/${id}`);
    return response.data;
  },

  crearTipoPermiso: async (
    tipo: Omit<TipoPermiso, "id" | "activado">,
  ): Promise<TipoPermiso> => {
    const response: any = await apiIdentidad.post("/tipos-permiso", tipo);
    return response.data;
  },
};
