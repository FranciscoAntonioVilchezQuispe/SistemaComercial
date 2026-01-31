import { useState } from "react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Plus, Trash2, Menu as MenuIcon } from "lucide-react";
import { usuarioPermisoService } from "../../servicios/servicioUsuarioPermiso";
import type { UsuarioRol, Menu } from "@/types/permisos.types";
import { AsignarRolesDialog } from "./AsignarRolesDialog";
import { toast } from "sonner";

interface Usuario {
  id: number;
  nombreUsuario: string;
}

interface RolesAsignadosProps {
  usuario: Usuario;
  rolesAsignados: UsuarioRol[];
  menusDisponibles: Menu[];
  onActualizar: () => void;
}

export function RolesAsignados({
  usuario,
  rolesAsignados,
  menusDisponibles,
  onActualizar,
}: RolesAsignadosProps) {
  const [showAsignarDialog, setShowAsignarDialog] = useState(false);

  const handleQuitarRol = async (idUsuarioRol: number) => {
    if (!confirm("¿Está seguro de quitar este rol del usuario?")) return;

    try {
      await usuarioPermisoService.quitarRolDeUsuario(usuario.id, idUsuarioRol);
      toast.success("Rol quitado del usuario");
      onActualizar();
    } catch (error) {
      console.error("Error al quitar rol:", error);
      toast.error("Error al quitar el rol");
    }
  };

  const handleAsignarRol = () => {
    setShowAsignarDialog(false);
    onActualizar();
  };

  return (
    <div className="space-y-6">
      {/* Roles Asignados */}
      <Card className="p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-xl font-semibold">
              Usuario: {usuario.nombreUsuario}
            </h3>
            <p className="text-sm text-muted-foreground">Roles asignados</p>
          </div>

          <AsignarRolesDialog
            usuario={usuario}
            rolesActuales={rolesAsignados}
            open={showAsignarDialog}
            onOpenChange={setShowAsignarDialog}
            onAsignar={handleAsignarRol}
          />
        </div>

        {rolesAsignados.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-muted-foreground">
              Este usuario no tiene roles asignados
            </p>
            <Button
              variant="outline"
              className="mt-4"
              onClick={() => setShowAsignarDialog(true)}
            >
              <Plus className="mr-2 h-4 w-4" />
              Asignar Primer Rol
            </Button>
          </div>
        ) : (
          <div className="space-y-2">
            {rolesAsignados.map((usuarioRol) => (
              <div
                key={usuarioRol.id}
                className="flex items-center justify-between p-3 border rounded-lg"
              >
                <div>
                  <span className="font-medium">
                    {usuarioRol.rol?.nombreRol || "Rol Desconocido"}
                  </span>
                  {usuarioRol.rol?.descripcion && (
                    <p className="text-sm text-muted-foreground">
                      {usuarioRol.rol.descripcion}
                    </p>
                  )}
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => handleQuitarRol(usuarioRol.id)}
                >
                  <Trash2 className="h-4 w-4 text-destructive" />
                </Button>
              </div>
            ))}
            <Button
              variant="outline"
              className="w-full"
              onClick={() => setShowAsignarDialog(true)}
            >
              <Plus className="mr-2 h-4 w-4" />
              Asignar Otro Rol
            </Button>
          </div>
        )}
      </Card>

      {/* Vista Previa de Menús Disponibles */}
      <Card className="p-6">
        <h3 className="text-lg font-semibold mb-4">Menús Disponibles</h3>
        <p className="text-sm text-muted-foreground mb-4">
          Basado en los roles asignados, este usuario tiene acceso a los
          siguientes menús:
        </p>

        {menusDisponibles.length === 0 ? (
          <p className="text-center text-muted-foreground py-4">
            Sin menús disponibles
          </p>
        ) : (
          <div className="grid grid-cols-2 gap-3">
            {menusDisponibles.map((menu) => (
              <div
                key={menu.id}
                className="flex items-center gap-2 p-3 border rounded-lg"
              >
                <MenuIcon className="h-4 w-4 text-primary" />
                <div className="flex-1 min-w-0">
                  <div className="font-medium truncate">{menu.nombre}</div>
                  <div className="text-xs text-muted-foreground truncate">
                    {menu.ruta || menu.codigo}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}
