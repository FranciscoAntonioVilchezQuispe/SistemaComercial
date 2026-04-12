import { useState, useEffect } from "react";
import { useForm, Controller } from "react-hook-form";
import { toast } from "sonner";
import {
  Search,
  Download,
  RefreshCcw,
  Database,
} from "lucide-react";
import { format } from "date-fns";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/componentes/ui/card";
import { Button } from "@/componentes/ui/button";
import { Input } from "@/componentes/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";

import { BuscadorProductoOscuro } from "../componentes/BuscadorProductoOscuro";
import { kardexService } from "../servicios/servicioKardex";
import { servicioInventario } from "../servicios/servicioInventario";
import { KardexReporteDto } from "../tipos/kardex";
import { formatearMoneda } from "@/compartido/utilidades";

import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/componentes/ui/alert-dialog";

type FormBusqueda = {
  almacenId: number;
  productoId: number;
  desde: string;
  hasta: string;
};

export function PaginaKardexReporte() {
  const [cargando, setCargando] = useState(false);
  const [recalculando, setRecalculando] = useState(false);
  const [sincronizando, setSincronizando] = useState(false);
  const [reporte, setReporte] = useState<KardexReporteDto | null>(null);
  const [confirmarSincronizacion, setConfirmarSincronizacion] = useState(false);

  // Estados para Almacenes
  const [almacenes, setAlmacenes] = useState<
    { id: number; nombreAlmacen: string }[]
  >([]);

  // (Búsqueda de Productos manejada por BuscadorProductoOscuro)

  const { register, handleSubmit, getValues, setValue, control, watch } =
    useForm<FormBusqueda>({
      defaultValues: {
        almacenId: 0,
        productoId: 0,
        desde: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          .toISOString()
          .slice(0, 10),
        hasta: new Date().toISOString().slice(0, 10),
      },
    });

  const productoIdSeleccionado = watch("productoId");

  // Cargar Almacenes al inicio
  useEffect(() => {
    const cargarAlmacenes = async () => {
      try {
        const response = await servicioInventario.obtenerAlmacenes({
          pageNumber: 1,
          pageSize: 100,
        });
        const listaAlmacenes = response.datos || [];
        setAlmacenes(listaAlmacenes);
        if (listaAlmacenes.length > 0) {
          setValue("almacenId", listaAlmacenes[0].id);
        }
      } catch (error) {
        console.error("Error al cargar almacenes", error);
      }
    };
    cargarAlmacenes();
  }, [setValue]);

  const [pageNumber, setPageNumber] = useState(1);
  const [pageSize, setPageSize] = useState(100);

  const buscarReporte = async (data: FormBusqueda, page: number = 1, size: number = 100) => {
    if (!data.productoId || data.productoId === 0) {
      toast.warning("Debe seleccionar un producto");
      return;
    }

    try {
      setCargando(true);
      const resultado = await kardexService.obtenerReporte(
        Number(data.almacenId),
        Number(data.productoId),
        data.desde,
        data.hasta,
        page,
        size
      );
      setReporte(resultado);
      setPageNumber(page);
      setPageSize(size);
      toast.success("Kardex generado correctamente");
    } catch (error: any) {
      console.error("Error al obtener el Kardex:", error);
      setReporte(null);
    } finally {
      setCargando(false);
    }
  };

  const ejecutarRecalculo = async () => {
    const data = getValues();
    if (!data.productoId || data.productoId === 0) {
      toast.warning("Debe seleccionar un producto primero");
      return;
    }

    try {
      setRecalculando(true);
      await kardexService.recalcular({
        almacenId: Number(data.almacenId),
        productoId: Number(data.productoId),
        desdeFecha: data.desde,
        motivo: "Recálculo manual desde UI",
        usuarioId: 1,
      });
      toast.success("Recálculo completado. Refrescando reporte...");
      await buscarReporte(data);
    } catch (error: any) {
      console.error("Error al ejecutar el recálculo:", error);
    } finally {
      setRecalculando(false);
    }
  };

  const ejecutarSincronizacion = async () => {
    try {
      setSincronizando(true);
      // Pasamos true para forzar el reinicio total y limpieza de duplicados/horas
      const mensaje = await servicioInventario.sincronizarHistorico(true);
      toast.success(mensaje || "Sincronización y recálculo completado");

      const data = getValues();
      if (data.productoId > 0) {
        await buscarReporte(data);
      }
    } catch (error: any) {
      console.error("Error al sincronizar datos históricos:", error);
    } finally {
      setSincronizando(false);
      setConfirmarSincronizacion(false);
    }
  };

  const tabsKardex = [
    { label: RUTAS_TITULOS["/inventario/stock"], to: "/inventario/stock" },
    { label: RUTAS_TITULOS["/inventario/movimientos"], to: "/inventario/movimientos" },
    { label: RUTAS_TITULOS["/inventario/traslados"], to: "/inventario/traslados" },
    { label: RUTAS_TITULOS["/inventario/kardex/reporte"], to: "/inventario/kardex/reporte" },
    { label: RUTAS_TITULOS["/inventario/kardex/periodos"], to: "/inventario/kardex/periodos" },
    { label: RUTAS_TITULOS["/inventario/almacenes"], to: "/inventario/almacenes" },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsKardex} />
      <div className="flex flex-col gap-6 mt-4">
        {/* Filtros */}
        <Card>
          <CardHeader className="pb-4">
            <CardTitle className="text-lg">Parámetros de Búsqueda</CardTitle>
          </CardHeader>
          <CardContent>
            <form
              onSubmit={handleSubmit((data) => buscarReporte(data, 1, pageSize))}
              className="flex flex-wrap gap-4 items-end"
            >
              {/* Selector de Almacén */}
              <div className="w-full md:w-60">
                <label className="text-sm font-medium mb-1 block">
                  Almacén
                </label>
                <Controller
                  name="almacenId"
                  control={control}
                  rules={{ required: true }}
                  render={({ field }) => (
                    <Select
                      onValueChange={(val) => field.onChange(Number(val))}
                      value={field.value.toString()}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Seleccione Almacén" />
                      </SelectTrigger>
                      <SelectContent>
                        {almacenes.map((a) => (
                          <SelectItem key={a.id} value={a.id.toString()}>
                            {a.nombreAlmacen}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                />
              </div>

              {/* Autocomplete de Producto (Dark UI Component) */}
              <div className="w-full md:w-[400px]">
                <BuscadorProductoOscuro
                  productoInicialId={productoIdSeleccionado}
                  nombreInicial={reporte?.descripcionExistencia || ""}
                  onSelectProducto={(id) => setValue("productoId", id)}
                />
              </div>

              <div className="w-full md:w-40">
                <label className="text-sm font-medium mb-1 block">
                  Fecha Inicio
                </label>
                <Input type="date" {...register("desde", { required: true })} />
              </div>
              <div className="w-full md:w-40">
                <label className="text-sm font-medium mb-1 block">
                  Fecha Fin
                </label>
                <Input type="date" {...register("hasta", { required: true })} />
              </div>
              <div className="flex gap-2">
                <Button
                  type="submit"
                  disabled={cargando || sincronizando}
                  className="bg-slate-800 text-white"
                >
                  <Search className="w-4 h-4 mr-2" />
                  {cargando ? "Generando..." : "Generar Kardex"}
                </Button>

                <Button
                  type="button"
                  onClick={() => setConfirmarSincronizacion(true)}
                  disabled={sincronizando || cargando}
                  variant="outline"
                  className="border-blue-200 text-blue-700 hover:bg-blue-50"
                  title="Sincronizar compras, ventas y notas que no figuran en el Kardex"
                >
                  <Database
                    className={`w-4 h-4 mr-2 ${sincronizando ? "animate-pulse" : ""}`}
                  />
                  {sincronizando ? "Sincronizando..." : "Sincronizar Histórico"}
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>

        {reporte && (
          <Card className="overflow-hidden border shadow-sm">
            <CardHeader className="bg-slate-50 border-b pb-4 flex flex-row justify-between items-start">
              <div>
                <div className="mt-4 grid grid-cols-2 md:grid-cols-4 gap-x-8 gap-y-2 text-sm text-slate-600">
                  <p>
                    <span className="font-semibold text-slate-900">
                      PERIODO:
                    </span>{" "}
                    {reporte.periodo}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">RUC:</span>{" "}
                    {reporte.rucEmpresa}
                  </p>
                  <p className="col-span-2">
                    <span className="font-semibold text-slate-900">
                      RAZÓN SOCIAL:
                    </span>{" "}
                    {reporte.razonSocialEmpresa}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">
                      ESTABLECIMIENTO:
                    </span>{" "}
                    {reporte.establecimiento}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">
                      CÓD. EXISTENCIA:
                    </span>{" "}
                    {reporte.codigoExistencia}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">
                      TIPO (TABLA 5):
                    </span>{" "}
                    {reporte.tipoExistencia}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">
                      DESCRIPCIÓN:
                    </span>{" "}
                    {reporte.descripcionExistencia}
                  </p>
                  <p>
                    <span className="font-semibold text-slate-900">
                      UNIDAD (TABLA 6):
                    </span>{" "}
                    {reporte.codigoUnidadMedida}
                  </p>
                  <p className="col-span-3">
                    <span className="font-semibold text-slate-900">
                      MÉTODO VALUACIÓN:
                    </span>{" "}
                    {reporte.metodoValuacion} (Promedio Ponderado)
                  </p>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={ejecutarRecalculo}
                  disabled={recalculando || cargando}
                  className="text-amber-700 border-amber-200 hover:bg-amber-50"
                  title="Recalcula saldos y costos desde la fecha de inicio seleccionada"
                >
                  <RefreshCcw
                    className={`w-4 h-4 mr-2 ${recalculando ? "animate-spin" : ""}`}
                  />
                  {recalculando ? "Recalculando..." : "Recalcular"}
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => window.print()}
                >
                  <Download className="w-4 h-4 mr-2" />
                  Imprimir
                </Button>
              </div>
            </CardHeader>

            <div className="overflow-x-auto">
              <table className="w-full text-sm text-left whitespace-nowrap">
                <thead className="bg-slate-100 text-slate-700 text-center font-semibold text-xs border-b">
                  <tr>
                    <th rowSpan={2} className="px-2 py-2 border-r align-middle">
                      FECHA
                    </th>
                    <th colSpan={3} className="px-2 py-2 border-r border-b">
                      DOCUMENTO DE TRASLADO / COMPROBANTE
                    </th>
                    <th
                      rowSpan={2}
                      className="px-2 py-2 border-r align-middle w-16"
                    >
                      TIPO
                      <br />
                      OPER.
                      <br />
                      (T12)
                    </th>
                    <th
                      colSpan={3}
                      className="px-2 py-2 border-r border-b bg-green-50"
                    >
                      ENTRADAS
                    </th>
                    <th
                      colSpan={3}
                      className="px-2 py-2 border-r border-b bg-red-50"
                    >
                      SALIDAS
                    </th>
                    <th colSpan={3} className="px-2 py-2 bg-blue-50 border-b">
                      SALDO FINAL
                    </th>
                  </tr>
                  <tr className="text-[11px]">
                    <th className="px-2 py-1 border-r font-medium">
                      TIPO (T10)
                    </th>
                    <th className="px-2 py-1 border-r font-medium">SERIE</th>
                    <th className="px-2 py-1 border-r font-medium">NÚMERO</th>

                    <th className="px-2 py-1 border-r font-medium bg-green-50">
                      CANT.
                    </th>
                    <th className="px-2 py-1 border-r font-medium bg-green-50">
                      C. UNIT.
                    </th>
                    <th className="px-2 py-1 border-r font-medium bg-green-50">
                      C. TOTAL
                    </th>

                    <th className="px-2 py-1 border-r font-medium bg-red-50">
                      CANT.
                    </th>
                    <th className="px-2 py-1 border-r font-medium bg-red-50">
                      C. UNIT.
                    </th>
                    <th className="px-2 py-1 border-r font-medium bg-red-50">
                      C. TOTAL
                    </th>

                    <th className="px-2 py-1 border-r font-medium bg-blue-50">
                      CANT.
                    </th>
                    <th className="px-2 py-1 border-r font-medium bg-blue-50">
                      C. UNIT.
                    </th>
                    <th className="px-2 py-1 font-medium bg-blue-50">
                      C. TOTAL
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {reporte.detalles.length === 0 ? (
                    <tr>
                      <td
                        colSpan={14}
                        className="px-4 py-8 text-center text-slate-500"
                      >
                        No hay movimientos registrados para este producto en el
                        rango de fechas.
                      </td>
                    </tr>
                  ) : (
                    reporte.detalles.map((fila, i) => {
                      const esEntrada = fila.entradaCantidad > 0;
                      const esSalida = fila.salidaCantidad > 0;
                      return (
                        <tr
                          key={i}
                          className="border-b hover:bg-slate-50 text-right font-mono text-xs"
                        >
                          <td className="px-2 py-2 text-center text-slate-800">
                            {format(new Date(fila.fecha), "dd/MM/yyyy")}
                          </td>
                          <td className="px-2 py-2 text-center text-slate-600 border-l">
                            {fila.tipoDocumentoSunat}
                          </td>
                          <td className="px-2 py-2 text-center text-slate-600">
                            {fila.serieDocumento}
                          </td>
                          <td className="px-2 py-2 text-center text-slate-600">
                            {fila.numeroDocumento}
                          </td>
                          <td className="px-2 py-2 text-center font-bold text-slate-700 border-x">
                            {fila.tipoOperacionSunat}
                          </td>

                          {/* ENTRADAS */}
                          <td
                            className={`px-2 py-2 ${esEntrada ? "text-green-700 font-semibold" : "text-slate-300"}`}
                          >
                            {fila.entradaCantidad || "-"}
                          </td>
                          <td
                            className={`px-2 py-2 ${esEntrada ? "text-green-700" : "text-slate-300"}`}
                          >
                            {esEntrada
                              ? formatearMoneda(fila.entradaCostoUnitario)
                              : "-"}
                          </td>
                          <td
                            className={`px-2 py-2 ${esEntrada ? "text-green-700 font-semibold border-r" : "text-slate-300 border-r"}`}
                          >
                            {esEntrada
                              ? formatearMoneda(fila.entradaCostoTotal)
                              : "-"}
                          </td>

                          {/* SALIDAS */}
                          <td
                            className={`px-2 py-2 ${esSalida ? "text-red-700 font-semibold" : "text-slate-300"}`}
                          >
                            {fila.salidaCantidad || "-"}
                          </td>
                          <td
                            className={`px-2 py-2 ${esSalida ? "text-red-700" : "text-slate-300"}`}
                          >
                            {esSalida
                              ? formatearMoneda(fila.salidaCostoUnitario)
                              : "-"}
                          </td>
                          <td
                            className={`px-2 py-2 ${esSalida ? "text-red-700 font-semibold border-r" : "text-slate-300 border-r"}`}
                          >
                            {esSalida
                              ? formatearMoneda(fila.salidaCostoTotal)
                              : "-"}
                          </td>

                          {/* SALDOS */}
                          <td className="px-2 py-2 font-bold text-blue-800 bg-blue-50/30">
                            {fila.saldoCantidad}
                          </td>
                          <td className="px-2 py-2 text-blue-700 bg-blue-50/30">
                            {formatearMoneda(fila.saldoCostoUnitario)}
                          </td>
                          <td className="px-2 py-2 font-bold text-blue-800 bg-blue-50/30">
                            {formatearMoneda(fila.saldoCostoTotal)}
                          </td>
                        </tr>
                      );
                    })
                  )}
                </tbody>
              </table>
            </div>
            
            {/* Controles de Paginación SUNAT */}
            <div className="bg-slate-50 border-t p-3 flex items-center justify-between text-sm">
              <div className="text-slate-500">
                Mostrando {((pageNumber - 1) * pageSize) + 1} a {Math.min(pageNumber * pageSize, reporte.totalItems)} de {reporte.totalItems} movimientos
              </div>
              <div className="flex items-center gap-4">
                <div className="flex items-center gap-2">
                  <span className="text-slate-500">Filas:</span>
                  <Select 
                    value={pageSize.toString()} 
                    onValueChange={(val) => {
                      const newSize = Number(val);
                      setPageSize(newSize);
                      buscarReporte(getValues(), 1, newSize);
                    }}
                  >
                    <SelectTrigger className="h-8 w-16">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {[50, 100, 200, 500].map(size => (
                        <SelectItem key={size} value={size.toString()}>{size}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="flex items-center gap-1">
                  <Button 
                    variant="outline" 
                    size="sm" 
                    className="h-8 w-8 p-0" 
                    disabled={pageNumber <= 1 || cargando}
                    onClick={() => buscarReporte(getValues(), pageNumber - 1, pageSize)}
                  >
                    &lt;
                  </Button>
                  <span className="px-2 font-medium">Página {pageNumber} de {reporte.totalPages}</span>
                  <Button 
                    variant="outline" 
                    size="sm" 
                    className="h-8 w-8 p-0" 
                    disabled={pageNumber >= reporte.totalPages || cargando}
                    onClick={() => buscarReporte(getValues(), pageNumber + 1, pageSize)}
                  >
                    &gt;
                  </Button>
                </div>
              </div>
            </div>
          </Card>
        )}
      </div>

      {/* AlertDialog de Sincronización */}
      <AlertDialog
        open={confirmarSincronizacion}
        onOpenChange={setConfirmarSincronizacion}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Sincronizar histórico?</AlertDialogTitle>
            <AlertDialogDescription>
              Este proceso realizará una <strong>limpieza total</strong> de los movimientos sincronizados previamente y reconstruirá el Kardex cronológicamente con horas estandarizadas. 
              Esto solucionará problemas de duplicados y ordenamiento incorrecto. ¿Desea continuar con el reinicio total?
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-primary text-primary-foreground hover:bg-primary/90"
              onClick={ejecutarSincronizacion}
              disabled={sincronizando}
            >
              {sincronizando ? "Sincronizando..." : "Sí, sincronizar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
