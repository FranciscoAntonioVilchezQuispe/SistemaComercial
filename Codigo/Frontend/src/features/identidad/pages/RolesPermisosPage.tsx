import { useState, useEffect } from "react";
import { Card } from "@/components/ui/card";
import { rolMenuService } from "../servicios/servicioRolMenu";
import { tipoPermisoService } from "../servicios/servicioTipoPermiso";
import type { RolMenu, TipoPermiso } from "@/types/permisos.types";
import { RolesList } from "../components/roles/RolesList";
import { PermisosMatrix } from "../components/roles/PermisosMatrix";
import { toast } from "sonner";

// Tipo temporal para Rol (debería venir del módulo existente)
interface Rol {
  id: number;
  nombreRol: string;
  descripcion?: string;
}

export function RolesPermisosPage() {
  const [roles, setRoles] = useState<Rol[]>([]);
  const [rolSeleccionado, setRolSeleccionado] = useState<Rol | null>(null);
  const [rolesMenus, setRolesMenus] = useState<RolMenu[]>([]);
  const [tiposPermiso, setTiposPermiso] = useState<TipoPermiso[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    cargarDatosIniciales();
  }, []);

  useEffect(() => {
    if (rolSeleccionado) {
      cargarPermisosDelRol(rolSeleccionado.id);
    }
  }, [rolSeleccionado]);

  const cargarDatosIniciales = async () => {
    try {
      setLoading(true);

      // Cargar tipos de permiso
      const permisos = await tipoPermisoService.obtenerTiposPermiso();
      setTiposPermiso(permisos);

      // Cargar roles (esto debería venir del servicio de roles existente)
      // Por ahora, simulamos con datos de ejemplo
      const rolesEjemplo: Rol[] = [
        { id: 1, nombreRol: "Administrador", descripcion: "Acceso total" },
        { id: 2, nombreRol: "Vendedor", descripcion: "Gestión de ventas" },
        {
          id: 3,
          nombreRol: "Almacenero",
          descripcion: "Gestión de inventario",
        },
      ];
      setRoles(rolesEjemplo);

      if (rolesEjemplo.length > 0) {
        setRolSeleccionado(rolesEjemplo[0]);
      }
    } catch (error) {
      console.error("Error al cargar datos:", error);
      toast.error("Error al cargar los datos");
    } finally {
      setLoading(false);
    }
  };

  const cargarPermisosDelRol = async (idRol: number) => {
    try {
      const data = await rolMenuService.obtenerMenusPorRol(idRol);
      setRolesMenus(data);
    } catch (error) {
      console.error("Error al cargar permisos del rol:", error);
      toast.error("Error al cargar los permisos del rol");
    }
  };

  const handleSeleccionarRol = (rol: Rol) => {
    setRolSeleccionado(rol);
  };

  const handleActualizarPermisos = () => {
    if (rolSeleccionado) {
      cargarPermisosDelRol(rolSeleccionado.id);
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
        <h1 className="text-3xl font-bold">Gestión de Roles y Permisos</h1>
        <p className="text-muted-foreground mt-1">
          Asigna menús y permisos específicos a cada rol del sistema
        </p>
      </div>

      <div className="grid grid-cols-12 gap-6">
        {/* Lista de Roles */}
        <div className="col-span-3">
          <RolesList
            roles={roles}
            rolSeleccionado={rolSeleccionado}
            onSeleccionar={handleSeleccionarRol}
          />
        </div>

        {/* Matriz de Permisos */}
        <div className="col-span-9">
          {rolSeleccionado ? (
            <PermisosMatrix
              rol={rolSeleccionado}
              rolesMenus={rolesMenus}
              tiposPermiso={tiposPermiso}
              onActualizar={handleActualizarPermisos}
            />
          ) : (
            <Card className="p-12 text-center">
              <p className="text-muted-foreground">
                Selecciona un rol para gestionar sus permisos
              </p>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
