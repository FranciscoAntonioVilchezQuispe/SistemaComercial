import { useEffect, useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Separator } from "@/components/ui/separator";
import { Printer, Loader2, CheckCircle2, Receipt, AlertCircle, XCircle } from "lucide-react";
import { Venta } from "../tipos/ventas.types";
import { servicioVentas } from "../servicios/servicioVentas";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { toast } from "sonner";
import { EstadoVenta } from "@compartido/enums";

interface ModalVistaPreviaVentaProps {
  idVenta: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ModalVistaPreviaVenta({
  idVenta,
  open,
  onOpenChange,
}: ModalVistaPreviaVentaProps) {
  const [venta, setVenta] = useState<Venta | null>(null);
  const [cargando, setCargando] = useState(false);

  useEffect(() => {
    if (open && idVenta) {
      cargarVenta(idVenta);
    } else {
      setVenta(null);
    }
  }, [open, idVenta]);

  const cargarVenta = async (id: number) => {
    try {
      setCargando(true);
      const data = await servicioVentas.obtenerVentaPorId(id);
      setVenta(data);
    } catch (error) {
      console.error("Error al cargar detalle de venta:", error);
      onOpenChange(false);
    } finally {
      setCargando(false);
    }
  };

  const handleImprimir = () => {
    window.print();
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto sm:rounded-xl p-0 gap-0 border-none bg-slate-50/50 backdrop-blur-sm">
        <DialogHeader className="p-6 pb-2 bg-white rounded-t-xl border-b">
          <div className="flex justify-between items-start">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg">
                <Receipt className="h-6 w-6 text-primary" />
              </div>
              <div>
                <DialogTitle className="text-xl font-bold">Vista Previa de Venta</DialogTitle>
                <p className="text-sm text-muted-foreground">Detalle completo de la transacción</p>
              </div>
            </div>
            <div className="flex gap-2 print:hidden">
              <Button variant="outline" size="sm" onClick={handleImprimir}>
                <Printer className="h-4 w-4 mr-2" />
                Imprimir
              </Button>
            </div>
          </div>
        </DialogHeader>

        <div className="p-6">
          {cargando ? (
            <div className="flex flex-col items-center justify-center py-20 gap-4">
              <Loader2 className="h-8 w-8 animate-spin text-primary" />
              <p className="text-sm text-muted-foreground animate-pulse">Cargando información de la venta...</p>
            </div>
          ) : venta ? (
            <div className="bg-white rounded-xl shadow-sm border p-8 mx-auto max-w-[500px] print:shadow-none print:border-none print:max-w-full print:p-0">
              {/* Encabezado del Ticket */}
              <div className="text-center space-y-2 mb-6">
                <h2 className="text-2xl font-black tracking-tighter uppercase italic text-primary">Sistema Comercial</h2>
                <p className="text-xs text-muted-foreground leading-tight">
                  AV. PRINCIPAL 123 - LIMA PERÚ<br />
                  RUC: 20600000001<br />
                  TEL: (01) 123-4567
                </p>
                <div className="py-2 border-y border-dashed my-4">
                  <h3 className="font-bold text-sm uppercase">
                    {venta.tipoComprobante || 'NOTA DE VENTA'}
                  </h3>
                  <p className="text-xl font-mono tracking-widest font-bold">
                    {venta.serie}-{venta.numeroFormateado}
                  </p>
                </div>
              </div>

              {/* Información del Cliente */}
              <div className="grid grid-cols-2 gap-4 text-xs mb-6">
                <div className="space-y-1">
                  <p className="text-muted-foreground uppercase font-bold text-[10px]">Cliente</p>
                  <p className="font-semibold uppercase">{venta.nombreCliente || "CLIENTE GENERAL"}</p>
                </div>
                <div className="space-y-1 text-right">
                  <p className="text-muted-foreground uppercase font-bold text-[10px]">Fecha Emisión</p>
                  <p className="font-semibold">{formatearFechaHora(venta.fechaEmision)}</p>
                </div>
              </div>

              {/* Tabla de Productos */}
              <div className="mb-6">
                <Table>
                  <TableHeader className="bg-slate-50/50">
                    <TableRow className="hover:bg-transparent border-dashed">
                      <TableHead className="h-8 text-[10px] uppercase font-bold px-0">Cant</TableHead>
                      <TableHead className="h-8 text-[10px] uppercase font-bold">Descripción</TableHead>
                      <TableHead className="h-8 text-[10px] uppercase font-bold text-right px-0">Total</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {venta.detalles?.map((item, index) => (
                      <TableRow key={index} className="hover:bg-transparent border-dashed">
                        <TableCell className="py-2 px-0 text-xs font-medium">{item.cantidad}</TableCell>
                        <TableCell className="py-2 text-xs">
                          <span className="font-medium block">{item.producto?.nombre || "Producto"}</span>
                          <span className="text-[10px] text-muted-foreground italic">P.Unit: {formatearMoneda(item.precioUnitario)}</span>
                        </TableCell>
                        <TableCell className="py-2 text-right px-0 text-xs font-bold">
                          {formatearMoneda(item.subtotal)}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Totales */}
              <div className="space-y-1 border-t border-dashed pt-4 mb-6">
                <div className="flex justify-between text-xs">
                  <span className="text-muted-foreground text-[10px] font-bold">SUBTOTAL GRAVADO:</span>
                  <span>{formatearMoneda(venta.subtotalGravado)}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-muted-foreground text-[10px] font-bold">I.G.V. (18%):</span>
                  <span>{formatearMoneda(venta.totalImpuesto)}</span>
                </div>
                <Separator className="my-2 border-dashed" />
                <div className="flex justify-between text-base font-black pt-1">
                  <span>TOTAL:</span>
                  <span className="text-primary">{formatearMoneda(venta.totalVenta)}</span>
                </div>
              </div>

              {/* Pie de Página */}
              <div className="text-center space-y-4 pt-4 border-t border-dashed">
                {venta.idEstado === EstadoVenta.Completada && (
                  <div className="bg-green-50 text-green-700 py-1.5 px-3 rounded-full flex items-center justify-center gap-2 mx-auto w-fit border border-green-100">
                    <CheckCircle2 className="h-3.5 w-3.5" />
                    <span className="text-[10px] font-bold uppercase tracking-wider">Transacción Completada</span>
                  </div>
                )}
                {venta.idEstado === EstadoVenta.PendientePago && (
                  <div className="bg-amber-50 text-amber-700 py-1.5 px-3 rounded-full flex items-center justify-center gap-2 mx-auto w-fit border border-amber-100">
                    <AlertCircle className="h-3.5 w-3.5" />
                    <span className="text-[10px] font-bold uppercase tracking-wider">Pendiente de Pago</span>
                  </div>
                )}
                {venta.idEstado === EstadoVenta.Anulada && (
                  <div className="bg-red-50 text-red-700 py-1.5 px-3 rounded-full flex items-center justify-center gap-2 mx-auto w-fit border border-red-100">
                    <XCircle className="h-3.5 w-3.5" />
                    <span className="text-[10px] font-bold uppercase tracking-wider">Venta Anulada</span>
                  </div>
                )}
                <p className="text-[10px] text-muted-foreground italic">
                  Gracias por su compra. ¡Vuelva pronto!<br />
                  Representación empresa de comprobante electrónico.
                </p>
                <div className="flex justify-center grayscale opacity-30 pt-2 pb-4">
                  {/* Simulación de código de barras/QR */}
                  <div className="h-10 w-40 bg-[repeating-linear-gradient(90deg,black,black_2px,transparent_2px,transparent_4px)]" />
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-10 text-muted-foreground">
              No se encontró información de la venta.
            </div>
          )}
        </div>

        <DialogFooter className="p-4 bg-slate-100/50 border-t print:hidden">
          <Button variant="ghost" className="w-full" onClick={() => onOpenChange(false)}>
            Cerrar Vista Previa
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
