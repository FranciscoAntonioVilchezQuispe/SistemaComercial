import { PackageOpen } from "lucide-react";
import { Card } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface PropiedadesEstadoVacio {
  titulo: string;
  descripcion?: string;
  icono?: React.ReactNode;
  accion?: React.ReactNode;
  className?: string;
}

export function EstadoVacio({
  titulo,
  descripcion,
  icono,
  accion,
  className,
}: PropiedadesEstadoVacio) {
  return (
    <Card className={cn("p-12 text-center", className)}>
      <div className="flex flex-col items-center space-y-4">
        {icono || <PackageOpen className="h-16 w-16 text-muted-foreground" />}
        <div className="space-y-2">
          <h3 className="text-lg font-semibold">{titulo}</h3>
          {descripcion && (
            <p className="text-muted-foreground">{descripcion}</p>
          )}
        </div>
        {accion && <div className="mt-4">{accion}</div>}
      </div>
    </Card>
  );
}
