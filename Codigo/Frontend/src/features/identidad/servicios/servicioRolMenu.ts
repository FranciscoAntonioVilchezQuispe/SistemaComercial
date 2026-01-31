import { apiIdentidad } from "@/lib/axios";
import type {
  RolMenu,
  RolMenuPermiso,
  AsignarRolMenuRequest,
  AsignarPermisoRequest,
} from "@/types/permisos.types";

export const rolMenuService = {
  obtenerMenusPorRol: async (idRol: number): Promise<RolMenu[]> => {
    const response: any = await apiIdentidad.get(`/roles/${idRol}/menus`);
    return response.data;
  },

  asignarMenuARol: async (request: AsignarRolMenuRequest): Promise<RolMenu> => {
    const { idRol, idMenu } = request;
    const response: any = await apiIdentidad.post(`/roles/${idRol}/menus`, {
      idRol,
      idMenu,
    });
    return response.data;
  },

  quitarMenuDeRol: async (idRol: number, idRolMenu: number): Promise<void> => {
    await apiIdentidad.delete(`/roles/${idRol}/menus/${idRolMenu}`);
  },

  obtenerPermisosPorRolMenu: async (
    idRol: number,
    idMenu: number,
  ): Promise<RolMenuPermiso[]> => {
    const response: any = await apiIdentidad.get(
      `/roles/${idRol}/menus/${idMenu}/permisos`,
    );
    return response.data;
  },

  asignarPermisoARolMenu: async (
    idRol: number,
    idMenu: number,
    request: AsignarPermisoRequest,
  ): Promise<RolMenuPermiso> => {
    const response: any = await apiIdentidad.post(
      `/roles/${idRol}/menus/${idMenu}/permisos`,
      request,
    );
    return response.data;
  },

  quitarPermisoDeRolMenu: async (
    _idRol: number,
    _idMenu: number,
    _idRolMenuPermiso: number,
  ): Promise<void> => {
    console.warn(
      "Endpoint de eliminación de permiso específico no implementado en backend",
    );
  },
};
