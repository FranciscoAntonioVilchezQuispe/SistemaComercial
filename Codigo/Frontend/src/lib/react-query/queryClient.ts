import { QueryClient } from "@tanstack/react-query";

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Tiempo que los datos se consideran "frescos" (5 minutos)
      staleTime: 1000 * 60 * 5,
      // Tiempo que los datos inactivos permanecen en caché (10 minutos)
      gcTime: 1000 * 60 * 10,
      // Reintentar una vez en caso de error
      retry: 1,
      // No refetch automático al enfocar la ventana en desarrollo
      refetchOnWindowFocus: process.env.NODE_ENV === "production",
      // Refetch al reconectar
      refetchOnReconnect: true,
    },
    mutations: {
      // Reintentar mutaciones fallidas una vez
      retry: 1,
    },
  },
});
