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
import { Compra } from "../types/compra.types";
import { anularCompra } from "../servicios/servicioCompras";
import { toast } from "sonner";
import { formatFecha } from "@/compartido/utilidades";

interface ModalAnularCompraProps {
  compra: Compra | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSuccess: () => void;
}

export function ModalAnularCompra({
  compra,
  open,
  onOpenChange,
  onSuccess,
}: ModalAnularCompraProps) {
  const [motivo, setMotivo] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  if (!compra) return null;

  const handleAnular = async () => {
    // 1. Validar tiempo (v1.0: 24 horas)
    const fechaRef = compra.fechaCreacion ? new Date(compra.fechaCreacion) : new Date(compra.fechaEmision);
    const limite24h = new Date(fechaRef.getTime() + 24 * 60 * 60 * 1000);
    const ahora = new Date();

    if (ahora > limite24h) {
      toast.error("No se puede anular directamente: Han pasado más de 24 horas. Use Nota de Crédito.");
      return;
    }

    if (!motivo.trim()) {
      toast.error("Debe ingresar un motivo de anulación");
      return;
    }

    try {
      setIsLoading(true);
      // TODO: Obtener ID real del usuario desde AuthContext/Redux
      await anularCompra(compra.id, motivo, 1); 
      toast.success("Compra anulada correctamente");
      onSuccess();
      onOpenChange(false);
      setMotivo("");
    } catch (error: any) {
      console.error("Error al anular la compra:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Anular Compra: {compra.serieComprobante}-{compra.numeroComprobante}</DialogTitle>
          <DialogDescription>
            Tenga en cuenta que esta acción revertirá el stock ingresado.
          </DialogDescription>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          <div className="bg-amber-50 border border-amber-200 rounded-md p-4 flex items-start gap-3">
            <AlertCircle className="h-5 w-5 text-amber-600 mt-0.5" />
            <div>
              <h5 className="font-bold text-amber-900 leading-none mb-1">Atención</h5>
              <p className="text-sm text-amber-800">
                Al anular esta compra del {formatFecha(new Date(compra.fechaEmision), "dd/MM/yyyy")}, se eliminarán los movimientos de almacén generados.
                <br />
                <span className="font-semibold text-amber-900 mt-2 block">
                  Regla v1.0: Solo permitido dentro de las primeras 24 horas del registro.
                </span>
              </p>
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="motivo">Motivo de Anulación</Label>
            <Textarea
              id="motivo"
              placeholder="Escriba el motivo por el cual anula este ingreso..."
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
            disabled={isLoading}
          >
            {isLoading ? "Procesando..." : "Confirmar Anulación"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
