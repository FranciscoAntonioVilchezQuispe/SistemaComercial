import { useState } from "react";
import { Receipt, Printer } from "lucide-react";
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
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Cliente } from "@/features/clientes/types/cliente.types";
import { ItemCarrito } from "../../tipos/ventas.types";
import { MetodoPago } from "./SelectorMetodoPago";
import { formatearMoneda } from "@compartido/utilidades/formateo/formatearMoneda";

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
  onConfirmar: (tipoComprobante: string) => Promise<void>;
}

const tiposComprobante = [
  { id: "BOLETA", nombre: "Boleta", descripcion: "Para consumidor final" },
  {
    id: "FACTURA",
    nombre: "Factura",
    descripcion: "Para empresas (requiere RUC)",
  },
  { id: "TICKET", nombre: "Ticket", descripcion: "Comprobante simple" },
];

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
}: DialogoFinalizarVentaProps) {
  const [tipoComprobante, setTipoComprobante] = useState("BOLETA");
  const [procesando, setProcesando] = useState(false);

  const handleConfirmar = async () => {
    setProcesando(true);
    try {
      await onConfirmar(tipoComprobante);
      onOpenChange(false);
    } catch (error) {
      console.error("Error al procesar venta:", error);
    } finally {
      setProcesando(false);
    }
  };

  const vuelto = montoPagado ? montoPagado - total : 0;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Receipt className="h-5 w-5" />
            Finalizar Venta
          </DialogTitle>
          <DialogDescription>
            Revisa los detalles y selecciona el tipo de comprobante
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4">
          {/* Resumen de items */}
          <div>
            <Label className="text-sm font-medium">
              Items ({carrito.length})
            </Label>
            <ScrollArea className="h-[150px] mt-2 border rounded-md p-3">
              <div className="space-y-2">
                {carrito.map((item, index) => (
                  <div key={index} className="flex justify-between text-sm">
                    <span className="flex-1">
                      {item.cantidad}x {item.producto.nombre}
                    </span>
                    <span className="font-medium">
                      {formatearMoneda(item.subtotal)}
                    </span>
                  </div>
                ))}
              </div>
            </ScrollArea>
          </div>

          {/* Cliente y Método de Pago */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label className="text-sm font-medium">Cliente</Label>
              <p className="text-sm mt-1">{cliente.razonSocial}</p>
              <p className="text-xs text-muted-foreground">
                {cliente.numeroDocumento}
              </p>
            </div>
            <div>
              <Label className="text-sm font-medium">Método de Pago</Label>
              <p className="text-sm mt-1">{metodoPago.nombre}</p>
              {montoPagado && vuelto > 0 && (
                <p className="text-xs text-muted-foreground">
                  Vuelto: {formatearMoneda(vuelto)}
                </p>
              )}
            </div>
          </div>

          <Separator />

          {/* Totales */}
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Subtotal:</span>
              <span>{formatearMoneda(subtotal)}</span>
            </div>
            {descuento > 0 && (
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Descuento:</span>
                <span className="text-destructive">
                  -{formatearMoneda(descuento)}
                </span>
              </div>
            )}
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">IGV (18%):</span>
              <span>{formatearMoneda(igv)}</span>
            </div>
            <Separator />
            <div className="flex justify-between text-lg font-bold">
              <span>Total:</span>
              <span className="text-primary">{formatearMoneda(total)}</span>
            </div>
          </div>

          <Separator />

          {/* Tipo de Comprobante */}
          <div>
            <Label className="text-sm font-medium">Tipo de Comprobante</Label>
            <RadioGroup
              value={tipoComprobante}
              onValueChange={setTipoComprobante}
              className="mt-2 space-y-2"
            >
              {tiposComprobante.map((tipo) => (
                <div
                  key={tipo.id}
                  className="flex items-center space-x-2 border rounded-lg p-3 hover:bg-accent cursor-pointer"
                >
                  <RadioGroupItem value={tipo.id} id={tipo.id} />
                  <Label htmlFor={tipo.id} className="flex-1 cursor-pointer">
                    <div>
                      <p className="font-medium">{tipo.nombre}</p>
                      <p className="text-xs text-muted-foreground">
                        {tipo.descripcion}
                      </p>
                    </div>
                  </Label>
                </div>
              ))}
            </RadioGroup>
          </div>
        </div>

        <DialogFooter className="gap-2">
          <Button
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={procesando}
          >
            Cancelar
          </Button>
          <Button
            onClick={handleConfirmar}
            disabled={procesando}
            className="gap-2"
          >
            <Printer className="h-4 w-4" />
            {procesando ? "Procesando..." : "Confirmar y Generar"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
