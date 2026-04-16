import { Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "@/features/identidad/context/AuthContext";
import { Button } from "@/componentes/ui/button";
import { LogOut, Store } from "lucide-react";

export function LayoutPOS() {
  const { usuario, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col">
      {/* Header minimalista para POS */}
      <header className="sticky top-0 z-50 w-full border-b bg-white/80 dark:bg-slate-900/80 backdrop-blur-md">
        <div className="flex h-16 items-center px-6">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-xl bg-primary flex items-center justify-center shadow-lg shadow-primary/20">
              <Store className="text-white h-6 w-6" />
            </div>
            <div>
                <h1 className="font-bold text-lg leading-none">Punto de Venta</h1>
                <p className="text-[10px] text-muted-foreground uppercase tracking-wider font-semibold">Sistema Comercial v1.0</p>
            </div>
          </div>

          <div className="ml-auto flex items-center gap-6">
            <div className="hidden md:flex flex-col items-end">
              <span className="text-sm font-bold text-slate-700 dark:text-slate-200">
                {usuario?.nombres} {usuario?.apellidos}
              </span>
              <span className="text-[10px] bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 px-2 py-0.5 rounded-full font-bold uppercase">
                En Línea
              </span>
            </div>
            
            <div className="h-8 w-[1px] bg-slate-200 dark:bg-slate-800" />
            
            <Button 
                variant="ghost" 
                size="icon" 
                className="text-slate-500 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-950/20 transition-colors"
                onClick={handleLogout}
            >
              <LogOut className="h-5 w-5" />
            </Button>
          </div>
        </div>
      </header>

      {/* Contenido POS a pantalla completa */}
      <main className="flex-1 overflow-hidden p-4">
        <Outlet />
      </main>
    </div>
  );
}
