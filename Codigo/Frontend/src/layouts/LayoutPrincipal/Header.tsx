import { Menu, Bell, User, LayoutGrid } from "lucide-react";
import { useLocation } from "react-router-dom";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Badge } from "@/components/ui/badge";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

interface PropiedadesHeader {
  alAlternarSidebar: () => void;
}

export function Header({ alAlternarSidebar }: PropiedadesHeader) {
  const { pathname } = useLocation();
  const notificacionesPendientes = 3;

  // Obtener título dinámico del mapa de rutas
  const tituloPagina = RUTAS_TITULOS[pathname] || "";

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 h-[44px]">
      <div className="flex h-full items-center px-4 justify-between">
        {/* IZQUIERDA: Botón menú y Título dinámico */}
        <div className="flex items-center gap-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={alAlternarSidebar}
            className="h-8 w-8"
          >
            <Menu className="h-4 w-4" />
          </Button>
          <h1 className="text-[15px] font-medium text-primary uppercase tracking-tight">
            {tituloPagina}
          </h1>
        </div>

        {/* DERECHA: Logo y Acciones */}
        <div className="flex items-center gap-4">
          {/* Logo/Nombre Sistema */}
          <div className="flex items-center gap-2 border-r pr-4 mr-2 border-border/50">
            <div className="h-6 w-6 rounded bg-primary flex items-center justify-center">
              <LayoutGrid className="h-4 w-4 text-primary-foreground" />
            </div>
            <span className="font-bold text-sm tracking-tighter hidden sm:inline-block">
              SistemaComercial
            </span>
          </div>

          {/* Acciones */}
          <div className="flex items-center gap-1">
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="relative h-8 w-8">
                  <Bell className="h-4 w-4" />
                  {notificacionesPendientes > 0 && (
                    <Badge
                      variant="destructive"
                      className="absolute -top-0.5 -right-0.5 h-4 w-4 flex items-center justify-center p-0 text-[10px]"
                    >
                      {notificacionesPendientes}
                    </Badge>
                  )}
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-80">
                <DropdownMenuLabel>Notificaciones</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem>
                  <div className="flex flex-col gap-1">
                    <p className="text-sm font-medium">Stock bajo</p>
                    <p className="text-xs text-muted-foreground">
                      3 productos con stock bajo
                    </p>
                  </div>
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="h-8 w-8">
                  <User className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuLabel>Mi Cuenta</DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem>Perfil</DropdownMenuItem>
                <DropdownMenuItem>Configuración</DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem className="text-destructive font-medium">
                  Cerrar Sesión
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
    </header>
  );
}
