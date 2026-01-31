import { apiClientes } from "@/lib/axios";
import {
  Cliente,
  ClienteFormData,
  ClienteFiltros,
  RespuestaClientes,
} from "../tipos/ventas.types";

const BASE_URL = "/clientes";

export const servicioClientes = {
  obtenerClientes: async (
    filtros?: ClienteFiltros,
    pagina: number = 1,
    elementosPorPagina: number = 10,
  ): Promise<RespuestaClientes> => {
    const params = new URLSearchParams();

    if (filtros?.busqueda) params.append("busqueda", filtros.busqueda);
    if (filtros?.idTipoDocumento)
      params.append("idTipoDocumento", filtros.idTipoDocumento.toString());
    if (filtros?.idTipoCliente)
      params.append("idTipoCliente", filtros.idTipoCliente.toString());
    if (filtros?.activo !== undefined)
      params.append("activo", filtros.activo.toString());

    params.append("pagina", pagina.toString());
    params.append("elementosPorPagina", elementosPorPagina.toString());

    const response: any = await apiClientes.get(
      `${BASE_URL}?${params.toString()}`,
    );
    return response;
  },

  obtenerClientePorId: async (id: number): Promise<Cliente> => {
    const response: any = await apiClientes.get(`${BASE_URL}/${id}`);
    return response.data;
  },

  buscarPorDocumento: async (
    numeroDocumento: string,
  ): Promise<Cliente | null> => {
    const response: any = await apiClientes.get(
      `${BASE_URL}/documento/${numeroDocumento}`,
    );
    return response.data;
  },

  crearCliente: async (datos: ClienteFormData): Promise<Cliente> => {
    const response: any = await apiClientes.post(BASE_URL, datos);
    return response.data;
  },

  actualizarCliente: async (
    id: number,
    datos: ClienteFormData,
  ): Promise<Cliente> => {
    const response: any = await apiClientes.put(`${BASE_URL}/${id}`, datos);
    return response.data;
  },

  eliminarCliente: async (id: number): Promise<void> => {
    await apiClientes.delete(`${BASE_URL}/${id}`);
  },

  obtenerHistorialCompras: async (id: number) => {
    const response: any = await apiClientes.get(`${BASE_URL}/${id}/historial`);
    return response.data;
  },
};
