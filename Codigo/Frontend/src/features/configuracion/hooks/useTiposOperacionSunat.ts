import { useQuery, UseQueryResult } from "@tanstack/react-query";
import { apiConfiguracion } from "@/lib/axios";

export interface TipoOperacionSunat {
  id: number;
  codigo: string;
  nombre: string;
  activo: boolean;
}

const obtenerTiposOperacion = async (): Promise<TipoOperacionSunat[]> => {
  const response: any = await apiConfiguracion.get("/tiposoperacionsunat");
  const data = response.datos || response.data || response;
  return Array.isArray(data) ? data : [];
};

/**
 * Hook para obtener el catálogo de tipos de operación SUNAT (ej. Venta Interna, Exportación)
 */
export const useTiposOperacionSunat = (): UseQueryResult<TipoOperacionSunat[], Error> => {
  return useQuery({
    queryKey: ["tipos-operacion-sunat"],
    queryFn: obtenerTiposOperacion,
    staleTime: 1000 * 60 * 60, // 1 hora de caché ya que es data maestra estática
  });
};
