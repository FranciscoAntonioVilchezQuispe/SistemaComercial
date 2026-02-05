import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import {
  obtenerOrdenesCompra,
  obtenerOrdenCompra,
  registrarOrdenCompra,
} from "../servicios/ordenCompraService";
import { OrdenCompraFormData } from "../types/ordenCompra.types";

export const useOrdenesCompra = () => {
  return useQuery({
    queryKey: ["ordenes-compra"],
    queryFn: obtenerOrdenesCompra,
  });
};

export const useOrdenCompra = (id: number) => {
  return useQuery({
    queryKey: ["ordenes-compra", id],
    queryFn: () => obtenerOrdenCompra(id),
    enabled: !!id,
  });
};

export const useRegistrarOrdenCompra = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: OrdenCompraFormData) => registrarOrdenCompra(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ordenes-compra"] });
    },
  });
};
