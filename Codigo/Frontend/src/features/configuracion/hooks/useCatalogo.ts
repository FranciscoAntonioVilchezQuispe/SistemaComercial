import { useQuery } from "@tanstack/react-query";
import { catalogoService } from "../services/catalogoService";
import { ToReturnList } from "@/types/api.types";
import { ValorCatalogo } from "@/types/catalogo.types";

/**
 * Hook para obtener los valores de un catálogo por su código.
 * Utiliza React Query para el manejo de caché y estado.
 */
export const useCatalogo = (codigo: string) => {
  return useQuery({
    queryKey: ["catalogo", codigo],
    queryFn: () => catalogoService.getValoresByCodigo(codigo),
    // Mapeamos para devolver directamente la lista de valores
    select: (response: ToReturnList<ValorCatalogo>) => response.data || [],
    enabled: !!codigo,
    staleTime: 1000 * 60 * 10, // 10 minutos de caché para catálogos (cambian poco)
    refetchOnWindowFocus: false,
  });
};
