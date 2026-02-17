import { useState } from "react";
import { Plus, Edit2, Trash2, Link } from "lucide-react";
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
import { toast } from "sonner";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ReglaDocumento } from "@configuracion/services/reglasDocumentoService";
import {
  useReglasDocumentosCRUD,
  useGuardarRegla,
  useEliminarRegla,
  useActualizarRelaciones,
  useConfiguracionReglas,
} from "@configuracion/hooks/useReglasDocumentosCRUD";

import { useTiposComprobante } from "../hooks/useTiposComprobante";
import { ReglaDocumentoForm } from "../componentes/ReglaDocumentoForm";
import { Checkbox } from "@/components/ui/checkbox";

export function ReglasDocumentoPage() {
  const [dialogoReglaOpen, setDialogoReglaOpen] = useState(false);
  const [reglaSeleccionada, setReglaSeleccionada] =
    useState<ReglaDocumento | null>(null);

  const [dialogoRelacionesOpen, setDialogoRelacionesOpen] = useState(false);
  const [docParaRelacion, setDocParaRelacion] = useState<string | null>(null);
  const [relacionesTemporales, setRelacionesTemporales] = useState<number[]>(
    [],
  );

  // Hooks
  const { data: reglas, isLoading, error } = useReglasDocumentosCRUD();
  const { data: config } = useConfiguracionReglas();
  const { data: tiposComprobante } = useTiposComprobante();
  const guardarRegla = useGuardarRegla();
  const eliminarRegla = useEliminarRegla();
  const actualizarRelaciones = useActualizarRelaciones();

  const handleGuardarRegla = (datos: any) => {
    guardarRegla.mutate(datos, {
      onSuccess: () => {
        toast.success("Regla guardada correctamente");
        setDialogoReglaOpen(false);
      },
      onError: (e: any) =>
        toast.error(
          "Error: " +
            (e.response?.data?.message || e.message || "Error desconocido"),
        ),
    });
  };

  const handleEliminarRegla = (regla: ReglaDocumento) => {
    if (confirm(`¿Eliminar regla para ${regla.nombre}?`)) {
      eliminarRegla.mutate(regla.id!, {
        onSuccess: () => toast.success("Regla eliminada"),
        onError: (e: any) =>
          toast.error(
            "Error: " +
              (e.response?.data?.message || e.message || "Error desconocido"),
          ),
      });
    }
  };

  const handleOpenRelaciones = (regla: ReglaDocumento) => {
    setDocParaRelacion(regla.codigo);
    // Cargar relaciones actuales
    const actuales =
      config?.relaciones
        .filter((r) => r.codigoDocumento === regla.codigo)
        .map((r) => r.idTipoComprobante) || [];
    setRelacionesTemporales(actuales);
    setDialogoRelacionesOpen(true);
  };

  const toggleRelacion = (idTipo: number) => {
    setRelacionesTemporales((prev) =>
      prev.includes(idTipo)
        ? prev.filter((id) => id !== idTipo)
        : [...prev, idTipo],
    );
  };

  const handleGuardarRelaciones = () => {
    if (!docParaRelacion) return;
    actualizarRelaciones.mutate(
      {
        codigoDocumento: docParaRelacion,
        idsTiposComprobante: relacionesTemporales,
      },
      {
        onSuccess: () => {
          toast.success("Relaciones actualizadas");
          setDialogoRelacionesOpen(false);
        },
        onError: () => toast.error("Error al actualizar relaciones"),
      },
    );
  };

  const columnas: any[] = [
    {
      header: "Código SUNAT",
      accessorKey: "codigo",
      className: "font-mono font-bold",
    },
    {
      header: "Nombre",
      accessorKey: "nombre",
    },
    {
      header: "Longitud",
      accessorKey: "longitud",
    },
    {
      header: "Tipo",
      accessorKey: "esNumerico",
      cell: (row: ReglaDocumento) =>
        row.esNumerico ? "Numérico" : "Alfanumérico",
    },
    {
      header: "Estado",
      accessorKey: "activado",
      cell: (row: ReglaDocumento) => (
        <span
          className={`text-xs px-2 py-0.5 rounded-full ${row.activado ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"}`}
        >
          {row.activado ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: ReglaDocumento) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            title="Gestionar Comprobantes Permitidos"
            onClick={() => handleOpenRelaciones(row)}
          >
            <Link className="h-4 w-4 text-blue-600" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setReglaSeleccionada(row);
              setDialogoReglaOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminarRegla(row)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando reglas de SUNAT..." />;
  if (error)
    return <MensajeError mensaje="Error al cargar las reglas de documentos" />;

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-start">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">
            Tipos de Documento (Identidad)
          </h1>
          <p className="text-muted-foreground">
            Mantenimiento de documentos de identidad permitidos (DNI, RUC, etc.)
            y su configuración SUNAT.
          </p>
        </div>
        <Button
          onClick={() => {
            setReglaSeleccionada(null);
            setDialogoReglaOpen(true);
          }}
        >
          <Plus className="mr-2 h-4 w-4" /> Nuevo Tipo
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Listado de Documentos Identidad</CardTitle>
          <CardDescription>
            Defina la longitud y formato de los documentos permitidos para
            clientes y proveedores.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable data={(reglas || []) as any[]} columns={columnas} />
        </CardContent>
      </Card>

      {/* Diálogo de Edición de Regla */}
      <Dialog open={dialogoReglaOpen} onOpenChange={setDialogoReglaOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {reglaSeleccionada ? "Editar Regla" : "Nueva Regla de Documento"}
            </DialogTitle>
          </DialogHeader>
          <ReglaDocumentoForm
            datosIniciales={reglaSeleccionada || undefined}
            alEnviar={handleGuardarRegla}
            alCancelar={() => setDialogoReglaOpen(false)}
            cargando={guardarRegla.isPending}
          />
        </DialogContent>
      </Dialog>

      {/* Diálogo de Gestión de Relaciones */}
      <Dialog
        open={dialogoRelacionesOpen}
        onOpenChange={setDialogoRelacionesOpen}
      >
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Comprobantes Permitidos</DialogTitle>
            <CardDescription>
              Seleccione los comprobantes que se pueden emitir/recibir con el
              documento: <b>{docParaRelacion}</b>
            </CardDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            <div className="grid grid-cols-1 gap-2 border rounded-md p-4 max-h-[300px] overflow-y-auto">
              {tiposComprobante?.map((tipo) => (
                <div
                  key={tipo.id}
                  className="flex items-center space-x-3 p-2 hover:bg-slate-50 rounded-md transition-colors"
                >
                  <Checkbox
                    id={`tipo-${tipo.id}`}
                    checked={relacionesTemporales.includes(tipo.id)}
                    onCheckedChange={() => toggleRelacion(tipo.id)}
                  />
                  <label
                    htmlFor={`tipo-${tipo.id}`}
                    className="text-sm font-medium leading-none cursor-pointer"
                  >
                    {tipo.codigo} - {tipo.nombre}
                  </label>
                </div>
              ))}
            </div>
          </div>

          <div className="flex justify-end gap-2">
            <Button
              variant="outline"
              onClick={() => setDialogoRelacionesOpen(false)}
            >
              Cancelar
            </Button>
            <Button
              onClick={handleGuardarRelaciones}
              disabled={actualizarRelaciones.isPending}
            >
              {actualizarRelaciones.isPending
                ? "Guardando..."
                : "Actualizar Relaciones"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
