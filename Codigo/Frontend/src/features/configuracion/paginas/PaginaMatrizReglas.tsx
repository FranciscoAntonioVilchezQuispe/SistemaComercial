import { useState } from "react";
import { Plus, Edit2, Trash2, CheckCircle, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Badge } from "@/components/ui/badge";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { toast } from "sonner";
import {
  useMatrizReglas,
  useCrearMatrizRegla,
  useActualizarMatrizRegla,
  useEliminarMatrizRegla,
} from "../hooks/useMatrizReglas";
import { useTiposOperacion } from "../hooks/useTiposOperacion";
import { useTiposComprobante } from "../hooks/useTiposComprobante";
import {
  MatrizReglaSunat,
  MatrizReglaSunatFormData,
  NIVEL_OBLIGATORIEDAD,
} from "../tipos/matrizRegla.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

const NIVEL_BADGE_STYLES: Record<number, string> = {
  0: "bg-slate-500/10 text-slate-600 border-slate-200",
  1: "bg-blue-500/10 text-blue-600 border-blue-200",
  2: "bg-amber-500/10 text-amber-600 border-amber-200",
};

function FormularioMatriz({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: {
  datosIniciales?: MatrizReglaSunat;
  alEnviar: (datos: MatrizReglaSunatFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}) {
  const { data: operaciones } = useTiposOperacion();
  const { data: comprobantes } = useTiposComprobante();

  const [form, setForm] = useState<MatrizReglaSunatFormData>({
    idTipoOperacion: datosIniciales?.idTipoOperacion ?? 0,
    idTipoComprobante: datosIniciales?.idTipoComprobante ?? 0,
    nivelObligatoriedad: datosIniciales?.nivelObligatoriedad ?? 0,
    activo: datosIniciales?.activo ?? true,
  });

  return (
    <div className="space-y-4">
      <div className="space-y-1">
        <Label>Tipo de Operación</Label>
        <Select
          value={form.idTipoOperacion ? String(form.idTipoOperacion) : ""}
          onValueChange={(v) =>
            setForm((p) => ({ ...p, idTipoOperacion: Number(v) }))
          }
        >
          <SelectTrigger className="h-9">
            <SelectValue placeholder="Seleccionar operación..." />
          </SelectTrigger>
          <SelectContent>
            {(operaciones || []).map((op) => (
              <SelectItem key={op.id} value={String(op.id)}>
                <span className="font-mono font-bold mr-2 text-[11px]">{op.codigo}</span>
                {op.nombre}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-1">
        <Label>Tipo de Comprobante</Label>
        <Select
          value={form.idTipoComprobante ? String(form.idTipoComprobante) : ""}
          onValueChange={(v) =>
            setForm((p) => ({ ...p, idTipoComprobante: Number(v) }))
          }
        >
          <SelectTrigger className="h-9">
            <SelectValue placeholder="Seleccionar comprobante..." />
          </SelectTrigger>
          <SelectContent>
            {(comprobantes || []).map((comp) => (
              <SelectItem key={comp.id} value={String(comp.id)}>
                <span className="font-mono font-bold mr-2 text-[11px]">{comp.codigo}</span>
                {comp.nombre}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-1">
        <Label>Nivel de Obligatoriedad</Label>
        <Select
          value={String(form.nivelObligatoriedad)}
          onValueChange={(v) =>
            setForm((p) => ({ ...p, nivelObligatoriedad: Number(v) }))
          }
        >
          <SelectTrigger className="h-9">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {Object.entries(NIVEL_OBLIGATORIEDAD).map(([k, v]) => (
              <SelectItem key={k} value={k}>
                {v}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="flex items-center gap-3 py-2">
        <Switch
          id="activo"
          checked={form.activo}
          onCheckedChange={(v) => setForm((p) => ({ ...p, activo: v }))}
        />
        <Label htmlFor="activo" className="cursor-pointer">Activo</Label>
      </div>

      <div className="flex justify-end gap-2 pt-4 border-t">
        <Button variant="outline" size="sm" onClick={alCancelar} className="h-9 px-4">
          Cancelar
        </Button>
        <Button
          disabled={
            cargando || !form.idTipoOperacion || !form.idTipoComprobante
          }
          size="sm"
          onClick={() => alEnviar(form)}
          className="h-9 px-6"
        >
          {cargando ? "Guardando..." : "Guardar Regla"}
        </Button>
      </div>
    </div>
  );
}

export function PaginaMatrizReglas() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [seleccionado, setSeleccionado] = useState<MatrizReglaSunat | null>(
    null,
  );
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: reglas, isLoading, error } = useMatrizReglas();
  const crear = useCrearMatrizRegla();
  const actualizar = useActualizarMatrizRegla();
  const eliminar = useEliminarMatrizRegla();

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
    { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
    { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
    { label: RUTAS_TITULOS["/configuracion/reglas-sunat"], to: "/configuracion/reglas-sunat" },
    { label: RUTAS_TITULOS["/configuracion/operaciones-sunat"], to: "/configuracion/operaciones-sunat" },
    { label: RUTAS_TITULOS["/configuracion/matriz-sunat"], to: "/configuracion/matriz-sunat" },
    { label: RUTAS_TITULOS["/configuracion/tablas-generales"], to: "/configuracion/tablas-generales" },
  ];

  const handleGuardar = (datos: MatrizReglaSunatFormData) => {
    if (seleccionado) {
      actualizar.mutate(
        { id: seleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Regla actualizada");
            setDialogoOpen(false);
          },
          onError: (e) => toast.error("Error: " + e.message),
        },
      );
    } else {
      crear.mutate(datos, {
        onSuccess: () => {
          toast.success("Regla creada");
          setDialogoOpen(false);
        },
        onError: (e) => toast.error("Error: " + e.message),
      });
    }
  };

  const columnas = [
    {
      header: "Operación",
      accessorKey: "tipoOperacion" as keyof MatrizReglaSunat,
      cell: (row: MatrizReglaSunat) => (
        <div className="flex items-center gap-2">
          <span className="font-mono font-bold text-[11px] bg-muted px-2 py-0.5 rounded border border-muted/20">
            {row.tipoOperacion?.codigo ?? row.idTipoOperacion}
          </span>
          <span className="text-sm font-medium">{row.tipoOperacion?.nombre}</span>
        </div>
      ),
    },
    {
      header: "Comprobante",
      accessorKey: "tipoComprobante" as keyof MatrizReglaSunat,
      cell: (row: MatrizReglaSunat) => (
        <div className="flex items-center gap-2">
          <span className="font-mono font-bold text-[11px] bg-muted px-2 py-0.5 rounded border border-muted/20">
            {row.tipoComprobante?.codigo ?? row.idTipoComprobante}
          </span>
          <span className="text-sm font-medium">{row.tipoComprobante?.nombre}</span>
        </div>
      ),
    },
    {
      header: "Obligatoriedad",
      accessorKey: "nivelObligatoriedad" as keyof MatrizReglaSunat,
      cell: (row: MatrizReglaSunat) => (
        <Badge 
          variant="outline"
          className={`text-[10px] font-semibold px-2 py-0.5 rounded-full shadow-none ${NIVEL_BADGE_STYLES[row.nivelObligatoriedad] ?? ""}`}
        >
          {NIVEL_OBLIGATORIEDAD[row.nivelObligatoriedad] ?? "Desconocido"}
        </Badge>
      ),
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof MatrizReglaSunat,
      cell: (row: MatrizReglaSunat) =>
        row.activo ? (
          <Badge variant="default" className="gap-1 bg-green-500/10 text-green-600 border-green-200 hover:bg-green-500/20 shadow-none text-[11px] h-5">
            <CheckCircle className="h-3 w-3" /> Activo
          </Badge>
        ) : (
          <Badge variant="secondary" className="gap-1 bg-muted/50 text-muted-foreground shadow-none text-[11px] h-5">
            <XCircle className="h-3 w-3" /> Inactivo
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: MatrizReglaSunat) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => {
              setSeleccionado(row);
              setDialogoOpen(true);
            }}
            className="h-8 w-8 p-0"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="text-destructive h-8 w-8 p-0 hover:text-destructive hover:bg-destructive/10"
            onClick={() => setEliminarId(row.id)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando matriz de reglas..." />;
  if (error) return <MensajeError mensaje="Error al cargar la matriz" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4 flex flex-row items-center justify-between space-y-0">
          <div className="space-y-1">
            <CardTitle className="text-lg">Relaciones Operación ↔ Comprobante</CardTitle>
            <CardDescription>
              Define qué comprobantes son válidos para cada tipo de operación SUNAT.
            </CardDescription>
          </div>
          <Button
            size="sm"
            onClick={() => {
              setSeleccionado(null);
              setDialogoOpen(true);
            }}
          >
            <Plus className="mr-2 h-4 w-4" /> Nueva Regla
          </Button>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable data={reglas || []} columns={columnas} />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>
              {seleccionado ? "Editar Regla" : "Nueva Regla de Operación"}
            </DialogTitle>
          </DialogHeader>
          <FormularioMatriz
            datosIniciales={seleccionado || undefined}
            alEnviar={handleGuardar}
            alCancelar={() => setDialogoOpen(false)}
            cargando={crear.isPending || actualizar.isPending}
          />
        </DialogContent>
      </Dialog>

      <AlertDialog
        open={eliminarId !== null}
        onOpenChange={(open) => !open && setEliminarId(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Eliminar esta regla?</AlertDialogTitle>
            <AlertDialogDescription>
              Esto eliminará la relación entre la operación y el comprobante. No
              se puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminar.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Regla eliminada");
                      setEliminarId(null);
                    },
                    onError: (e: any) => {
                      toast.error("Error: " + e.message);
                      setEliminarId(null);
                    },
                  });
                }
              }}
            >
              Sí, eliminar
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
