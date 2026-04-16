import { useEffect, useState } from "react";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { Card, CardContent } from "@/components/ui/card";
import { DataTable, DataTableColumn } from "@/componentes/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { Badge } from "@/components/ui/badge";
import { NotaResumen } from "../tipos/notas.types";
import { servicioVentas } from "../servicios/servicioVentas";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Eye } from "lucide-react";
import { ModalVistaPreviaNotaSunat } from "@/compartido/componentes/documentos/ModalVistaPreviaNotaSunat";

import { EstadoDocumento } from "@compartido/enums";

const ESTADO_CPE_COLORES: Record<string, string> = {
  PENDIENTE: "bg-amber-100 text-amber-700 border-amber-200",
  ENVIADO: "bg-blue-100 text-blue-700 border-blue-200",
  ACEPTADO: "bg-emerald-100 text-emerald-700 border-emerald-200",
  RECHAZADO: "bg-red-100 text-red-700 border-red-200",
};

const ESTADO_DOCUMENTO_COLORES: Record<number, string> = {
  [EstadoDocumento.Registrado]: "bg-blue-50 text-blue-700 border-blue-200",
  [EstadoDocumento.AnuladoDirecto]: "bg-red-50 text-red-700 border-red-200",
  [EstadoDocumento.Rechazado]: "bg-gray-50 text-gray-700 border-gray-200",
  [EstadoDocumento.Pendiente]: "bg-amber-50 text-amber-700 border-amber-200",
  [EstadoDocumento.AnuladoNotaCredito]: "bg-rose-50 text-rose-700 border-rose-200",
  [EstadoDocumento.AnuladoNotaDebito]: "bg-pink-50 text-pink-700 border-pink-200",
  [EstadoDocumento.Completado]: "bg-green-50 text-green-700 border-green-200",
};

export function PaginaNotas() {
  const [tipoRender, setTipoRender] = useState<"CREDITO" | "DEBITO">("CREDITO");
  
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();
  const [dataRe, setDataRe] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(false);

  // Estados para Vista Previa
  const [idSeleccionado, setIdSeleccionado] = useState<number | null>(null);
  const [mostrarVistaPrevia, setMostrarVistaPrevia] = useState(false);

  useEffect(() => {
    fetchNotas();
  }, [paginacion.pageNumber, paginacion.pageSize, paginacion.search, tipoRender]);

  const fetchNotas = async () => {
    setIsLoading(true);
    try {
      const resp = tipoRender === "CREDITO" 
          ? await servicioVentas.obtenerNotasCredito({
              pageNumber: paginacion.pageNumber,
              pageSize: paginacion.pageSize,
              search: paginacion.search,
            })
          : await servicioVentas.obtenerNotasDebito({
              pageNumber: paginacion.pageNumber,
              pageSize: paginacion.pageSize,
              search: paginacion.search,
            });
      setDataRe(resp);
    } catch (e) {
      console.error("Error al cargar notas:", e);
    } finally {
      setIsLoading(false);
    }
  };

  const handleVerDetalle = (id: number) => {
    setIdSeleccionado(id);
    setMostrarVistaPrevia(true);
  };

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: "Notas SUNAT", to: "/ventas/notas" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  const columns: DataTableColumn<NotaResumen>[] = [
    {
      header: "Comprobante",
      cell: (nota: NotaResumen) => (
        <div className="flex flex-col">
          <span className="font-medium text-primary">
            {nota.serie}-{nota.numero.toString().padStart(8, '0')}
          </span>
          <span className="text-[10px] uppercase font-bold text-muted-foreground">
            {nota.tipoComprobante === "07" ? "NOTA CRÉDITO" : "NOTA DÉBITO"}
          </span>
        </div>
      ),
    },
    {
      header: "Fecha Emisión",
      cell: (nota: NotaResumen) => (
        <span className="text-sm">
          {formatearFechaHora(nota.fechaEmision)}
        </span>
      ),
    },
    {
      header: "Cliente",
      cell: (nota: NotaResumen) => (
        <div className="max-w-[200px] truncate" title={nota.clienteRazonSocial}>
          {nota.clienteRazonSocial || "Desconocido"}
        </div>
      ),
    },
    {
      header: "Total",
      cell: (nota: NotaResumen) => (
        <span className="font-bold text-base">
          {formatearMoneda(nota.total)}
        </span>
      ),
    },
    {
      header: "Estado",
      cell: (nota: NotaResumen) => (
        <Badge
          variant="outline"
          className={ESTADO_DOCUMENTO_COLORES[nota.idEstado] || "bg-gray-100 text-gray-700"}
        >
          {nota.estadoNombre}
        </Badge>
      ),
    },
    {
      header: "Estado CPE",
      cell: (nota: NotaResumen) => (
        <Badge
          variant="outline"
          className={ESTADO_CPE_COLORES[nota.estadoCpe] || "bg-gray-100 text-gray-700"}
        >
          {nota.estadoCpe}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      cell: (nota: NotaResumen) => (
        <Button 
          variant="ghost" 
          size="icon" 
          title="Ver Detalle"
          onClick={() => handleVerDetalle(nota.idNota)}
        >
          <Eye className="h-4 w-4 text-primary" />
        </Button>
      ),
    }
  ];

  const notas = dataRe?.datos || [];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsVentas} />

      <Tabs defaultValue="credito" onValueChange={(val) => setTipoRender(val === "credito" ? "CREDITO" : "DEBITO")}>
        <div className="flex justify-between items-center mb-4">
          <TabsList>
            <TabsTrigger value="credito">Notas de Crédito (07)</TabsTrigger>
            <TabsTrigger value="debito">Notas de Débito (08)</TabsTrigger>
          </TabsList>
        </div>

        {/* NC Content */}
        <TabsContent value="credito">
          <Card>
            <CardContent className="p-6">
              <DataTable 
                data={notas} 
                columns={columns} 
                pagination={dataRe}
                onPageChange={cambiarPagina}
                onPageSizeChange={cambiarPageSize}
                onSearchChange={cambiarBusqueda}
                isLoading={isLoading}
                searchPlaceholder="Buscar por serie o cliente..."
              />
            </CardContent>
          </Card>
        </TabsContent>
        
        {/* ND Content */}
        <TabsContent value="debito">
          <Card>
            <CardContent className="p-6">
              <DataTable 
                data={notas} 
                columns={columns} 
                pagination={dataRe}
                onPageChange={cambiarPagina}
                onPageSizeChange={cambiarPageSize}
                onSearchChange={cambiarBusqueda}
                isLoading={isLoading}
                searchPlaceholder="Buscar por serie o cliente..."
              />
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Modal de Vista Previa Compartido */}
      {idSeleccionado && (
        <ModalVistaPreviaNotaSunat
          id={idSeleccionado}
          tipo={tipoRender === "CREDITO" ? "NC" : "ND"}
          modulo="VENTAS"
          open={mostrarVistaPrevia}
          onOpenChange={setMostrarVistaPrevia}
        />
      )}
    </div>
  );
}
