import { apiCompras } from "@/lib/axios";
import { Proveedor, ProveedorFormData } from "../types/proveedor.types";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const BASE_URL = "/proveedores";

export const obtenerProveedores = async (
  paginacion?: PagedRequest,
): Promise<PagedResponse<Proveedor>> => {
  const params = paginacion || {};
  const respuesta: any = await apiCompras.get(BASE_URL, { params });
  
  const datosRaw = respuesta.datos || [];
  const datosMapeados = datosRaw.map((p: any) => ({
    ...p,
    id: p.id ?? p.Id ?? p.idProveedor ?? 0,
    idTipoDocumento: p.idTipoDocumento ?? p.IdTipoDocumento ?? 0,
    numeroDocumento: p.numeroDocumento ?? p.NumeroDocumento ?? "",
    razonSocial: p.razonSocial ?? p.RazonSocial ?? "",
    email: p.email ?? p.Email ?? "",
    telefono: p.telefono ?? p.Telefono ?? "",
    paginaWeb: p.paginaWeb ?? p.PaginaWeb ?? "",
  }));

  return {
    ...respuesta,
    datos: datosMapeados,
  };
};

export const obtenerProveedor = async (id: number): Promise<Proveedor> => {
  const respuesta: any = await apiCompras.get(`${BASE_URL}/${id}`);
  const p = respuesta.data || respuesta;
  return {
    ...p,
    id: p.id ?? p.Id ?? p.idProveedor ?? 0,
  };
};

export const crearProveedor = async (
  data: ProveedorFormData,
): Promise<Proveedor> => {
  const respuesta: any = await apiCompras.post(BASE_URL, data);
  return respuesta.data || respuesta.datos || respuesta;
};

export const actualizarProveedor = async (
  id: number,
  data: ProveedorFormData,
): Promise<void> => {
  await apiCompras.put(`${BASE_URL}/${id}`, data);
};

export const eliminarProveedor = async (id: number): Promise<void> => {
  await apiCompras.delete(`${BASE_URL}/${id}`);
};
