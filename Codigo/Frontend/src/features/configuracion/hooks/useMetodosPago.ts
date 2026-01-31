import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioMetodoPago } from "../servicios/servicioMetodoPago";
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";

export const useMetodosPago = (): UseQueryResult<MetodoPago[], Error> => {
  return useQuery<MetodoPago[], Error>({
    queryKey: ["metodos-pago"],
    queryFn: servicioMetodoPago.obtenerTodos,
  });
};

export const useCrearMetodoPago = (): UseMutationResult<
  MetodoPago,
  Error,
  MetodoPagoFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioMetodoPago.crear,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["metodos-pago"] });
    },
  });
};

export const useActualizarMetodoPago = (): UseMutationResult<
  MetodoPago,
  Error,
  { id: number; datos: MetodoPagoFormData },
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, datos }) => servicioMetodoPago.actualizar(id, datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["metodos-pago"] });
    },
  });
};

export const useEliminarMetodoPago = (): UseMutationResult<
  void,
  Error,
  number,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: servicioMetodoPago.eliminar,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["metodos-pago"] });
    },
  });
};
