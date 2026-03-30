import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { MotivoNotaCredito, TipoComprobanteSunat } from "@/compartido/enums";
import { Compra } from "../types/compra.types";
import { registrarNotaCreditoCompra, registrarNotaDebitoCompra } from "../servicios/servicioCompras";
import { toast } from "sonner";

interface ModalCrearNotaSunatCompraProps {
  compra: Compra | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalCrearNotaSunatCompra({
  compra,
  open,
  onOpenChange,
  onSuccess,
}: ModalCrearNotaSunatCompraProps) {
  const [tipoNota, setTipoNota] = useState<TipoComprobanteSunat>(TipoComprobanteSunat.NotaCredito);
  const [motivoSunat, setMotivoSunat] = useState<string>("");
  const [sustento, setSustento] = useState("");
  const [afectaStock, setAfectaStock] = useState(true);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (open && compra) {
      setSustento(`Devolución al proveedor de la compra ${compra.serieComprobante}-${compra.numeroComprobante}`);
      setMotivoSunat(MotivoNotaCredito.DevolucionTotal);
    }
  }, [open, compra]);

  if (!compra) return null;

  const handleGuardar = async () => {
    if (!motivoSunat || !sustento.trim()) {
      toast.error("Complete todos los campos obligatorios");
      return;
    }

    try {
      setIsLoading(true);
      
      const payload = {
        idCompraReferencia: compra.id,
        tipoNota: tipoNota,
        idTipoNota: parseInt(motivoSunat),
        motivoSustento: sustento,
        afectaStock: afectaStock,
        detalles: compra.detalles?.map(d => ({
          idProducto: d.idProducto,
          idCompraDetalle: d.id,
          descripcion: d.nombreProducto || "Producto",
          cantidad: d.cantidad,
          precioUnitario: d.precioUnitarioCompra,
          subtotal: d.subtotal,
          igv: d.subtotal * 0.18, // Simplificado, idealmente viene de la compra
          total: d.subtotal * 1.18
        })) || []
      };

      if (tipoNota === TipoComprobanteSunat.NotaCredito) {
        await registrarNotaCreditoCompra(payload);
        toast.success("Nota de Crédito de Compra generada");
      } else {
        await registrarNotaDebitoCompra(payload);
        toast.success("Nota de Débito de Compra generada");
      }

      onSuccess();
      onOpenChange(false);
    } catch (error: any) {
      toast.error(error.message || "Error al generar la nota");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Nota SUNAT Proveedor (Ref: {compra.serieComprobante}-{compra.numeroComprobante})</DialogTitle>
          <DialogDescription>
            Documente devoluciones o cargos adicionales del proveedor.
          </DialogDescription>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="tipoNota" className="text-right font-bold">Tipo</Label>
            <div className="col-span-3">
              <Select 
                value={tipoNota} 
                onValueChange={(val: TipoComprobanteSunat) => setTipoNota(val)}
              >
                <SelectTrigger id="tipoNota">
                  <SelectValue placeholder="Seleccione Tipo de Nota" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={TipoComprobanteSunat.NotaCredito}>Nota de Crédito (07) - Salida</SelectItem>
                  <SelectItem value={TipoComprobanteSunat.NotaDebito}>Nota de Débito (08) - Ingreso Extra</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="motivoSunat" className="text-right font-bold text-xs">Motivo</Label>
            <div className="col-span-3">
              <Select value={motivoSunat} onValueChange={setMotivoSunat}>
                <SelectTrigger id="motivoSunat">
                  <SelectValue placeholder="Seleccione Motivo" />
                </SelectTrigger>
                <SelectContent>
                  {tipoNota === TipoComprobanteSunat.NotaCredito ? (
                    <>
                      <SelectItem value={MotivoNotaCredito.AnulacionOperacion}>01 - Anulación de la operación</SelectItem>
                      <SelectItem value={MotivoNotaCredito.DevolucionTotal}>06 - Devolución total</SelectItem>
                    </>
                  ) : (
                    <>
                      <SelectItem value="01">01 - Intereses por mora</SelectItem>
                      <SelectItem value="02">02 - Aumento en el valor</SelectItem>
                    </>
                  )}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="sustento" className="text-right font-bold">Sustento</Label>
            <Textarea 
              id="sustento" 
              className="col-span-3" 
              placeholder="Explicación del motivo..." 
              value={sustento}
              onChange={(e) => setSustento(e.target.value)}
            />
          </div>

          <div className="flex items-center justify-between col-span-4 px-10">
            <div className="space-y-0.5">
              <Label className="text-base">¿Reversar Almacén?</Label>
              <p className="text-xs text-muted-foreground">
                Si está activo, se ajustará el stock automáticamente.
              </p>
            </div>
            <Switch checked={afectaStock} onCheckedChange={setAfectaStock} />
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={isLoading}>
            Cancelar
          </Button>
          <Button onClick={handleGuardar} disabled={isLoading}>
            {isLoading ? "Registrando..." : "Confirmar Nota"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
