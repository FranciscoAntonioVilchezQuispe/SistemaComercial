import { apiIdentidad } from "@/lib/axios";

export interface UsuarioDto {
    id: number;
    username: string;
    email: string;
    nombres: string;
    apellidos: string;
    idTrabajador: number; // Nuevo: obligatorio
    ultimoAcceso?: string;
    usuariosRoles?: { idRol: number; rol: { nombreRol: string } }[];
}

export interface AccesoMenuDto {
    idMenu: number;
    tiposPermisoIds: number[];
}

export interface RolDto {
    id: number;
    nombreRol: string;
    descripcion: string;
}

export interface PermisoDto {
    id: number;
    codigoPermiso: string;
    descripcion: string;
    modulo: string;
}

export interface TrabajadorDto {
    id: number;
    nombres: string;
    apellidos: string;
    numeroDocumento: string;
    emailCorporativo: string;
    cargo?: { nombreCargo: string };
    idUsuario?: number;
}

export const identidadAdminService = {
    // Usuarios
    obtenerUsuarios: async () => {
        const response: any = await apiIdentidad.get("/usuarios");
        return response.datos || [];
    },
    crearUsuario: async (data: any) => {
        const response: any = await apiIdentidad.post("/usuarios", data);
        return response.data;
    },
    actualizarUsuario: async (id: number, data: any) => {
        const response: any = await apiIdentidad.put(`/usuarios/${id}`, { id, ...data });
        return response.data;
    },

    // Roles y Permisos
    obtenerRoles: async () => {
        const response: any = await apiIdentidad.get("/roles");
        return response.datos || [];
    },
    obtenerPermisos: async () => {
        const response: any = await apiIdentidad.get("/permisos");
        return response.datos || [];
    },
    actualizarPermisosRol: async (idRol: number, permisosIds: number[]) => {
        const response: any = await apiIdentidad.post(`/roles/${idRol}/permisos`, { idRol, permisosIds });
        return response.data;
    },
    actualizarAccesoRol: async (idRol: number, accesos: AccesoMenuDto[]) => {
        const response: any = await apiIdentidad.post(`/roles/${idRol}/acceso-granular`, { idRol, accesos });
        return response.data;
    },

    // Trabajadores
    obtenerTrabajadores: async () => {
        const response: any = await apiIdentidad.get("/trabajadores");
        return response.datos || [];
    },
    obtenerCargos: async () => {
        const response: any = await apiIdentidad.get("/api/cargos");
        return response.datos || [];
    }
};
