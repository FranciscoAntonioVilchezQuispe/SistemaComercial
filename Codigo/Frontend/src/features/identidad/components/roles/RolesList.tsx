import { Card } from "@/components/ui/card";
import { Shield } from "lucide-react";
import { cn } from "@/lib/utils";

interface Rol {
  id: number;
  nombreRol: string;
  descripcion?: string;
}

interface RolesListProps {
  roles: Rol[];
  rolSeleccionado: Rol | null;
  onSeleccionar: (rol: Rol) => void;
}

export function RolesList({
  roles,
  rolSeleccionado,
  onSeleccionar,
}: RolesListProps) {
  return (
    <Card className="p-4">
      <div className="mb-4">
        <h3 className="font-semibold text-lg">Roles</h3>
        <p className="text-sm text-muted-foreground">Selecciona un rol</p>
      </div>

      <div className="space-y-2">
        {roles.map((rol) => (
          <button
            key={rol.id}
            onClick={() => onSeleccionar(rol)}
            className={cn(
              "w-full text-left p-3 rounded-lg transition-colors",
              "hover:bg-accent",
              rolSeleccionado?.id === rol.id &&
                "bg-primary text-primary-foreground hover:bg-primary/90",
            )}
          >
            <div className="flex items-center gap-2">
              <Shield className="h-4 w-4" />
              <div className="flex-1 min-w-0">
                <div className="font-medium truncate">{rol.nombreRol}</div>
                {rol.descripcion && (
                  <div className="text-xs opacity-80 truncate">
                    {rol.descripcion}
                  </div>
                )}
              </div>
            </div>
          </button>
        ))}
      </div>
    </Card>
  );
}
