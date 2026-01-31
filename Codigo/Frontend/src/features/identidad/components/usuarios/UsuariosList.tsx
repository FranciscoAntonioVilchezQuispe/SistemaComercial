import { Card } from "@/components/ui/card";
import { User } from "lucide-react";
import { cn } from "@/lib/utils";

interface Usuario {
  id: number;
  nombreUsuario: string;
  email?: string;
}

interface UsuariosListProps {
  usuarios: Usuario[];
  usuarioSeleccionado: Usuario | null;
  onSeleccionar: (usuario: Usuario) => void;
}

export function UsuariosList({
  usuarios,
  usuarioSeleccionado,
  onSeleccionar,
}: UsuariosListProps) {
  return (
    <Card className="p-4">
      <div className="mb-4">
        <h3 className="font-semibold text-lg">Usuarios</h3>
        <p className="text-sm text-muted-foreground">Selecciona un usuario</p>
      </div>

      <div className="space-y-2">
        {usuarios.map((usuario) => (
          <button
            key={usuario.id}
            onClick={() => onSeleccionar(usuario)}
            className={cn(
              "w-full text-left p-3 rounded-lg transition-colors",
              "hover:bg-accent",
              usuarioSeleccionado?.id === usuario.id &&
                "bg-primary text-primary-foreground hover:bg-primary/90",
            )}
          >
            <div className="flex items-center gap-2">
              <User className="h-4 w-4" />
              <div className="flex-1 min-w-0">
                <div className="font-medium truncate">
                  {usuario.nombreUsuario}
                </div>
                {usuario.email && (
                  <div className="text-xs opacity-80 truncate">
                    {usuario.email}
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
