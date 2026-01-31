import { useState, useEffect, useRef } from "react";
import { Outlet } from "react-router-dom";
import { Header } from "./Header";
import { Sidebar } from "./Sidebar";
import { Footer } from "./Footer";

export function LayoutPrincipal() {
  const [sidebarAbierto, setSidebarAbierto] = useState(true);
  const timeoutRef = useRef<NodeJS.Timeout | null>(null);

  const alternarSidebar = () => {
    setSidebarAbierto(!sidebarAbierto);
  };

  // Cerrar sidebar automáticamente después de 5 segundos cuando se abre
  useEffect(() => {
    // Limpiar timeout anterior si existe
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
      timeoutRef.current = null;
    }

    // Si el sidebar está abierto, programar el cierre automático
    if (sidebarAbierto) {
      timeoutRef.current = setTimeout(() => {
        setSidebarAbierto(false);
      }, 5000); // 5 segundos
    }

    // Limpiar timeout al desmontar o cuando cambie el estado
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [sidebarAbierto]);

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <Header alAlternarSidebar={alternarSidebar} />

      {/* Contenido principal con Sidebar */}
      <div className="flex flex-1">
        {/* Sidebar */}
        <Sidebar abierto={sidebarAbierto} />

        {/* Área de contenido */}
        <main
          className={`flex-1 transition-all duration-300 ${
            sidebarAbierto ? "ml-64" : "ml-16"
          }`}
        >
          <div className="container mx-auto p-6">
            <Outlet />
          </div>
        </main>
      </div>

      {/* Footer */}
      <Footer />
    </div>
  );
}
