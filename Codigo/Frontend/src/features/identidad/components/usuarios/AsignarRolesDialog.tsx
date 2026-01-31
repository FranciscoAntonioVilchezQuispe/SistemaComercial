import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Plus } from "lucide-react";
import { usuarioPermisoService } from "../../servicios/servicioUsuarioPermiso";
import type { UsuarioRol } from "@/types/permisos.types";
import { toast } from "sonner";

interface Usuario {
  id: number;
  nombreUsuario: string;
}

interface Rol {
  id: number;
  nombreRol: string;
  descripcion?: string;
}

interface AsignarRolesDialogProps {
  usuario: Usuario;
  rolesActuales: UsuarioRol[];
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onAsignar: () => void;
}

export function AsignarRolesDialog({
  usuario,
  rolesActuales,
  open,
  onOpenChange,
  onAsignar,
}: AsignarRolesDialogProps) {
  const [rolesDisponibles, setRolesDisponibles] = useState<Rol[]>([]);
  const [asignando, setAsignando] = useState(false);

  useEffect(() => {
    if (open) {
      cargarRolesDisponibles();
    }
  }, [open]);

  const cargarRolesDisponibles = () => {
    // Esto debería venir del servicio de roles existente
    // Por ahora, simulamos con datos de ejemplo
    const todosLosRoles: Rol[] = [
      { id: 1, nombreRol: "Administrador", descripcion: "Acceso total" },
      { id: 2, nombreRol: "Vendedor", descripcion: "Gestión de ventas" },
      { id: 3, nombreRol: "Almacenero", descripcion: "Gestión de inventario" },
      { id: 4, nombreRol: "Contador", descripcion: "Módulos contables" },
    ];

    // Filtrar roles ya asignados
    const idsAsignados = rolesActuales.map((ur) => ur.idRol);
    const disponibles = todosLosRoles.filter(
      (r) => !idsAsignados.includes(r.id),
    );

    setRolesDisponibles(disponibles);
  };

  const handleAsignarRol = async (idRol: number) => {
    try {
      setAsignando(true);
      await usuarioPermisoService.asignarRolAUsuario({
        idUsuario: usuario.id,
        idRol,
      });
      toast.success("Rol asignado exitosamente");
      onAsignar();
    } catch (error) {
      console.error("Error al asignar rol:", error);
      toast.error("Error al asignar el rol");
    } finally {
      setAsignando(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogTrigger asChild>
        <Button>
          <Plus className="mr-2 h-4 w-4" />
          Asignar Rol
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Asignar Rol a Usuario</DialogTitle>
          <DialogDescription>
            Selecciona un rol para asignar a {usuario.nombreUsuario}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-2 max-h-96 overflow-y-auto">
          {rolesDisponibles.length === 0 ? (
            <p className="text-center text-muted-foreground py-4">
              Todos los roles ya están asignados a este usuario
            </p>
          ) : (
            rolesDisponibles.map((rol) => (
              <Button
                key={rol.id}
                variant="outline"
                className="w-full justify-start h-auto py-3"
                onClick={() => handleAsignarRol(rol.id)}
                disabled={asignando}
              >
                <div className="text-left">
                  <div className="font-medium">{rol.nombreRol}</div>
                  {rol.descripcion && (
                    <div className="text-xs text-muted-foreground">
                      {rol.descripcion}
                    </div>
                  )}
                </div>
              </Button>
            ))
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
