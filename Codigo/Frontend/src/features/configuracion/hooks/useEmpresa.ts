import {
  useQuery,
  useMutation,
  useQueryClient,
  UseQueryResult,
  UseMutationResult,
} from "@tanstack/react-query";
import { servicioEmpresa } from "../servicios/servicioEmpresa";
import { Empresa, EmpresaFormData } from "../tipos/empresa.types";

export const useEmpresa = (): UseQueryResult<Empresa, Error> => {
  return useQuery<Empresa, Error>({
    queryKey: ["empresa"],
    queryFn: servicioEmpresa.obtenerEmpresa,
    retry: 1, // Fail fast if 404
  });
};

export const useActualizarEmpresa = (): UseMutationResult<
  Empresa,
  Error,
  EmpresaFormData,
  unknown
> => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (datos: EmpresaFormData) =>
      servicioEmpresa.actualizarEmpresa(datos),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["empresa"] });
    },
  });
};
