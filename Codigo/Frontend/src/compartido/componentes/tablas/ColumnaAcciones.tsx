import { Edit, Trash2, Eye, MoreHorizontal } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface Accion {
  tipo: "ver" | "editar" | "eliminar" | "personalizado";
  etiqueta?: string;
  icono?: React.ReactNode;
  alClick: () => void;
  variante?: "default" | "destructive";
}

interface PropiedadesColumnaAcciones {
  acciones: Accion[];
  compacto?: boolean;
}

const iconosPorDefecto = {
  ver: <Eye className="h-4 w-4" />,
  editar: <Edit className="h-4 w-4" />,
  eliminar: <Trash2 className="h-4 w-4" />,
};

const etiquetasPorDefecto = {
  ver: "Ver",
  editar: "Editar",
  eliminar: "Eliminar",
};

export function ColumnaAcciones({
  acciones,
  compacto = false,
}: PropiedadesColumnaAcciones) {
  // Modo compacto: menú desplegable
  if (compacto) {
    return (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon" className="h-8 w-8">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          {acciones.map((accion, index) => {
            const icono =
              accion.icono ||
              (accion.tipo !== "personalizado"
                ? iconosPorDefecto[accion.tipo]
                : null);
            const etiqueta =
              accion.etiqueta ||
              (accion.tipo !== "personalizado"
                ? etiquetasPorDefecto[accion.tipo]
                : "");

            return (
              <div key={index}>
                {index > 0 && accion.tipo === "eliminar" && (
                  <DropdownMenuSeparator />
                )}
                <DropdownMenuItem
                  onClick={accion.alClick}
                  className={
                    accion.variante === "destructive" ? "text-destructive" : ""
                  }
                >
                  {icono && <span className="mr-2">{icono}</span>}
                  {etiqueta}
                </DropdownMenuItem>
              </div>
            );
          })}
        </DropdownMenuContent>
      </DropdownMenu>
    );
  }

  // Modo expandido: botones individuales
  return (
    <div className="flex items-center gap-1">
      {acciones.map((accion, index) => {
        const icono =
          accion.icono ||
          (accion.tipo !== "personalizado"
            ? iconosPorDefecto[accion.tipo]
            : null);

        return (
          <Button
            key={index}
            variant="ghost"
            size="icon"
            className="h-8 w-8"
            onClick={accion.alClick}
          >
            {icono}
          </Button>
        );
      })}
    </div>
  );
}
