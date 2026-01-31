import { apiIdentidad } from "@/lib/axios";
import type {
  Menu,
  UsuarioRol,
  AsignarUsuarioRolRequest,
} from "@/types/permisos.types";

export const usuarioPermisoService = {
  obtenerMenusDisponibles: async (idUsuario: number): Promise<Menu[]> => {
    const response: any = await apiIdentidad.get(
      `/usuarios/${idUsuario}/menus`,
    );
    return response.data;
  },

  verificarPermiso: async (
    idUsuario: number,
    codigoMenu: string,
    codigoPermiso: string,
  ): Promise<boolean> => {
    const response: any = await apiIdentidad.get(
      `/usuarios/${idUsuario}/permisos/${codigoMenu}/${codigoPermiso}`,
    );
    return response.tienePermiso || false;
  },

  obtenerRolesDeUsuario: async (idUsuario: number): Promise<UsuarioRol[]> => {
    const response: any = await apiIdentidad.get(
      `/usuarios/${idUsuario}/roles`,
    );
    return response.data;
  },

  asignarRolAUsuario: async (
    request: AsignarUsuarioRolRequest,
  ): Promise<UsuarioRol> => {
    const { idUsuario, idRol } = request;
    const response: any = await apiIdentidad.post(
      `/usuarios/${idUsuario}/roles`,
      {
        idUsuario,
        idRol,
      },
    );
    return response.data;
  },

  quitarRolDeUsuario: async (
    idUsuario: number,
    idUsuarioRol: number,
  ): Promise<void> => {
    await apiIdentidad.delete(`/usuarios/${idUsuario}/roles/${idUsuarioRol}`);
  },
};
