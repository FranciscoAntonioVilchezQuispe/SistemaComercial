import { useAuth } from "@/features/identidad/context/AuthContext";

export type AccionPermiso = "VER" | "CREAR" | "EDITAR" | "ELIMINAR";

export function usePermiso(codigoMenu: string, accion: AccionPermiso = "VER"): boolean {
    const { permisos } = useAuth();


    const permisoExacto = `${codigoMenu}:${accion}`;
    const tieneExacto = permisos.includes(permisoExacto);
    const tieneSubMenu = permisos.some(
        p => p.startsWith(`${codigoMenu}_`) && p.endsWith(`:${accion}`)
    );

    return tieneExacto || tieneSubMenu;
}

export function usePermisoMenu(codigoMenu: string): boolean {
    return usePermiso(codigoMenu, "VER");
}

export function useEsAdmin(): boolean {
    const { roles } = useAuth();
    return roles.some(r => r === "ADMINISTRADOR");
}
