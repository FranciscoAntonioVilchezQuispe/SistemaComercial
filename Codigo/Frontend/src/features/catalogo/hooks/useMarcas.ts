import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioMarcas } from "../servicios/servicioMarcas";
import { Marca, MarcaFormData } from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";
import { PagedRequest, PagedResponse } from "@/types/pagination.types";

const QUERY_KEY = "marcas";

/**
 * Hook para obtener todas las marcas paginadas
 */
export function useMarcas(
  req?: PagedRequest,
): UseQueryResult<PagedResponse<Marca>, Error> {
  return useQuery({
    queryKey: [QUERY_KEY, req],
    queryFn: () => servicioMarcas.obtenerMarcas(req),
  });
}

/**
 * Hook para obtener una marca por ID
 */
export function useMarca(id: number) {
  return useQuery({
    queryKey: [QUERY_KEY, id],
    queryFn: () => servicioMarcas.obtenerMarcaPorId(id),
    enabled: !!id,
  });
}

/**
 * Hook para crear una marca
 */
export function useCrearMarca(): UseMutationResult<
  Marca,
  Error,
  MarcaFormData,
  unknown
> {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: MarcaFormData) => servicioMarcas.crearMarca(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Marca creada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para actualizar una marca
 */
export function useActualizarMarca() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: MarcaFormData }) =>
      servicioMarcas.actualizarMarca(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Marca actualizada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

/**
 * Hook para eliminar una marca
 */
export function useEliminarMarca() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioMarcas.eliminarMarca(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Marca eliminada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}
