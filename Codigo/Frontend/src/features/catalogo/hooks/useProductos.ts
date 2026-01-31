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
import { Producto, ProductoFormData } from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "productos";

/**
 * Hook para obtener lista de productos paginada
 */
export function useProductos(
  req?: PagedRequest,
): UseQueryResult<PagedResponse<Producto>, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, req],
    queryFn: () => servicioProductos.obtenerProductos(req),
  });
}

/**
 * Hook para obtener un producto por ID
 */
export function useProducto(id: number) {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioProductos.obtenerProductoPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para crear un producto
 */
export function useCrearProducto(): UseMutationResult<
  Producto,
  Error,
  ProductoFormData
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: ProductoFormData) =>
      servicioProductos.crearProducto(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
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
  Producto,
  Error,
  { id: number; datos: ProductoFormData }
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: ProductoFormData }) =>
      servicioProductos.actualizarProducto(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
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
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Producto eliminado exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para buscar producto por código de barras
 */
export function useBuscarPorCodigoBarras(codigoBarras: string) {
  return useQuery({
    queryKey: [QUERY_KEY, "codigo-barras", codigoBarras],
    queryFn: () => servicioProductos.buscarPorCodigoBarras(codigoBarras),
    enabled: !!codigoBarras && codigoBarras.length > 0,
  });
}
