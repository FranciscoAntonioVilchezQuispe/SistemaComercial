import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/componentes/ui/dialog";
import { Button } from "@/componentes/ui/button";
import { useCotizacion } from "../../hooks/useVentas";
import { formatearMoneda, formatearFechaHora } from "@/compartido/utilidades";
import { Badge } from "@/componentes/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/componentes/ui/table";
import { Loader2, FileText, Printer, CheckCircle2 } from "lucide-react";

interface Props {
  id: number | null;
  isOpen: boolean;
  onClose: () => void;
  onConvertir?: (id: number) => void;
}

export function ModalDetalleCotizacion({ id, isOpen, onClose, onConvertir }: Props) {
  const { data: cotizacion, isLoading, isError } = useCotizacion(id || 0);

  if (!isOpen) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center justify-between">
            <div className="flex flex-col">
              <span>Detalle de Cotización: {cotizacion?.serie}-{cotizacion?.numero}</span>
              <span className="text-xs font-normal text-muted-foreground">
                ID Interno: {id}
              </span>
            </div>
            {cotizacion && (
              <Badge
                variant={
                  cotizacion.idEstado === 1 ? "default" : "secondary"
                }
              >
                {cotizacion.estadoNombre}
              </Badge>
            )}
          </DialogTitle>
        </DialogHeader>

        {isLoading ? (
          <div className="flex flex-col items-center justify-center py-12 gap-4">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Cargando información exhaustiva...</p>
          </div>
        ) : isError ? (
          <div className="py-8 text-center text-destructive">
            Error al cargar el detalle de la cotización.
          </div>
        ) : (
          <div className="space-y-6">
            {/* Cabecera Informativa */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 p-4 bg-muted/30 rounded-lg border">
              <div>
                <p className="text-xs font-semibold uppercase text-muted-foreground">Cliente</p>
                <p className="font-medium">{cotizacion?.clienteNombre || "Cliente General"}</p>
                <p className="text-xs text-muted-foreground">Moneda: {cotizacion?.moneda}</p>
              </div>
              <div>
                <p className="text-xs font-semibold uppercase text-muted-foreground">Emisión</p>
                <p className="font-medium">{formatearFechaHora(cotizacion?.fechaEmision || "")}</p>
                <p className="text-xs text-muted-foreground">
                  Vence: {formatearFechaHora(cotizacion?.fechaVencimiento || "")}
                </p>
              </div>
              <div>
                <p className="text-xs font-semibold uppercase text-muted-foreground">Totales</p>
                <p className="text-lg font-bold text-primary">
                  {formatearMoneda(cotizacion?.totalCotizacion || 0)}
                </p>
                <p className="text-xs text-muted-foreground">IGV Incluido</p>
              </div>
            </div>

            {/* Tabla de ítems */}
            <div className="border rounded-md">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Producto / Descripción</TableHead>
                    <TableHead className="text-right">Cant.</TableHead>
                    <TableHead className="text-right">P. Unit.</TableHead>
                    <TableHead className="text-right">IGV</TableHead>
                    <TableHead className="text-right font-bold">Total</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {cotizacion?.detalles.map((item: any) => (
                    <TableRow key={item.id}>
                      <TableCell className="max-w-[300px] truncate">
                        {item.descripcionProducto}
                      </TableCell>
                      <TableCell className="text-right">{item.cantidad.toFixed(2)}</TableCell>
                      <TableCell className="text-right">
                        {formatearMoneda(item.precioUnitario)}
                      </TableCell>
                      <TableCell className="text-right">
                        {formatearMoneda(item.impuestoItem)}
                      </TableCell>
                      <TableCell className="text-right font-medium">
                        {formatearMoneda(item.totalItem)}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            {/* Resumen de Totales Inferior */}
            <div className="flex justify-end">
              <div className="w-full md:w-64 space-y-2 border-t pt-2 mt-4">
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Subtotal Gravado:</span>
                  <span>{formatearMoneda(cotizacion?.subtotalGravado || 0)}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Impuesto (IGV):</span>
                  <span>{formatearMoneda(cotizacion?.totalImpuesto || 0)}</span>
                </div>
                <div className="flex justify-between font-bold text-lg pt-2 border-t">
                  <span>Total:</span>
                  <span className="text-primary">
                    {formatearMoneda(cotizacion?.totalCotizacion || 0)}
                  </span>
                </div>
              </div>
            </div>

            {cotizacion?.observaciones && (
              <div className="p-3 bg-blue-50/50 rounded-lg border border-blue-100 italic text-sm text-blue-800">
                <strong>Observaciones:</strong> {cotizacion.observaciones}
              </div>
            )}
          </div>
        )}

        <DialogFooter className="gap-2 sm:gap-0 mt-6">
          <div className="flex flex-wrap gap-2 justify-end w-full">
            <Button variant="outline" onClick={() => {}} title="Próximamente">
              <Printer className="mr-2 h-4 w-4" />
              Imprimir
            </Button>
            <Button variant="outline" onClick={() => {}} title="Próximamente">
              <FileText className="mr-2 h-4 w-4" />
              Ver PDF
            </Button>
            {cotizacion?.idEstado !== 1 && (
              <Button onClick={() => onConvertir?.(id!)}>
                <CheckCircle2 className="mr-2 h-4 w-4" />
                Convertir a Venta
              </Button>
            )}
            <Button variant="secondary" onClick={onClose}>
              Cerrar
            </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
