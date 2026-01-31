import { Outlet } from "react-router-dom";

export function LayoutAutenticacion() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary/10 via-background to-secondary/10">
      <div className="w-full max-w-md p-6">
        {/* Logo y título */}
        <div className="text-center mb-8">
          <div className="inline-flex h-16 w-16 rounded-2xl bg-primary items-center justify-center mb-4">
            <span className="text-primary-foreground font-bold text-2xl">
              SC
            </span>
          </div>
          <h1 className="text-2xl font-bold">Sistema Comercial</h1>
          <p className="text-muted-foreground mt-2">
            Gestión integral para tu negocio
          </p>
        </div>

        {/* Contenido (formularios de login, registro, etc.) */}
        <Outlet />

        {/* Footer */}
        <div className="text-center mt-8 text-sm text-muted-foreground">
          <p>© {new Date().getFullYear()} Sistema Comercial</p>
        </div>
      </div>
    </div>
  );
}
