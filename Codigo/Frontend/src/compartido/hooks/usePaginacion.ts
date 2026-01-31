import { useState } from "react";

export interface OpcionesPaginacion {
  paginaActual: number;
  elementosPorPagina: number;
  totalElementos: number;
}

export interface ControlPaginacion {
  paginaActual: number;
  elementosPorPagina: number;
  totalPaginas: number;
  irAPagina: (pagina: number) => void;
  paginaSiguiente: () => void;
  paginaAnterior: () => void;
  cambiarElementosPorPagina: (cantidad: number) => void;
  obtenerIndiceInicio: () => number;
  obtenerIndiceFin: () => number;
}

/**
 * Hook para manejar paginación
 */
export function usePaginacion(
  totalElementos: number,
  elementosPorPaginaInicial: number = 10,
): ControlPaginacion {
  const [paginaActual, setPaginaActual] = useState(1);
  const [elementosPorPagina, setElementosPorPagina] = useState(
    elementosPorPaginaInicial,
  );

  const totalPaginas = Math.ceil(totalElementos / elementosPorPagina);

  const irAPagina = (pagina: number) => {
    const paginaValida = Math.max(1, Math.min(pagina, totalPaginas));
    setPaginaActual(paginaValida);
  };

  const paginaSiguiente = () => {
    irAPagina(paginaActual + 1);
  };

  const paginaAnterior = () => {
    irAPagina(paginaActual - 1);
  };

  const cambiarElementosPorPagina = (cantidad: number) => {
    setElementosPorPagina(cantidad);
    setPaginaActual(1); // Resetear a la primera página
  };

  const obtenerIndiceInicio = () => {
    return (paginaActual - 1) * elementosPorPagina;
  };

  const obtenerIndiceFin = () => {
    return Math.min(paginaActual * elementosPorPagina, totalElementos);
  };

  return {
    paginaActual,
    elementosPorPagina,
    totalPaginas,
    irAPagina,
    paginaSiguiente,
    paginaAnterior,
    cambiarElementosPorPagina,
    obtenerIndiceInicio,
    obtenerIndiceFin,
  };
}
