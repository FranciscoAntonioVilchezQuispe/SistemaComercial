import { useState, useEffect } from "react";
import { Card } from "@/components/ui/card";
import { usuarioPermisoService } from "../servicios/servicioUsuarioPermiso";
import type { UsuarioRol, Menu } from "@/types/permisos.types";
import { UsuariosList } from "../components/usuarios/UsuariosList";
import { RolesAsignados } from "../components/usuarios/RolesAsignados";
import { toast } from "sonner";

// Tipo temporal para Usuario (debería venir del módulo existente)
interface Usuario {
  id: number;
  nombreUsuario: string;
  email?: string;
}

export function UsuariosRolesPage() {
  const [usuarios, setUsuarios] = useState<Usuario[]>([]);
  const [usuarioSeleccionado, setUsuarioSeleccionado] =
    useState<Usuario | null>(null);
  const [rolesAsignados, setRolesAsignados] = useState<UsuarioRol[]>([]);
  const [menusDisponibles, setMenusDisponibles] = useState<Menu[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    cargarUsuarios();
  }, []);

  useEffect(() => {
    if (usuarioSeleccionado) {
      cargarDatosDelUsuario(usuarioSeleccionado.id);
    }
  }, [usuarioSeleccionado]);

  const cargarUsuarios = async () => {
    try {
      setLoading(true);

      // Esto debería venir del servicio de usuarios existente
      // Por ahora, simulamos con datos de ejemplo
      const usuariosEjemplo: Usuario[] = [
        { id: 1, nombreUsuario: "admin", email: "admin@example.com" },
        { id: 2, nombreUsuario: "vendedor1", email: "vendedor@example.com" },
        { id: 3, nombreUsuario: "almacenero1", email: "almacen@example.com" },
      ];
      setUsuarios(usuariosEjemplo);

      if (usuariosEjemplo.length > 0) {
        setUsuarioSeleccionado(usuariosEjemplo[0]);
      }
    } catch (error) {
      console.error("Error al cargar usuarios:", error);
      toast.error("Error al cargar los usuarios");
    } finally {
      setLoading(false);
    }
  };

  const cargarDatosDelUsuario = async (idUsuario: number) => {
    try {
      const [roles, menus] = await Promise.all([
        usuarioPermisoService.obtenerRolesDeUsuario(idUsuario),
        usuarioPermisoService.obtenerMenusDisponibles(idUsuario),
      ]);

      setRolesAsignados(roles);
      setMenusDisponibles(menus);
    } catch (error) {
      console.error("Error al cargar datos del usuario:", error);
      toast.error("Error al cargar los datos del usuario");
    }
  };

  const handleSeleccionarUsuario = (usuario: Usuario) => {
    setUsuarioSeleccionado(usuario);
  };

  const handleActualizarRoles = () => {
    if (usuarioSeleccionado) {
      cargarDatosDelUsuario(usuarioSeleccionado.id);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Asignación de Roles a Usuarios</h1>
        <p className="text-muted-foreground mt-1">
          Gestiona los roles asignados a cada usuario del sistema
        </p>
      </div>

      <div className="grid grid-cols-12 gap-6">
        {/* Lista de Usuarios */}
        <div className="col-span-3">
          <UsuariosList
            usuarios={usuarios}
            usuarioSeleccionado={usuarioSeleccionado}
            onSeleccionar={handleSeleccionarUsuario}
          />
        </div>

        {/* Roles Asignados y Vista Previa */}
        <div className="col-span-9">
          {usuarioSeleccionado ? (
            <RolesAsignados
              usuario={usuarioSeleccionado}
              rolesAsignados={rolesAsignados}
              menusDisponibles={menusDisponibles}
              onActualizar={handleActualizarRoles}
            />
          ) : (
            <Card className="p-12 text-center">
              <p className="text-muted-foreground">
                Selecciona un usuario para gestionar sus roles
              </p>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
