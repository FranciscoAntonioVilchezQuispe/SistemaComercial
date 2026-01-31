import { useState } from "react";
import { Plus, Edit2, Trash2, MapPin } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  useSucursales,
  useCrearSucursal,
  useActualizarSucursal,
  useEliminarSucursal,
} from "../hooks/useSucursales";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";
import { SucursalForm } from "../componentes/SucursalForm";
import { toast } from "sonner";
import { useEmpresa } from "../hooks/useEmpresa";

export function PaginaSucursales() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [registroSeleccionado, setRegistroSeleccionado] =
    useState<Sucursal | null>(null);

  const { data: sucursales, isLoading, error } = useSucursales();
  const { data: empresa } = useEmpresa(); // Needed to set default idEmpresa

  const crearMutation = useCrearSucursal();
  const actualizarMutation = useActualizarSucursal();
  const eliminarMutation = useEliminarSucursal();

  const handleCrear = () => {
    setRegistroSeleccionado(null);
    setDialogoOpen(true);
  };

  const handleEditar = (sucursal: Sucursal) => {
    setRegistroSeleccionado(sucursal);
    setDialogoOpen(true);
  };

  const handleEliminar = (sucursal: Sucursal) => {
    if (
      confirm(
        `¿Está seguro de eliminar la sucursal ${sucursal.nombreSucursal}?`,
      )
    ) {
      eliminarMutation.mutate(sucursal.id, {
        onSuccess: () => toast.success("Sucursal eliminada"),
        onError: () => toast.error("Error al eliminar sucursal"),
      });
    }
  };

  const handleGuardar = (datos: SucursalFormData) => {
    // Ensure idEmpresa is set if missing (e.g. creating new)
    if (!datos.idEmpresa && empresa) {
      datos.idEmpresa = empresa.id;
    }

    if (registroSeleccionado) {
      actualizarMutation.mutate(
        { id: registroSeleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Sucursal actualizada");
            setDialogoOpen(false);
          },
          onError: (err) => toast.error("Error al actualizar: " + err.message),
        },
      );
    } else {
      crearMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Sucursal creada");
          setDialogoOpen(false);
        },
        onError: (err) => toast.error("Error al crear: " + err.message),
      });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando sucursales..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Nombre",
      accessorKey: "nombreSucursal" as keyof Sucursal,
      className: "font-semibold",
    },
    {
      header: "Dirección",
      accessorKey: "direccion" as keyof Sucursal,
      cell: (row: Sucursal) => (
        <div className="flex items-center gap-1">
          <MapPin className="h-3 w-3 text-muted-foreground" />
          <span>{row.direccion || "-"}</span>
        </div>
      ),
    },
    { header: "Teléfono", accessorKey: "telefono" as keyof Sucursal },
    {
      header: "Principal",
      accessorKey: "esPrincipal" as keyof Sucursal,
      cell: (row: Sucursal) =>
        row.esPrincipal ? (
          <span className="inline-flex items-center rounded-full border border-primary text-primary px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2">
            Principal
          </span>
        ) : null,
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Sucursal) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleEditar(row)}
            title="Editar"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminar(row)}
            title="Eliminar"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Sucursales</h1>
        <p className="text-muted-foreground">
          Gestión de tiendas, almacenes y puntos de venta.
        </p>
      </div>

      <DataTable
        data={sucursales || []}
        columns={columns}
        // Pagination logic not implemented in hook yet, passing simple structure if needed or just data
        // DataTable expects pagination object if we want pagination controls at bottom.
        // For now, passing undefined pagination or handling client side pagination if DataTable supports it.
        // Assuming DataTable component handles simple array if pagination prop is missing or we can ignore it for < 10 items.

        actionElement={
          <Button onClick={handleCrear}>
            <Plus className="mr-2 h-4 w-4" /> Nueva Sucursal
          </Button>
        }
      />

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {registroSeleccionado ? "Editar Sucursal" : "Nueva Sucursal"}
            </DialogTitle>
          </DialogHeader>
          <SucursalForm
            datosIniciales={registroSeleccionado || undefined}
            alEnviar={handleGuardar}
            alCancelar={() => setDialogoOpen(false)}
            cargando={crearMutation.isPending || actualizarMutation.isPending}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
