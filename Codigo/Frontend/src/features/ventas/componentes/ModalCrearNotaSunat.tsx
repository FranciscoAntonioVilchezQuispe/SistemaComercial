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
import { Loader2 } from "lucide-react";
import { MotivoNotaCredito, TipoComprobanteSunat } from "@/compartido/enums";
import { VentaDetalle } from "../tipos/ventas.types";
import { servicioVentas } from "../servicios/servicioVentas";
import { toast } from "sonner";

interface ModalCrearNotaSunatProps {
  idVenta: number | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalCrearNotaSunat({
  idVenta,
  open,
  onOpenChange,
  onSuccess,
}: ModalCrearNotaSunatProps) {
  const [venta, setVenta] = useState<VentaDetalle | null>(null);
  const [tipoNota, setTipoNota] = useState<TipoComprobanteSunat>(TipoComprobanteSunat.NotaCredito);
  const [motivoSunat, setMotivoSunat] = useState<string>("");
  const [sustento, setSustento] = useState("");
  const [afectaStock, setAfectaStock] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [isFetching, setIsFetching] = useState(false);

  useEffect(() => {
    if (open && idVenta) {
      cargarVenta(idVenta);
    } else {
      setVenta(null);
      setSustento("");
      setMotivoSunat("");
    }
  }, [open, idVenta]);

  const cargarVenta = async (id: number) => {
    try {
      setIsFetching(true);
      const data = await servicioVentas.obtenerVentaPorId(id);
      setVenta(data);
      setSustento(`Nota de Crédito por la venta ${data.serie}-${data.numero.toString().padStart(8, '0')}`);
      setMotivoSunat(MotivoNotaCredito.AnulacionOperacion);
    } catch (error) {
      toast.error("No se pudo cargar el detalle de la venta");
      onOpenChange(false);
    } finally {
      setIsFetching(false);
    }
  };

  if (!idVenta) return null;

  const handleGuardar = async () => {
    if (!venta) return;
    if (!motivoSunat || !sustento.trim()) {
      toast.error("Complete todos los campos obligatorios");
      return;
    }

    try {
      setIsLoading(true);
      
      const payload = {
        idVentaReferencia: venta.id,
        tipoNota: tipoNota,
        idTipoNota: parseInt(motivoSunat),
        motivoSustento: sustento,
        afectaStock: afectaStock,
        detalles: venta.detalles?.map(d => ({
          idProducto: d.idProducto,
          idVentaDetalle: d.id,
          descripcion: d.descripcionProducto || "Producto",
          cantidad: d.cantidad,
          precioUnitario: d.precioUnitario,
          subtotal: d.totalItem, // Usando los campos del nuevo DTO
          igv: d.impuestoItem,
          total: d.totalItem
        })) || []
      };

      if (tipoNota === TipoComprobanteSunat.NotaCredito) {
        await servicioVentas.crearNotaCredito(payload);
        toast.success("Nota de Crédito generada exitosamente");
      } else {
        await servicioVentas.crearNotaDebito(payload);
        toast.success("Nota de Débito generada exitosamente");
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
        {isFetching ? (
          <div className="flex flex-col items-center justify-center p-20 gap-4">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Cargando datos de la venta...</p>
          </div>
        ) : venta ? (
          <>
            <DialogHeader>
              <DialogTitle>Emitir Nota SUNAT (Referencia: {venta.serie}-{venta.numero.toString().padStart(8, '0')})</DialogTitle>
              <DialogDescription>
                Seleccione el tipo de nota e indique el motivo SUNAT correspondiente.
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
                      <SelectItem value={TipoComprobanteSunat.NotaCredito}>Nota de Crédito (07)</SelectItem>
                      <SelectItem value={TipoComprobanteSunat.NotaDebito}>Nota de Débito (08)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="motivoSunat" className="text-right font-bold text-xs">Motivo SUNAT</Label>
                <div className="col-span-3">
                  <Select value={motivoSunat} onValueChange={setMotivoSunat}>
                    <SelectTrigger id="motivoSunat">
                      <SelectValue placeholder="Seleccione Motivo SUNAT" />
                    </SelectTrigger>
                    <SelectContent>
                      {tipoNota === TipoComprobanteSunat.NotaCredito ? (
                        <>
                          <SelectItem value={MotivoNotaCredito.AnulacionOperacion}>01 - Anulación de la operación</SelectItem>
                          <SelectItem value={MotivoNotaCredito.DevolucionTotal}>06 - Devolución total</SelectItem>
                          <SelectItem value={MotivoNotaCredito.CorreccionPorErrorDescripcion}>03 - Corrección por error en descripción</SelectItem>
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
                  placeholder="Explicación detallada del motivo..." 
                  value={sustento}
                  onChange={(e) => setSustento(e.target.value)}
                />
              </div>

              <div className="flex items-center justify-between col-span-4 px-10">
                <div className="space-y-0.5">
                  <Label className="text-base">¿Afecta Inventario?</Label>
                  <p className="text-xs text-muted-foreground">
                    Si está activo, se realizará un movimiento de stock automático.
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
                {isLoading ? "Emitiendo..." : "Generar Documento"}
              </Button>
            </DialogFooter>
          </>
        ) : (
          <div className="p-10 text-center">Error al cargar datos.</div>
        )}
      </DialogContent>
    </Dialog>
  );
}
