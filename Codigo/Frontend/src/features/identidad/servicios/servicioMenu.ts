import { apiIdentidad } from "@/lib/axios";
import type { Menu, MenuFormData } from "@/types/permisos.types";

export const menuService = {
  obtenerMenus: async (): Promise<Menu[]> => {
    const response: any = await apiIdentidad.get("/menus");
    return response.data;
  },

  obtenerMenusJerarquicos: async (): Promise<Menu[]> => {
    const response: any = await apiIdentidad.get("/menus/jerarquicos");
    return response.data;
  },

  obtenerMenuPorId: async (id: number): Promise<Menu> => {
    const response: any = await apiIdentidad.get(`/menus/${id}`);
    return response.data;
  },

  crearMenu: async (menu: MenuFormData): Promise<Menu> => {
    const response: any = await apiIdentidad.post("/menus", menu);
    return response.data;
  },

  actualizarMenu: async (id: number, menu: MenuFormData): Promise<Menu> => {
    const response: any = await apiIdentidad.put(`/menus/${id}`, {
      ...menu,
      id,
    });
    return response.data;
  },

  eliminarMenu: async (id: number): Promise<void> => {
    await apiIdentidad.delete(`/menus/${id}`);
  },
};
