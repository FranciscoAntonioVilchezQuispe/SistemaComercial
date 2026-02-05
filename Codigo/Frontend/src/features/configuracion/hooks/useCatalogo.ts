import { useQuery } from "@tanstack/react-query";
import { catalogoService } from "../services/catalogoService";

/**
 * Hook para obtener los valores de un catálogo por su código.
 * Utiliza React Query para el manejo de caché y estado.
 */
export const useCatalogo = (codigo: string) => {
  return useQuery({
    queryKey: ["catalogo", codigo],
    queryFn: () => catalogoService.getValoresByCodigo(codigo),
    // Mapeamos para devolver directamente la lista de valores
    // EL BACKEND RETORNA 'datos' en el wrapper ToReturnList, no 'data'
    select: (response: any) => {
      // Intenta obtener el array de varias ubicaciones posibles
      const data = response.datos || response.data || (Array.isArray(response) ? response : []);
      console.log(`Catalogo [${codigo}] raw data:`, data); 

      return data.map((item: any, index: number) => {
        // Mapeo exhaustivo de posibles nombres de propiedad para ID y Nombre
        const id = item.id ?? item.Id ?? item.idDetalle ?? item.IdDetalle ?? item.idValorCatalogo ?? 0;
        const nombre = item.nombre ?? item.Nombre ?? item.valor ?? "";
        
        // Si no hay ID válido, generar uno temporal para evitar crash de React (duplicate keys)
        // y loguear el item problemático
        if (!id) {
           console.warn(`Item en índice ${index} no tiene ID válido:`, item);
        }
        
        return {
          ...item,
          id: id === 0 ? `temp-${index}` : id, 
          nombre: nombre || `Sin nombre (${index})`,
        };
      });
    },
    enabled: !!codigo,
    staleTime: 1000 * 60 * 10, // 10 minutos de caché para catálogos (cambian poco)
    refetchOnWindowFocus: false,
  });
};
