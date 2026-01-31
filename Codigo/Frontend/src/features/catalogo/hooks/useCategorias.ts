import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioCategorias } from "../servicios/servicioCategorias";
import { CategoriaFormData } from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "categorias";

import { PagedRequest } from "@/types/pagination.types";
import { UseQueryResult, UseMutationResult } from "@tanstack/react-query";
import { RespuestaCategorias, Categoria } from "../tipos/catalogo.types";

/**
 * Hook para obtener todas las categorías
 */
export function useCategorias(
  params: Partial<PagedRequest>,
): UseQueryResult<RespuestaCategorias, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, params],
    queryFn: () =>
      servicioCategorias.obtenerCategorias(
        params.pageNumber,
        params.pageSize,
        params.search,
        params.activo,
      ),
    placeholderData: (previousData) => previousData, // Keep previous data while fetching
  });
}

/**
 * Hook para obtener categorías jerárquicas
 */
export function useCategoriasJerarquicas() {
  return useQuery({
    queryKey: [QUERY_KEY, "jerarquicas"],
    queryFn: () => servicioCategorias.obtenerCategoriasJerarquicas(),
  });
}

/**
 * Hook para obtener una categoría por ID
 */
export function useCategoria(id: number) {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioCategorias.obtenerCategoriaPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para crear una categoría
 */
export function useCrearCategoria() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: CategoriaFormData) =>
      servicioCategorias.crearCategoria(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Categoría creada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para actualizar una categoría
 */
export function useActualizarCategoria(): UseMutationResult<
  Categoria,
  Error,
  { id: number; datos: CategoriaFormData }
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: CategoriaFormData }) =>
      servicioCategorias.actualizarCategoria(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Categoría actualizada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para eliminar una categoría
 */
export function useEliminarCategoria() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioCategorias.eliminarCategoria(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Categoría eliminada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}
