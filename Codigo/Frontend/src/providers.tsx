import React from "react";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Provider } from "react-redux";
import { store } from "./app/store";

import { ErrorBoundary } from "./compartido/componentes/feedback/ErrorBoundary";
import { capturadorErrores } from "./compartido/utilidades/capturadorErrores";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      throwOnError: false, // Manejado por interceptores de Axios y logs globales
    },
    mutations: {
      onError: (error) => {
        capturadorErrores.capturar(error, 'API', { componente: 'ReactQueryMutation' });
      }
    }
  }
});

// Registro de escuchas globales para errores fuera del ciclo de vida de React
if (typeof window !== 'undefined') {
  window.onerror = (message, source, lineno, colno, error) => {
    capturadorErrores.capturar(error || message, 'GENERIC', {
      metadata: { source, lineno, colno }
    });
  };

  window.onunhandledrejection = (event) => {
    capturadorErrores.capturar(event.reason, 'PROMISE');
  };
}

import { AuthProvider } from "./features/identidad/context/AuthContext";

export const AppProviders = ({ children }: { children: React.ReactNode }) => {
  return (
    <React.StrictMode>
      <ErrorBoundary>
        <Provider store={store}>
          <QueryClientProvider client={queryClient}>
            <AuthProvider>
              {children}
            </AuthProvider>
          </QueryClientProvider>
        </Provider>
      </ErrorBoundary>
    </React.StrictMode>
  );
};
