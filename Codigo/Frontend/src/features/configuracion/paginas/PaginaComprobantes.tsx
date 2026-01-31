import { useState } from "react";
import { Plus, Edit2, Trash2 } from "lucide-react";
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
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  useTiposComprobante,
  useCrearTipoComprobante,
  useActualizarTipoComprobante,
  useEliminarTipoComprobante,
} from "../hooks/useTiposComprobante";
import {
  useSeriesComprobante,
  useCrearSerieComprobante,
  useActualizarSerieComprobante,
  useEliminarSerieComprobante,
} from "../hooks/useSeriesComprobante";
import {
  TipoComprobante,
  TipoComprobanteFormData,
} from "../tipos/tipoComprobante.types";
import {
  SerieComprobante,
  SerieComprobanteFormData,
} from "../tipos/serieComprobante.types";
import { TipoComprobanteForm } from "../componentes/TipoComprobanteForm";
import { SerieComprobanteForm } from "../componentes/SerieComprobanteForm";
import { toast } from "sonner";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

export function PaginaComprobantes() {
  const [tabActual, setTabActual] = useState("tipos");

  // Estados para diálogos
  const [dialogoTipoOpen, setDialogoTipoOpen] = useState(false);
  const [tipoSeleccionado, setTipoSeleccionado] =
    useState<TipoComprobante | null>(null);

  const [dialogoSerieOpen, setDialogoSerieOpen] = useState(false);
  const [serieSeleccionada, setSerieSeleccionada] =
    useState<SerieComprobante | null>(null);

  // Hooks Tipos
  const {
    data: tipos,
    isLoading: loadingTipos,
    error: errorTipos,
  } = useTiposComprobante();
  const crearTipo = useCrearTipoComprobante();
  const actualizarTipo = useActualizarTipoComprobante();
  const eliminarTipo = useEliminarTipoComprobante();

  // Hooks Series
  const {
    data: series,
    isLoading: loadingSeries,
    error: errorSeries,
  } = useSeriesComprobante();
  const crearSerie = useCrearSerieComprobante();
  const actualizarSerie = useActualizarSerieComprobante();
  const eliminarSerie = useEliminarSerieComprobante();

  // Handlers Tipos
  const handleGuardarTipo = (datos: TipoComprobanteFormData) => {
    if (tipoSeleccionado) {
      actualizarTipo.mutate(
        { id: tipoSeleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Tipo actualizado");
            setDialogoTipoOpen(false);
          },
          onError: (e) => toast.error("Error: " + e.message),
        },
      );
    } else {
      crearTipo.mutate(datos, {
        onSuccess: () => {
          toast.success("Tipo creado");
          setDialogoTipoOpen(false);
        },
        onError: (e) => toast.error("Error: " + e.message),
      });
    }
  };

  const handleEliminarTipo = (tipo: TipoComprobante) => {
    if (confirm(`¿Eliminar tipo ${tipo.nombre}?`)) {
      eliminarTipo.mutate(tipo.id);
    }
  };

  // Handlers Series
  const handleGuardarSerie = (datos: SerieComprobanteFormData) => {
    if (serieSeleccionada) {
      actualizarSerie.mutate(
        { id: serieSeleccionada.id, datos },
        {
          onSuccess: () => {
            toast.success("Serie actualizada");
            setDialogoSerieOpen(false);
          },
          onError: (e) => toast.error("Error: " + e.message),
        },
      );
    } else {
      crearSerie.mutate(datos, {
        onSuccess: () => {
          toast.success("Serie creada");
          setDialogoSerieOpen(false);
        },
        onError: (e) => toast.error("Error: " + e.message),
      });
    }
  };

  const handleEliminarSerie = (serie: SerieComprobante) => {
    if (confirm(`¿Eliminar serie ${serie.serie}?`)) {
      eliminarSerie.mutate(serie.id);
    }
  };

  // Columnas Tipos
  const columnasTipos = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof TipoComprobante,
      className: "font-mono",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof TipoComprobante,
      className: "font-semibold",
    },
    {
      header: "Stock",
      accessorKey: "mueveStock" as keyof TipoComprobante,
      cell: (row: TipoComprobante) =>
        row.mueveStock ? (
          <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-blue-100 text-blue-800">
            {row.tipoMovimientoStock}
          </span>
        ) : (
          <span className="text-xs text-muted-foreground">No Aplica</span>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TipoComprobante) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setTipoSeleccionado(row);
              setDialogoTipoOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminarTipo(row)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  // Columnas Series
  const columnasSeries = [
    {
      header: "Tipo",
      accessorKey: "idTipoComprobante" as keyof SerieComprobante,
      cell: (row: SerieComprobante) => {
        const tipo = tipos?.find((t) => t.id === row.idTipoComprobante);
        return tipo ? tipo.nombre : row.idTipoComprobante;
      },
    },
    {
      header: "Serie",
      accessorKey: "serie" as keyof SerieComprobante,
      className: "font-mono font-bold",
    },
    {
      header: "Correlativo",
      accessorKey: "correlativoActual" as keyof SerieComprobante,
      className: "font-mono",
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: SerieComprobante) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setSerieSeleccionada(row);
              setDialogoSerieOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminarSerie(row)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (loadingTipos || loadingSeries)
    return <Loading mensaje="Cargando configuración..." />;
  if (errorTipos || errorSeries)
    return <MensajeError mensaje="Error al cargar datos" />;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Comprobantes de Pago</h1>
        <p className="text-muted-foreground">
          Gestión de tipos de documentos (Facturas, Boletas) y sus series de
          numeración.
        </p>
      </div>

      <Tabs value={tabActual} onValueChange={setTabActual} className="w-full">
        <TabsList className="grid w-full grid-cols-2 max-w-[400px]">
          <TabsTrigger value="tipos">Tipos de Comprobante</TabsTrigger>
          <TabsTrigger value="series">Series y Numeración</TabsTrigger>
        </TabsList>

        <TabsContent value="tipos" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Tipos Disponibles</CardTitle>
              <CardDescription>
                Define los documentos que emite o recibe la empresa y su impacto
                en inventario.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <DataTable
                data={tipos || []}
                columns={columnasTipos}
                actionElement={
                  <Button
                    onClick={() => {
                      setTipoSeleccionado(null);
                      setDialogoTipoOpen(true);
                    }}
                  >
                    <Plus className="mr-2 h-4 w-4" /> Nuevo Tipo
                  </Button>
                }
              />
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="series" className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Series Activas</CardTitle>
              <CardDescription>
                Configura las series (ej. F001, B001) y sus correlativos
                actuales.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <DataTable
                data={series || []}
                columns={columnasSeries}
                actionElement={
                  <Button
                    onClick={() => {
                      setSerieSeleccionada(null);
                      setDialogoSerieOpen(true);
                    }}
                  >
                    <Plus className="mr-2 h-4 w-4" /> Nueva Serie
                  </Button>
                }
              />
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Dialogo Tipos */}
      <Dialog open={dialogoTipoOpen} onOpenChange={setDialogoTipoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {tipoSeleccionado ? "Editar Tipo" : "Nuevo Tipo de Comprobante"}
            </DialogTitle>
          </DialogHeader>
          <TipoComprobanteForm
            datosIniciales={tipoSeleccionado || undefined}
            alEnviar={handleGuardarTipo}
            alCancelar={() => setDialogoTipoOpen(false)}
            cargando={crearTipo.isPending || actualizarTipo.isPending}
          />
        </DialogContent>
      </Dialog>

      {/* Dialogo Series */}
      <Dialog open={dialogoSerieOpen} onOpenChange={setDialogoSerieOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {serieSeleccionada
                ? "Editar Serie"
                : "Nueva Serie de Comprobante"}
            </DialogTitle>
          </DialogHeader>
          <SerieComprobanteForm
            datosIniciales={serieSeleccionada || undefined}
            alEnviar={handleGuardarSerie}
            alCancelar={() => setDialogoSerieOpen(false)}
            cargando={crearSerie.isPending || actualizarSerie.isPending}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
