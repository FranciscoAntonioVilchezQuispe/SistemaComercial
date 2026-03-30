import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { useMovimiento } from "../../hooks/useInventario";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { Badge } from "@/components/ui/badge";
import { Loader2, Box, Warehouse, User, Info, ArrowRight } from "lucide-react";

interface Props {
  id: number | null;
  isOpen: boolean;
  onClose: () => void;
}

export function ModalDetalleMovimiento({ id, isOpen, onClose }: Props) {
  const { data: movimiento, isLoading, isError } = useMovimiento(id || 0);

  if (!isOpen) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle className="flex items-center justify-between">
            <div className="flex flex-col">
              <span>Auditoría de Movimiento de Inventario</span>
              <span className="text-xs font-normal text-muted-foreground">
                ID Movimiento: {id}
              </span>
            </div>
            {movimiento && (
              <Badge variant="outline">
                {movimiento.tipoMovimientoNombre}
              </Badge>
            )}
          </DialogTitle>
        </DialogHeader>

        {isLoading ? (
          <div className="flex flex-col items-center justify-center py-12 gap-4">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
            <p className="text-sm text-muted-foreground">Cargando trazabilidad del stock...</p>
          </div>
        ) : isError ? (
          <div className="py-8 text-center text-destructive">
            Error al cargar el detalle del movimiento.
          </div>
        ) : (
          <div className="space-y-6">
            {/* Información Principal */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-4 bg-muted/20 rounded-lg border">
              <div className="flex items-start gap-3">
                <Box className="h-5 w-5 text-primary shrink-0 mt-1" />
                <div>
                  <p className="text-xs font-semibold uppercase text-muted-foreground">Producto</p>
                  <p className="font-medium">{movimiento?.productoNombre}</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Warehouse className="h-5 w-5 text-primary shrink-0 mt-1" />
                <div>
                  <p className="text-xs font-semibold uppercase text-muted-foreground">Almacén</p>
                  <p className="font-medium">{movimiento?.almacenNombre}</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <Info className="h-5 w-5 text-primary shrink-0 mt-1" />
                <div>
                  <p className="text-xs font-semibold uppercase text-muted-foreground">Referencia</p>
                  <p className="font-medium text-sm font-mono">
                    {movimiento?.referenciaModulo || "Manual"} - {movimiento?.idReferencia || "-"}
                  </p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <User className="h-5 w-5 text-primary shrink-0 mt-1" />
                <div>
                  <p className="text-xs font-semibold uppercase text-muted-foreground">Responsable</p>
                  <p className="font-medium">{movimiento?.usuarioCreacion || "Sistema"}</p>
                  <p className="text-xs text-muted-foreground">{formatearFechaHora(movimiento?.fechaCreacion || "")}</p>
                </div>
              </div>
            </div>

            {/* Análisis de Stock (Diferencial) */}
            <div className="space-y-3">
              <h4 className="text-sm font-bold flex items-center gap-2">
                <RefreshCw className="h-4 w-4" /> Análsis Diferencial de Stock
              </h4>
              <div className="grid grid-cols-3 gap-2 text-center p-3 border rounded-lg bg-white/50">
                <div className="flex flex-col">
                  <span className="text-xs text-muted-foreground">Stock Anterior</span>
                  <span className="text-xl font-bold">{movimiento?.cantidadAnterior.toFixed(2)}</span>
                </div>
                <div className="flex items-center justify-center">
                  <ArrowRight className="h-4 w-4 text-muted-foreground" />
                  <span className={`mx-2 font-bold ${movimiento?.cantidad && movimiento.cantidad > 0 ? 'text-green-600' : 'text-destructive'}`}>
                    {movimiento?.cantidad && movimiento.cantidad > 0 ? '+' : ''}{movimiento?.cantidad}
                  </span>
                </div>
                <div className="flex flex-col">
                  <span className="text-xs text-muted-foreground">Stock Nuevo</span>
                  <span className="text-xl font-bold text-primary">{movimiento?.cantidadNueva.toFixed(2)}</span>
                </div>
              </div>
            </div>

            {/* Valorización (Costo Promedio) */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="p-3 border rounded-lg">
                <p className="text-xs text-muted-foreground">Costo Unit. Movimiento</p>
                <p className="text-lg font-bold">{formatearMoneda(movimiento?.costoUnitarioMovimiento || 0)}</p>
              </div>
              <div className="p-3 border rounded-lg bg-blue-50/10">
                <p className="text-xs text-muted-foreground">Nuevo Costo Promedio</p>
                <p className="text-lg font-bold text-blue-700">{formatearMoneda(movimiento?.costoPromedioActual || 0)}</p>
              </div>
            </div>

            {/* Saldos Post-Movimiento */}
            <div className="p-4 bg-muted/10 border-t flex justify-between items-center rounded-b-lg">
              <div className="flex flex-col">
                <span className="text-xs text-muted-foreground">Saldo Kardex Cantidad</span>
                <span className="font-bold text-lg">{movimiento?.saldoCantidad.toFixed(2)}</span>
              </div>
              <div className="flex flex-col text-right">
                <span className="text-xs text-muted-foreground">Valorización Total (Stock)</span>
                <span className="font-bold text-lg text-primary">{formatearMoneda(movimiento?.saldoValorizado || 0)}</span>
              </div>
            </div>

            {movimiento?.observaciones && (
              <div className="p-3 bg-blue-50/50 rounded-lg border border-blue-100 italic text-sm text-blue-800">
                <strong>Observaciones:</strong> {movimiento.observaciones}
              </div>
            )}
          </div>
        )}

        <DialogFooter className="mt-4">
          <Button variant="secondary" onClick={onClose}>
            Cerrar Reporte
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// Icono extra necesario
import { RefreshCw } from "lucide-react";
