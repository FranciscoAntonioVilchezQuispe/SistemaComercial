import { useEffect, useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
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
import { Printer, Loader2, FileText } from "lucide-react";
import { servicioVentas } from "@/features/ventas/servicios/servicioVentas";
import { servicioNotasCompra } from "@/features/compras/servicios/servicioNotasCompra";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { FISCAL_CONFIG } from "@compartido/configuracion/fiscal.config";

interface ModalVistaPreviaNotaSunatProps {
  id: number | null;
  tipo: 'NC' | 'ND';
  modulo: 'VENTAS' | 'COMPRAS';
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ModalVistaPreviaNotaSunat({
  id,
  tipo,
  modulo,
  open,
  onOpenChange,
}: ModalVistaPreviaNotaSunatProps) {
  const [nota, setNota] = useState<any>(null);
  const [cargando, setCargando] = useState(false);

  useEffect(() => {
    if (open && id) {
      cargarNota(id);
    } else {
      setNota(null);
    }
  }, [open, id, tipo, modulo]);

  const cargarNota = async (id: number) => {
    try {
      setCargando(true);
      let data;
      if (modulo === 'VENTAS') {
        data = tipo === 'NC' 
          ? await servicioVentas.obtenerNotaCreditoPorId(id)
          : await servicioVentas.obtenerNotaDebitoPorId(id);
      } else {
        data = tipo === 'NC'
          ? await servicioNotasCompra.obtenerDetalleCredito(id)
          : await servicioNotasCompra.obtenerDetalleDebito(id);
      }
      setNota(data);
    } catch (error) {
      console.error("Error al cargar detalle de nota:", error);
      onOpenChange(false);
    } finally {
      setCargando(false);
    }
  };

  const handleImprimir = () => {
    window.print();
  };

  const tituloNota = tipo === 'NC' ? 'NOTA DE CRÉDITO' : 'NOTA DE DÉBITO';
  const labelSujeto = modulo === 'VENTAS' ? 'Adquiriente / Cliente' : 'Proveedor';
  const nombreSujeto = modulo === 'VENTAS' ? nota?.clienteRazonSocial : nota?.proveedorRazonSocial;
  const docSujeto = modulo === 'VENTAS' ? nota?.clienteNroDoc : nota?.proveedorNroDoc;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto sm:rounded-xl p-0 gap-0 border-none bg-slate-50/50 backdrop-blur-sm">
        <DialogHeader className="p-6 pb-2 bg-white rounded-t-xl border-b">
          <div className="flex justify-between items-start">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg">
                <FileText className="h-6 w-6 text-primary" />
              </div>
              <div>
                <DialogTitle className="text-xl font-bold">Vista Previa de {tituloNota}</DialogTitle>
                <DialogDescription className="text-sm text-muted-foreground">Documento Electrónico</DialogDescription>
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
              <p className="text-sm text-muted-foreground animate-pulse">Cargando información...</p>
            </div>
          ) : nota ? (
            <div className="bg-white rounded-xl shadow-sm border p-8 mx-auto max-w-[500px] print:shadow-none print:border-none print:max-w-full print:p-0">
              {/* Encabezado */}
              <div className="text-center space-y-2 mb-6">
                <h2 className="text-2xl font-black tracking-tighter uppercase italic text-primary">Sistema Comercial</h2>
                <div className="py-2 border-y border-dashed my-4">
                  <h3 className="font-bold text-sm uppercase">
                    {tituloNota} ELECTRÓNICA
                  </h3>
                  <p className="text-xl font-mono tracking-widest font-bold">
                    {nota.serie}-{nota.numero || nota.id.toString().padStart(8, '0')}
                  </p>
                </div>
              </div>

              {/* Referencia */}
              <div className="bg-slate-50 p-3 rounded-lg border border-dashed text-xs mb-6">
                <p className="font-bold uppercase text-[10px] text-muted-foreground mb-1">Documento que modifica:</p>
                <p className="font-semibold">
                  {nota.tipoDocReferencia === '01' ? 'FACTURA' : 'BOLETA'}: {nota.serieReferencia}-{nota.numeroReferencia}
                </p>
                <p className="mt-1">
                  <span className="font-bold">Motivo:</span> {nota.motivoSustento}
                </p>
              </div>

              {/* Información del Sujeto */}
              <div className="grid grid-cols-2 gap-4 text-xs mb-6 border-b border-dashed pb-4">
                <div className="space-y-1 col-span-2 sm:col-span-1">
                  <p className="text-muted-foreground uppercase font-bold text-[10px]">{labelSujeto}</p>
                  <p className="font-semibold uppercase">{nombreSujeto}</p>
                  <p className="text-[10px] font-mono">DOC: {docSujeto}</p>
                </div>
                <div className="space-y-1 text-right col-span-2 sm:col-span-1">
                  <p className="text-muted-foreground uppercase font-bold text-[10px]">Fecha Emisión</p>
                  <p className="font-semibold">{formatearFechaHora(nota.fechaEmision || new Date())}</p>
                  <p className="text-[10px]">Moneda: {nota.moneda === 'PEN' ? 'Soles (PEN)' : nota.moneda}</p>
                </div>
              </div>

              {/* Tabla de Items */}
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
                    {nota.detalles?.map((item: any, index: number) => (
                      <TableRow key={index} className="hover:bg-transparent border-dashed">
                        <TableCell className="py-2 px-0 text-xs font-medium">{item.cantidad}</TableCell>
                        <TableCell className="py-2 text-xs">
                          <span className="font-medium block">{item.descripcion || "Detalle"}</span>
                          <span className="text-[10px] text-muted-foreground italic">P.Unit: {formatearMoneda(item.precioUnitario)}</span>
                        </TableCell>
                        <TableCell className="py-2 text-right px-0 text-xs font-bold">
                          {formatearMoneda(item.total)}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Totales */}
              <div className="space-y-1 border-t border-dashed pt-4 mb-6">
                <div className="flex justify-between text-xs">
                  <span className="text-muted-foreground text-[10px] font-bold">SUBTOTAL:</span>
                  <span>{formatearMoneda(nota.subtotal)}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-muted-foreground text-[10px] font-bold">
                    {FISCAL_CONFIG.TRIBUTOS.IGV === "1000" ? "I.G.V." : "Impuesto"} ({nota.porcentajeIgv || FISCAL_CONFIG.PORCENTAJE_IGV}%):
                  </span>
                  <span>{formatearMoneda(nota.igv)}</span>
                </div>
                <Separator className="my-2 border-dashed" />
                <div className="flex justify-between text-base font-black pt-1">
                  <span>TOTAL:</span>
                  <span className="text-primary">{formatearMoneda(nota.total)}</span>
                </div>
              </div>

              {/* Pie de Página */}
              <div className="text-center space-y-4 pt-4 border-t border-dashed">
                <div className="bg-green-50 text-green-700 py-1.5 px-3 rounded-full flex items-center justify-center gap-2 mx-auto w-fit border border-green-100">
                  <span className="text-[10px] font-bold uppercase tracking-wider">{nota.estado}</span>
                </div>
                <p className="text-[10px] text-muted-foreground italic">
                  Representación impresa de la {tituloNota} Electrónica.
                </p>
              </div>
            </div>
          ) : (
            <div className="text-center py-10 text-muted-foreground">
              No se encontró información del documento.
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
