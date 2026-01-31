import { useState } from "react";
import { PagedRequest } from "../types/pagination.types";

export function usePagination(initialState?: Partial<PagedRequest>) {
  const [paginacion, setPaginacion] = useState<PagedRequest>({
    pageNumber: 1,
    pageSize: 10,
    sortBy: undefined,
    sortDirection: "asc",
    search: "",
    activo: null, // null for 'all', true for active, false for inactive
    ...initialState,
  });

  const cambiarPagina = (pageNumber: number) => {
    setPaginacion((prev) => ({ ...prev, pageNumber }));
  };

  const cambiarPageSize = (pageSize: number) => {
    setPaginacion((prev) => ({ ...prev, pageSize, pageNumber: 1 }));
  };

  const cambiarBusqueda = (search: string) => {
    setPaginacion((prev) => ({ ...prev, search, pageNumber: 1 }));
  };

  const cambiarFiltroActivo = (activo: boolean | null) => {
    setPaginacion((prev) => ({ ...prev, activo, pageNumber: 1 }));
  };

  return {
    paginacion,
    setPaginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  };
}
