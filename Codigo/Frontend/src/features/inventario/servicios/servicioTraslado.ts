import { apiInventario } from "@/lib/axios";

export interface TrasladoDetalleDTO {
  productoId: number;
  cantidad: number;
}

export interface CrearTrasladoComando {
  almacenOrigenId: number;
  almacenDestinoId: number;
  observaciones?: string;
  detalles: TrasladoDetalleDTO[];
}

export interface RecibirTrasladoDetalleDTO {
  productoId: number;
  cantidadRecibida: number;
  observaciones?: string;
}

export interface RecibirTrasladoComando {
  trasladoId: number;
  observaciones?: string;
  detalles: RecibirTrasladoDetalleDTO[];
}

export const servicioTraslado = {
  crear: async (comando: CrearTrasladoComando) => {
    const response: any = await apiInventario.post(
      "/inventario/traslados",
      comando,
    );
    return response;
  },

  recibir: async (comando: RecibirTrasladoComando) => {
    const response: any = await apiInventario.post(
      "/inventario/traslados/recibir",
      comando,
    );
    return response;
  },

  obtenerTodos: async () => {
    const response: any = await apiInventario.get("/inventario/traslados");
    return response;
  },
};
