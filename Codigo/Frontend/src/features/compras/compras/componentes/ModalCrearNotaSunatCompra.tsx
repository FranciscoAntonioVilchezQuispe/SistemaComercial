import { useState, useEffect } from "react";
import { 
  FileText, 
  MessageSquare, 
  RotateCcw, 
  CheckCircle2, 
  HelpCircle,
  Settings
} from "lucide-react";
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
      
      const compraDetalle = compra as any;
      
      const payload = {
        idCompraReferencia: compra.id,
        tipoNota: tipoNota,
        idTipoNota: parseInt(motivoSunat),
        motivoSustento: sustento,
        afectaStock: afectaStock,
        detalles: (compraDetalle.detalles || []).map((d: any) => ({
          idProducto: d.idProducto,
          idCompraDetalle: d.id,
          descripcion: d.nombreProducto || "Producto",
          cantidad: d.cantidad,
          precioUnitario: d.precioUnitarioCompra,
          subtotal: d.subtotal,
          igv: d.subtotal * 0.18, 
          total: d.subtotal * 1.18
        }))
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

        <div className="flex flex-col gap-5 py-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="tipoNota" className="flex items-center gap-1.5 font-semibold text-sm">
                <FileText className="h-4 w-4 text-primary" />
                Tipo de Nota
              </Label>
              <Select 
                value={tipoNota} 
                onValueChange={(val: TipoComprobanteSunat) => setTipoNota(val)}
              >
                <SelectTrigger id="tipoNota" className="bg-muted/30 border-muted-foreground/20">
                  <SelectValue placeholder="Seleccione Tipo" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value={TipoComprobanteSunat.NotaCredito}>Crédito (07)</SelectItem>
                  <SelectItem value={TipoComprobanteSunat.NotaDebito}>Débito (08)</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="motivoSunat" className="flex items-center gap-1.5 font-semibold text-sm">
                <Settings className="h-4 w-4 text-primary" />
                Motivo SUNAT
              </Label>
              <Select value={motivoSunat} onValueChange={setMotivoSunat}>
                <SelectTrigger id="motivoSunat" className="bg-muted/30 border-muted-foreground/20">
                  <SelectValue placeholder="Motivo" />
                </SelectTrigger>
                <SelectContent>
                  {tipoNota === TipoComprobanteSunat.NotaCredito ? (
                    <>
                      <SelectItem value={MotivoNotaCredito.AnulacionOperacion}>Anulación Operación</SelectItem>
                      <SelectItem value={MotivoNotaCredito.DevolucionTotal}>Devolución Total</SelectItem>
                    </>
                  ) : (
                    <>
                      <SelectItem value="01">Intereses por mora</SelectItem>
                      <SelectItem value="02">Aumento de valor</SelectItem>
                    </>
                  )}
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="sustento" className="flex items-center gap-1.5 font-semibold text-sm">
              <MessageSquare className="h-4 w-4 text-primary" />
              Sustento detallado
            </Label>
            <Textarea 
              id="sustento" 
              className="resize-none min-h-[90px] bg-muted/30 border-muted-foreground/20 focus:bg-background transition-colors" 
              placeholder="Describa el motivo de la nota..." 
              value={sustento}
              onChange={(e) => setSustento(e.target.value)}
            />
          </div>

          <div className="p-4 rounded-xl border border-primary/20 bg-primary/5 flex items-center justify-between group hover:bg-primary/10 transition-colors">
            <div className="flex gap-3 items-center">
              <div className="p-2.5 rounded-lg bg-primary/10 text-primary group-hover:scale-110 transition-transform">
                <RotateCcw className="h-5 w-5" />
              </div>
              <div className="space-y-0.5">
                <Label className="text-sm font-bold cursor-pointer" onClick={() => setAfectaStock(!afectaStock)}>
                  ¿Reversar Inventario?
                </Label>
                <p className="text-[11px] text-muted-foreground flex items-center gap-1">
                  <HelpCircle className="h-3 w-3" />
                  El stock se ajustará automáticamente
                </p>
              </div>
            </div>
            <Switch 
              checked={afectaStock} 
              onCheckedChange={setAfectaStock}
              className="data-[state=checked]:bg-primary"
            />
          </div>
        </div>

        <DialogFooter className="gap-2 sm:gap-0">
          <Button variant="ghost" onClick={() => onOpenChange(false)} disabled={isLoading} className="hover:bg-muted/50">
            Cerrar
          </Button>
          <Button 
            onClick={handleGuardar} 
            disabled={isLoading}
            className="gap-2 shadow-lg shadow-primary/20 font-bold"
          >
            {isLoading ? "Procesando..." : (
              <>
                <CheckCircle2 className="h-4 w-4" /> 
                Confirmar Nota
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
