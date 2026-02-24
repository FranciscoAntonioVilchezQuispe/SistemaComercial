import { apiInventario } from "@/lib/axios";
import { KardexReporteDto, PeriodoRequest } from "../tipos/kardex";

export const kardexService = {
  obtenerReporte: async (
    almacenId: number,
    productoId: number,
    desde: string,
    hasta: string,
  ): Promise<KardexReporteDto> => {
    const response = await apiInventario.get<KardexReporteDto>(
      "/inventario/kardex/reporte",
      {
        params: { almacenId, productoId, desde, hasta },
      },
    );
    return response as any;
  },

  abrirPeriodo: async (
    datos: PeriodoRequest,
  ): Promise<{ success: boolean; message: string }> => {
    const response = await apiInventario.post(
      "/inventario/kardex/periodos/abrir",
      datos,
    );
    return response as any;
  },

  cerrarPeriodo: async (
    datos: PeriodoRequest,
  ): Promise<{ success: boolean; message: string }> => {
    const response = await apiInventario.post(
      "/inventario/kardex/periodos/cerrar",
      datos,
    );
    return response as any;
  },

  recalcular: async (datos: {
    almacenId: number;
    productoId: number;
    desdeFecha: string;
    motivo: string;
    usuarioId: number;
  }): Promise<{ success: boolean; message: string }> => {
    const response = await apiInventario.post(
      "/inventario/kardex/recalcular",
      datos,
    );
    return response as any;
  },
};
