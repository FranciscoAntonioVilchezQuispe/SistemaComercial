import { useState } from "react";
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
import { AlertCircle } from "lucide-react";
import { servicioVentas } from "../servicios/servicioVentas";
import { toast } from "sonner";
import { VentaResumen } from "../tipos/ventas.types";
import { formatearFechaHora } from "@/compartido/utilidades";

interface ModalAnularVentaProps {
  venta: VentaResumen | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalAnularVenta({
  venta,
  open,
  onOpenChange,
  onSuccess,
}: ModalAnularVentaProps) {
  const [motivo, setMotivo] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  if (!venta) return null;

  const handleAnular = async () => {
    if (!motivo.trim()) {
      toast.error("Debe ingresar un motivo de anulación");
      return;
    }

    try {
      setIsLoading(true);
      // TODO: Obtener ID real del usuario desde AuthContext/Redux
      await servicioVentas.anularVenta(venta.id, motivo, 1);
      toast.success("Venta anulada correctamente");
      onSuccess();
      onOpenChange(false);
      setMotivo("");
    } catch (error: any) {
      console.error("Error al anular la venta:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const obtenerTiempoRestante = () => {
    const fechaRef = venta.fechaCreacion ? new Date(venta.fechaCreacion) : new Date(venta.fechaEmision);
    const limite24h = new Date(fechaRef.getTime() + 24 * 60 * 60 * 1000);
    const ahora = new Date();
    return {
      permitido: ahora <= limite24h,
      limite: limite24h
    };
  };

  const { permitido: puedeAnularDirectamente, limite } = obtenerTiempoRestante();

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Anular Venta: {venta.serie}-{venta.numero.toString().padStart(8, '0')}</DialogTitle>
          <DialogDescription>
            Tenga en cuenta las reglas de negocio de SUNAT para anulaciones.
          </DialogDescription>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          {!puedeAnularDirectamente && (
            <div className="bg-amber-50 border border-amber-200 rounded-md p-4 flex items-start gap-3">
              <AlertCircle className="h-5 w-5 text-amber-600 mt-0.5" />
              <div>
                <h5 className="font-bold text-amber-900 leading-none mb-1">Atención</h5>
                <p className="text-sm text-amber-800">
                  Ha vencido el plazo de 24 horas para la anulación directa (Límite: {formatearFechaHora(limite.toISOString())}).
                  <br />
                  <span className="font-semibold block mt-1">
                    Según normativa SUNAT (v1.0), debe emitir una Nota de Crédito para anular este documento.
                  </span>
                </p>
              </div>
            </div>
          )}

          <div className="space-y-2">
            <Label htmlFor="motivo">Motivo de Anulación</Label>
            <Textarea
              id="motivo"
              placeholder="Escriba el motivo por el cual anula este comprobante..."
              value={motivo}
              onChange={(e) => setMotivo(e.target.value)}
              className="min-h-[100px]"
            />
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={isLoading}>
            Cancelar
          </Button>
          <Button 
            variant="destructive" 
            onClick={handleAnular} 
            disabled={isLoading || (!puedeAnularDirectamente && venta.tipoComprobanteNombre === "FACTURA")}
          >
            {isLoading ? "Procesando..." : "Confirmar Anulación"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
