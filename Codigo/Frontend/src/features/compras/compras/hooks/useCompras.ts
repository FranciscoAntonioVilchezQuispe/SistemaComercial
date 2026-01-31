import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { Compra, CompraFormData } from "../types/compra.types";
import * as servicio from "../servicios/servicioCompras";

export const useCompras = (): UseQueryResult<Compra[], Error> => {
  return useQuery({
    queryKey: ["compras"],
    queryFn: servicio.obtenerCompras,
  });
};

export const useCompra = (id: number): UseQueryResult<Compra, Error> => {
  return useQuery({
    queryKey: ["compras", id],
    queryFn: () => servicio.obtenerCompra(id),
    enabled: !!id,
  });
};

export const useRegistrarCompra = (): UseMutationResult<
  Compra,
  Error,
  CompraFormData
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.registrarCompra,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["compras"] });
      // También podríamos invalidar el stock si el backend lo actualiza inmediatamente
      queryClient.invalidateQueries({ queryKey: ["productos"] });
    },
  });
};

export const useConfirmarCompra = (): UseMutationResult<
  void,
  Error,
  number
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicio.confirmarCompra,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["compras"] });
    },
  });
};
