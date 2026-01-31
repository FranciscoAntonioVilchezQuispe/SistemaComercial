import { useState } from "react";

/**
 * Hook para guardar y recuperar valores del localStorage
 */
export function useLocalStorage<T>(
  clave: string,
  valorInicial: T,
): [T, (valor: T) => void] {
  // Obtener valor inicial del localStorage o usar el valor por defecto
  const [valorGuardado, setValorGuardado] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(clave);
      return item ? JSON.parse(item) : valorInicial;
    } catch (error) {
      console.error("Error al leer del localStorage:", error);
      return valorInicial;
    }
  });

  // Guardar en localStorage cuando el valor cambia
  const setValor = (valor: T) => {
    try {
      setValorGuardado(valor);
      window.localStorage.setItem(clave, JSON.stringify(valor));
    } catch (error) {
      console.error("Error al guardar en localStorage:", error);
    }
  };

  return [valorGuardado, setValor];
}
