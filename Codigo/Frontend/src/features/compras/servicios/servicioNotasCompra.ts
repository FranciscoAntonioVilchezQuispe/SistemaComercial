import { apiCompras as api } from "@/lib/axios";
import { PagedResponse } from "@/types/pagination.types";

export interface NotaResumenCompra {
  id: number;
  idNota: number;
  serie: string;
  numero: string;
  tipoComprobante: string;
  fechaEmision: string;
  proveedorRazonSocial: string;
  estado: string;
  total: number;
}

export interface NotaDetalleCompra {
  id: number;
  serie: string;
  numero: string;
  tipoComprobante: string;
  fechaEmision: string;
  idCompraReferencia: number;
  serieReferencia: string;
  numeroReferencia: string;
  tipoDocReferencia: string;
  idTipoNota: number;
  motivoSustento: string;
  proveedorNroDoc: string;
  proveedorRazonSocial: string;
  subtotal: number;
  igv: number;
  total: number;
  moneda: string;
  tipoCambio?: number;
  afectaStock: boolean;
  estado: string;
  detalles: NotaItemDetalleCompra[];
}

export interface NotaItemDetalleCompra {
  id: number;
  idProducto: number;
  descripcion?: string;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
  igv: number;
  total: number;
  unidadMedida?: string;
}

export interface MotivoCompra {
  idMotivo: number;
  codigoSunat: string;
  descripcion: string;
}

export const servicioNotasCompra = {
  obtenerNotasCredito: async (params: any) => {
    const response = await api.get<PagedResponse<NotaResumenCompra>>("/compras/notas/credito", { params });
    return response.data;
  },

  obtenerNotasDebito: async (params: any) => {
    const response = await api.get<PagedResponse<NotaResumenCompra>>("/compras/notas/debito", { params });
    return response.data;
  },

  obtenerDetalleCredito: async (id: number) => {
    const response = await api.get<NotaDetalleCompra>(`/compras/notas/credito/${id}`);
    return response.data;
  },

  obtenerDetalleDebito: async (id: number) => {
    const response = await api.get<NotaDetalleCompra>(`/compras/notas/debito/${id}`);
    return response.data;
  },

  obtenerMotivosCredito: async () => {
    const response = await api.get<{ data: MotivoCompra[] }>("/compras/notas/catalogos/motivos-credito");
    return response.data;
  },

  obtenerMotivosDebito: async () => {
    const response = await api.get<{ data: MotivoCompra[] }>("/compras/notas/catalogos/motivos-debito");
    return response.data;
  },

  crearNotaCredito: async (data: any) => {
    const response = await api.post("/compras/notas/credito", data);
    return response.data;
  },

  crearNotaDebito: async (data: any) => {
    const response = await api.post("/compras/notas/debito", data);
    return response.data;
  }
};
