// Tipos para el sistema de permisos granulares

export interface Menu {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  ruta?: string;
  icono?: string;
  orden: number;
  idMenuPadre?: number;
  subMenus?: Menu[];
  activado: boolean;
  fechaCreacion?: string;
  usuarioCreacion?: string;
  fechaModificacion?: string;
  usuarioModificacion?: string;
}

export interface MenuFormData {
  codigo: string;
  nombre: string;
  descripcion?: string;
  ruta?: string;
  icono?: string;
  orden: number;
  idMenuPadre?: number;
}

export interface TipoPermiso {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  activado: boolean;
  fechaCreacion?: string;
  usuarioCreacion?: string;
}

export interface RolMenu {
  id: number;
  idRol: number;
  idMenu: number;
  menu?: Menu;
  rol?: any; // Tipo Rol del módulo existente
  permisos?: RolMenuPermiso[];
  activado: boolean;
}

export interface RolMenuPermiso {
  id: number;
  idRolMenu: number;
  idTipoPermiso: number;
  tipoPermiso?: TipoPermiso;
  activado: boolean;
}

export interface UsuarioRol {
  id: number;
  idUsuario: number;
  idRol: number;
  rol?: any; // Tipo Rol del módulo existente
  usuario?: any; // Tipo Usuario del módulo existente
  activado: boolean;
}

export interface MenuConPermisos {
  menu: Menu;
  permisos: string[]; // ["CREATE", "READ", "UPDATE", "DELETE"]
}

export interface AsignarPermisoRequest {
  idRolMenu?: number;
  idTipoPermiso: number;
}

export interface AsignarRolMenuRequest {
  idRol: number;
  idMenu: number;
}

export interface AsignarUsuarioRolRequest {
  idUsuario: number;
  idRol: number;
}
