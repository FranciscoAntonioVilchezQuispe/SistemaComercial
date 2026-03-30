import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";
import { toast } from "sonner";
import { servicioProductos } from "../servicios/servicioProductos";
import { ProductoResumen, ProductoDetalle, ProductoFormData } from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = ["productos"];

/**
 * Hook para obtener lista de productos paginada (Ligero)
 */
export function useProductos(
  req?: PagedRequest,
  options?: { enabled?: boolean },
): UseQueryResult<PagedResponse<ProductoResumen>, Error> {
  return useQuery({
    queryKey: [...QUERY_KEY, "lista", req],
    queryFn: () => servicioProductos.obtenerProductos(req),
    enabled: options?.enabled ?? true,
  });
}

/**
 * Hook para obtener un producto por ID (Detalle completo)
 */
export function useProducto(id: number): UseQueryResult<ProductoDetalle, Error> {
  return useQuery({
    queryKey: [...QUERY_KEY, "detalle", id],
    queryFn: () => servicioProductos.obtenerProductoPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para crear un producto
 */
export function useCrearProducto(): UseMutationResult<
  ProductoDetalle,
  Error,
  ProductoFormData
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: ProductoFormData) =>
      servicioProductos.crearProducto(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      toast.success("Producto creado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para actualizar un producto
 */
export function useActualizarProducto(): UseMutationResult<
  ProductoDetalle,
  Error,
  { id: number; datos: ProductoFormData }
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: ProductoFormData }) =>
      servicioProductos.actualizarProducto(id, datos),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      queryClient.invalidateQueries({ queryKey: [...QUERY_KEY, "detalle", id] });
      toast.success("Producto actualizado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para eliminar un producto
 */
export function useEliminarProducto(): UseMutationResult<void, Error, number> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioProductos.eliminarProducto(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: QUERY_KEY });
      toast.success("Producto eliminado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para buscar producto por código de barras (Detalle completo)
 */
export function useBuscarPorCodigoBarras(codigoBarras: string) {
  return useQuery({
    queryKey: [...QUERY_KEY, "codigo-barras", codigoBarras],
    queryFn: () => servicioProductos.buscarPorCodigoBarras(codigoBarras),
    enabled: !!codigoBarras && codigoBarras.length > 0,
  });
}
