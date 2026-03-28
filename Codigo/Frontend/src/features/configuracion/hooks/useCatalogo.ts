import { useQuery } from "@tanstack/react-query";
import { servicioCatalogo } from "@/features/configuracion/servicios/servicioCatalogo";

/**
 * Hook para obtener los valores de un catálogo por su código.
 * @param codigo Código del catálogo (ej. 'TIPO_DOCUMENTO', 'TIPO_COMPROBANTE')
 */
export const useCatalogo = (codigo: string) => {
  return useQuery({
    queryKey: ["catalogo", codigo],
    queryFn: () => servicioCatalogo.obtenerValoresPorCodigo(codigo),
    // Mapeamos para devolver directamente la lista de valores
    // EL BACKEND RETORNA 'datos' en el wrapper ToReturnList, no 'data'
    select: (response: any) => {
      const lista = response.datos || response.data || [];
      return lista.map((item: any, index: number) => ({
        ...item,
        // Sincronización con Backend: Priorizar idDetalle (número) sobre otros campos
        id: item.idDetalle || item.id || item.codigo || `temp-${index}`,
        nombre: item.nombre || `Sin nombre ${item.codigo || index}`,
      }));
    },
    enabled: !!codigo,
    staleTime: 1000 * 60 * 30, // 30 minutos
  });
};
