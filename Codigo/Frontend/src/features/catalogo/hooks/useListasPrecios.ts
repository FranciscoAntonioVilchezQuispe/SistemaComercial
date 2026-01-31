import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { servicioListasPrecios } from "../servicios/servicioListasPrecios";
import { ListaPrecioFormData } from "../tipos/catalogo.types";
import { manejadorErrores } from "@/lib/axios/manejadorErrores";

const QUERY_KEY = "listas-precios";

export function useListasPrecios(activo?: boolean) {
  return useQuery({
    queryKey: [QUERY_KEY, activo],
    queryFn: () => servicioListasPrecios.obtenerListas(activo),
  });
}

export function useCrearListaPrecio() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (datos: ListaPrecioFormData) =>
      servicioListasPrecios.crearLista(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Lista de precios creada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

export function useActualizarListaPrecio() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, datos }: { id: number; datos: ListaPrecioFormData }) =>
      servicioListasPrecios.actualizarLista(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Lista de precios actualizada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}

export function useEliminarListaPrecio() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: number) => servicioListasPrecios.eliminarLista(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      toast.success("Lista de precios eliminada exitosamente");
    },
    onError: (error) => {
      manejadorErrores(error);
    },
  });
}
