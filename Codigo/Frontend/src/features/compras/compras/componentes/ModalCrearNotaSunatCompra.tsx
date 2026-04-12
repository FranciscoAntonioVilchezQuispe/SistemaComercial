import { useState, useEffect } from "react";
import { 
  FileText, 
  MessageSquare, 
  RotateCcw, 
  CheckCircle2, 
  HelpCircle,
  Settings,
  Loader2
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
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { MotivoNotaCredito, TipoComprobanteSunat } from "@/compartido/enums";
import { CompraDetalle } from "../types/compra.types";
import { registrarNotaCreditoCompra, registrarNotaDebitoCompra, obtenerCompra } from "../servicios/servicioCompras";
import { toast } from "sonner";

interface ModalCrearNotaSunatCompraProps {
  idCompra: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalCrearNotaSunatCompra({
  idCompra,
  open,
  onOpenChange,
  onSuccess,
}: ModalCrearNotaSunatCompraProps) {
  const [compra, setCompra] = useState<CompraDetalle | null>(null);
  const [tipoNota, setTipoNota] = useState<TipoComprobanteSunat>(TipoComprobanteSunat.NotaCredito);
  const [motivoSunat, setMotivoSunat] = useState<string>("");
  const [sustento, setSustento] = useState("");
  const [serie, setSerie] = useState("");
  const [numero, setNumero] = useState("");
  const [afectaStock, setAfectaStock] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [fetching, setFetching] = useState(false);

  useEffect(() => {
    if (open && idCompra) {
      cargarDatosCompra(idCompra);
    } else {
      setCompra(null);
      setSerie("");
      setNumero("");
    }
  }, [open, idCompra]);

  const cargarDatosCompra = async (id: number) => {
    try {
      setFetching(true);
      const data = await obtenerCompra(id);
      setCompra(data);
      setSustento(`Devolución al proveedor de la compra ${data.serieComprobante}-${data.numeroComprobante}`);
      setMotivoSunat(MotivoNotaCredito.DevolucionTotal);
    } catch (error) {
      console.error("No se pudo cargar el detalle de la compra:", error);
      onOpenChange(false);
    } finally {
      setFetching(false);
    }
  };

  if (!idCompra) return null;

  const handleGuardar = async () => {
    if (!compra) return;
    if (!motivoSunat || !sustento.trim() || !serie.trim() || !numero.trim()) {
      toast.error("Complete todos los campos obligatorios (Serie y Número incluidos)");
      return;
    }

    try {
      setIsLoading(true);
      
      const payload = {
        idCompraReferencia: compra.id,
        serie: serie,
        numero: numero,
        tipoNota: tipoNota,
        idTipoNota: parseInt(motivoSunat),
        motivoSustento: sustento,
        afectaStock: afectaStock,
        subtotal: compra.subtotal,
        igv: compra.impuesto,
        total: compra.total,
        moneda: compra.moneda,
        tipoCambio: compra.tipoCambio,
        detalles: (compra.detalles || []).map((d: any) => ({
          idProducto: d.idProducto,
          idCompraDetalle: d.id,
          descripcion: d.nombreProducto || "Producto",
          cantidad: d.cantidad,
          precioUnitario: d.precioUnitarioCompra,
          subtotal: d.subtotal,
          igv: d.afectacionIgv || 0, 
          total: d.subtotal + (d.afectacionIgv || 0)
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
      console.error("Error al generar la nota:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[500px]">
        {fetching ? (
          <div className="flex flex-col items-center justify-center p-20 gap-4">
             <Loader2 className="h-8 w-8 animate-spin text-primary" />
             <p className="text-sm text-muted-foreground">Cargando datos de la compra...</p>
          </div>
        ) : compra ? (
          <>
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
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="serie" className="flex items-center gap-1.5 font-semibold text-sm">
                    Serie (Proveedor)
                  </Label>
                  <Input 
                    id="serie"
                    placeholder="Ej: F001"
                    value={serie}
                    onChange={(e) => setSerie(e.target.value.toUpperCase())}
                    className="bg-muted/30 border-muted-foreground/20 uppercase"
                    maxLength={10}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="numero" className="flex items-center gap-1.5 font-semibold text-sm">
                    Número (Proveedor)
                  </Label>
                  <Input 
                    id="numero"
                    placeholder="Ej: 00123"
                    value={numero}
                    onChange={(e) => setNumero(e.target.value)}
                    className="bg-muted/30 border-muted-foreground/20"
                    maxLength={20}
                  />
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
          </>
        ) : (
            <div className="p-10 text-center text-muted-foreground">Error al cargar la compra.</div>
        )}
      </DialogContent>
    </Dialog>
  );
}
