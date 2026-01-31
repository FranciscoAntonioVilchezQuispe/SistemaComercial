import { useState, useEffect } from "react";

/**
 * Hook para debounce de valores
 * Útil para búsquedas y filtros
 */
export function useDebounce<T>(valor: T, delay: number = 500): T {
  const [valorDebounced, setValorDebounced] = useState<T>(valor);

  useEffect(() => {
    const handler = setTimeout(() => {
      setValorDebounced(valor);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [valor, delay]);

  return valorDebounced;
}
