import { Outlet } from "react-router-dom";

export function LayoutPOS() {
  return (
    <div className="min-h-screen bg-background">
      {/* Header minimalista para POS */}
      <header className="sticky top-0 z-50 w-full border-b bg-background">
        <div className="flex h-14 items-center px-4">
          <div className="flex items-center gap-2">
            <div className="h-8 w-8 rounded-lg bg-primary flex items-center justify-center">
              <span className="text-primary-foreground font-bold text-sm">
                POS
              </span>
            </div>
            <span className="font-semibold">Punto de Venta</span>
          </div>

          <div className="ml-auto flex items-center gap-2">
            <span className="text-sm text-muted-foreground">
              Usuario: Admin
            </span>
          </div>
        </div>
      </header>

      {/* Contenido POS a pantalla completa */}
      <main className="h-[calc(100vh-3.5rem)]">
        <Outlet />
      </main>
    </div>
  );
}
