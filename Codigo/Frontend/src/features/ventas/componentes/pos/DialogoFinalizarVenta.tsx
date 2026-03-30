import { useState, useEffect } from "react";
import { Receipt, Printer, CheckCircle2, Ticket } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Cliente } from "@/features/clientes/types/cliente.types";
import { ItemCarrito } from "../../tipos/ventas.types";
import { MetodoPago } from "./SelectorMetodoPago";
import { useSeries } from "../../hooks/useVentas";
import { formatearMoneda } from "@compartido/utilidades/moneda";

import { useTipoComprobante } from "@/features/configuracion/hooks/useTipoComprobante";
import { useComprobantesPorDocumento } from "@/features/configuracion/hooks/useComprobantesPorDocumento";
import { useTiposOperacionSunat } from "@/features/configuracion/hooks/useTiposOperacionSunat";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

interface DialogoFinalizarVentaProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  carrito: ItemCarrito[];
  cliente: Cliente;
  metodoPago: MetodoPago;
  subtotal: number;
  descuento: number;
  igv: number;
  total: number;
  montoPagado?: number;
  onConfirmar: (
    tipoComprobante: string,
    serie: string,
    numero: number,
    tipoOperacion?: string,
  ) => Promise<any>;
  tipoComprobanteSeleccionado?: string;
}

export function DialogoFinalizarVenta({
  open,
  onOpenChange,
  carrito,
  cliente,
  metodoPago,
  subtotal,
  descuento,
  igv,
  total,
  montoPagado,
  onConfirmar,
  tipoComprobanteSeleccionado,
}: DialogoFinalizarVentaProps) {
  // Carga filtrada de comprobantes segun el documento del cliente (DNI/RUC)
  const { data: tiposComprobanteRules = [] } =
    useComprobantesPorDocumento(cliente.idTipoDocumento?.toString());

  // Si no hay reglas (cliente nuevo o error), fallback al hook general
  const { data: pagedTiposGen } = useTipoComprobante("VENTA");

  const tiposComprobante =
    tiposComprobanteRules.length > 0 ? tiposComprobanteRules : (pagedTiposGen?.datos || []);

  const { data: tiposOperacion = [] } =
    useTiposOperacionSunat();

  const [tipoComprobante, setTipoComprobante] = useState(
    tipoComprobanteSeleccionado || "",
  );
  const [tipoOperacion, setTipoOperacion] = useState("0101"); // Venta Interna por defecto
  const [procesando, setProcesando] = useState(false);
  const [serieSeleccionada, setSerieSeleccionada] = useState<any>(null);
  const [ventaExitosa, setVentaExitosa] = useState<any>(null);

  useEffect(() => {
    if (tipoComprobanteSeleccionado) {
      setTipoComprobante(tipoComprobanteSeleccionado);
    }
  }, [tipoComprobanteSeleccionado]);

  // Resetear estado al abrir
  useEffect(() => {
    if (open) {
      setVentaExitosa(null);
    }
  }, [open]);

  // Seleccionar el primero por defecto
  useEffect(() => {
    if (tiposComprobante.length > 0 && !tipoComprobante) {
      setTipoComprobante(tiposComprobante[0].id.toString());
    }
  }, [tiposComprobante, tipoComprobante]);

  const { data: series } = useSeries(
    Number(tipoComprobante) || 0,
  );

  useEffect(() => {
    if (series && series.length > 0) {
      setSerieSeleccionada(series[0]);
    } else {
      setSerieSeleccionada(null);
    }
  }, [series]);

  const handleConfirmar = async () => {
    if (!serieSeleccionada) {
      return;
    }
    setProcesando(true);
    try {
      const resultado = await onConfirmar(
        tipoComprobante,
        serieSeleccionada.serie,
        serieSeleccionada.correlativoActual + 1,
        tipoOperacion,
      );
      setVentaExitosa(resultado);
    } catch (error) {
      console.error("Error al procesar venta:", error);
    } finally {
      setProcesando(false);
    }
  };

  const vuelto = montoPagado ? (montoPagado - total) : 0;

  return (
    <Dialog open={open} onOpenChange={(val) => !procesando && onOpenChange(val)}>
      <DialogContent className="max-w-2xl overflow-hidden">
        <AnimatePresence mode="wait">
          {!ventaExitosa ? (
            <motion.div
              key="formulario"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              className="space-y-4"
            >
              <DialogHeader>
                <DialogTitle className="flex items-center gap-2">
                  <Receipt className="h-5 w-5" />
                  Finalizar Venta
                </DialogTitle>
                <DialogDescription>
                  Revisa los detalles y selecciona el tipo de comprobante
                </DialogDescription>
              </DialogHeader>

              {/* Items y Totales */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-4">
                    <div>
                      <Label className="text-xs font-bold uppercase text-muted-foreground flex justify-between">
                        <span>Resumen</span>
                        <span className="text-primary/70">{metodoPago.nombre}</span>
                      </Label>
                      <ScrollArea className="h-[120px] mt-2 border rounded-md p-3 bg-muted/20">
                      <div className="space-y-2">
                        {carrito.map((item, index) => (
                          <div key={index} className="flex justify-between text-xs">
                            <span className="flex-1 truncate">
                              {item.cantidad}x {item.producto.nombre}
                            </span>
                            <span className="font-medium ml-2">
                              {formatearMoneda(item.subtotal)}
                            </span>
                          </div>
                        ))}
                      </div>
                    </ScrollArea>
                  </div>

                  <div className="space-y-2 p-3 border rounded-md bg-accent/50 text-sm">
                    <div className="flex justify-between text-xs text-muted-foreground">
                      <span>Subtotal:</span>
                      <span>{formatearMoneda(subtotal)}</span>
                    </div>
                    {descuento > 0 && (
                      <div className="flex justify-between text-xs text-destructive">
                        <span>Descuento:</span>
                        <span>-{formatearMoneda(descuento)}</span>
                      </div>
                    )}
                    <div className="flex justify-between text-xs text-muted-foreground">
                      <span>IGV (18%):</span>
                      <span>{formatearMoneda(igv)}</span>
                    </div>
                    <Separator className="my-2" />
                    <div className="flex justify-between font-bold text-base">
                      <span>Total a Pagar:</span>
                      <span className="text-primary">{formatearMoneda(total)}</span>
                    </div>
                    {montoPagado && montoPagado > 0 && (
                      <>
                        <div className="flex justify-between text-muted-foreground pt-1 border-t mt-1 border-dashed">
                          <span>Pago con:</span>
                          <span>{formatearMoneda(montoPagado)}</span>
                        </div>
                        <div className="flex justify-between font-medium">
                          <span>Vuelto:</span>
                          <span className={`${vuelto > 0 ? "text-green-600" : ""}`}>
                            {formatearMoneda(Math.max(0, vuelto))}
                          </span>
                        </div>
                      </>
                    )}
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="space-y-2">
                    <Label className="text-xs font-bold uppercase text-muted-foreground">Comprobante</Label>
                    <div className="grid grid-cols-2 gap-2">
                      {tiposComprobante.map((tipo) => (
                        <button
                          key={tipo.id}
                          className={`flex flex-col items-center justify-center p-2 border rounded-lg transition-all ${
                            tipoComprobante === tipo.id.toString()
                              ? "border-primary bg-primary/10 text-primary"
                              : "hover:bg-muted"
                          }`}
                          onClick={() => setTipoComprobante(tipo.id.toString())}
                        >
                          <span className="text-xs font-bold">{tipo.nombre}</span>
                        </button>
                      ))}
                    </div>
                  </div>

                    <div className="space-y-2">
                      <Label className="text-xs font-bold uppercase text-muted-foreground">Operación SUNAT</Label>
                      <Select value={tipoOperacion} onValueChange={setTipoOperacion}>
                        <SelectTrigger className="w-full h-10 text-xs font-medium">
                          <SelectValue placeholder="Seleccione operación" />
                        </SelectTrigger>
                        <SelectContent>
                          {tiposOperacion.map((op: any) => (
                            <SelectItem key={op.id} value={op.codigo} className="text-xs">
                              {op.codigo} - {op.nombre}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                </div>
              </div>

              <DialogFooter className="pt-4 border-t">
                <Button variant="ghost" onClick={() => onOpenChange(false)} disabled={procesando}>
                  Atrás
                </Button>
                <Button onClick={handleConfirmar} disabled={procesando || !serieSeleccionada} className="px-8 gap-2">
                   {procesando ? (
                     <div className="h-4 w-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                   ) : <Printer className="h-4 w-4" />}
                   {procesando ? "Procesando..." : "Confirmar Pago"}
                </Button>
              </DialogFooter>
            </motion.div>
          ) : (
            <motion.div
              key="exito"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="py-12 flex flex-col items-center text-center space-y-6"
            >
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ type: "spring", damping: 10, stiffness: 100, delay: 0.2 }}
                className="h-20 w-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center"
              >
                <CheckCircle2 className="h-12 w-12" />
              </motion.div>

              <div className="space-y-2">
                <h2 className="text-3xl font-black text-foreground">¡Venta Exitosa!</h2>
                <p className="text-muted-foreground">La operación se ha procesado correctamente.</p>
              </div>

              <div className="w-full max-w-sm bg-muted/30 border border-dashed border-muted-foreground/30 rounded-2xl p-6 relative overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-1 bg-green-500" />
                
                <div className="flex items-center justify-between mb-4">
                   <Ticket className="h-5 w-5 text-muted-foreground" />
                   <span className="text-xs font-bold text-muted-foreground uppercase tracking-widest">Resumen de Comprobante</span>
                </div>

                <div className="space-y-4">
                  <div>
                    <p className="text-4xl font-mono font-black text-primary tracking-tighter">
                      {ventaExitosa.serie}-{ventaExitosa.numero?.toString().padStart(8, "0")}
                    </p>
                    <p className="text-sm font-medium mt-1">{ventaExitosa.tipoComprobante || (Number(tipoComprobante) === 1 ? "Factura" : "Boleta")}</p>
                  </div>

                  <div className="grid grid-cols-2 gap-4 text-left border-t pt-4">
                    <div>
                      <p className="text-xs font-bold text-muted-foreground uppercase">Cliente</p>
                      <p className="text-sm font-semibold truncate">{cliente.razonSocial}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs font-bold text-muted-foreground uppercase">Total</p>
                      <p className="text-lg font-bold text-primary">{formatearMoneda(ventaExitosa.totalVenta || total)}</p>
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex flex-col w-full gap-3 pt-4">
                <Button size="lg" className="h-14 text-lg font-bold gap-3 shadow-lg shadow-green-500/20 bg-green-600 hover:bg-green-700">
                  <Printer className="h-6 w-6" />
                  Imprimir Comprobante
                </Button>
                <div className="grid grid-cols-2 gap-3">
                  <Button variant="outline" size="lg" className="h-12 border-2" onClick={() => onOpenChange(false)}>
                    Nuevos Productos
                  </Button>
                  <Button variant="secondary" size="lg" className="h-12" onClick={() => {
                    onOpenChange(false);
                    // Podríamos navegar al listado de ventas aquí si fuera necesario
                  }}>
                    Ver Historial
                  </Button>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
}
