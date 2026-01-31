import { PagedResponse } from "@/types/pagination.types";

export interface TablaGeneral {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  esSistema: boolean;
  cantidadValores: number;
}

export interface TablaGeneralFormData {
  codigo: string;
  nombre: string;
  descripcion?: string;
  esSistema: boolean;
}

export interface TablaGeneralDetalle {
  id: number;
  idTabla: number;
  codigo: string;
  nombre: string;
  orden: number;
  estado: boolean;
}

export interface TablaGeneralDetalleFormData {
  codigo: string;
  nombre: string;
  orden: number;
  estado: boolean;
}

export interface RespuestaTablasGenerales extends PagedResponse<TablaGeneral> {}
