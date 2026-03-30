import { useState } from "react";
import { CreditCard, Banknote, Smartphone } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Card } from "@/components/ui/card";
import { formatearMoneda } from "@compartido/utilidades/moneda";
import { limpiarDecimal } from "@compartido/utilidades/string";

export interface MetodoPago {
  id: number;
  nombre: string;
  codigo: string;
  icono: React.ReactNode;
}

const metodosPago: MetodoPago[] = [
  {
    id: 1,
    nombre: "Efectivo",
    codigo: "EFECTIVO",
    icono: <Banknote className="h-5 w-5" />,
  },
  {
    id: 2,
    nombre: "Tarjeta",
    codigo: "TARJETA",
    icono: <CreditCard className="h-5 w-5" />,
  },
  {
    id: 3,
    nombre: "Transferencia",
    codigo: "TRANSFERENCIA",
    icono: <Smartphone className="h-5 w-5" />,
  },
];

interface SelectorMetodoPagoProps {
  total: number;
  onSeleccionar: (metodo: MetodoPago, montoPagado?: number) => void;
  metodoSeleccionado?: MetodoPago;
}

export function SelectorMetodoPago({
  total,
  onSeleccionar,
  metodoSeleccionado,
}: SelectorMetodoPagoProps) {
  const [metodoId, setMetodoId] = useState<string>(
    metodoSeleccionado?.id.toString() || "1",
  );
  const [montoPagado, setMontoPagado] = useState<string>(total.toString());

  const montoNumerico = parseFloat(montoPagado) || 0;
  const metodoActual = metodosPago.find((m) => m.id.toString() === metodoId);
  const vuelto = metodoActual?.codigo === "EFECTIVO" ? Math.round((montoNumerico - total) * 100) / 100 : 0;

  const handleSeleccionar = (id: string) => {
    setMetodoId(id);
    const metodo = metodosPago.find((m) => m.id.toString() === id);
    if (metodo) {
      onSeleccionar(metodo, metodo.codigo === "EFECTIVO" ? montoNumerico : total);
    }
  };

  const handleMontoPagadoChange = (stringValor: string) => {
    const limpio = limpiarDecimal(stringValor);
    setMontoPagado(limpio);
    if (metodoActual) {
      onSeleccionar(metodoActual, parseFloat(limpio) || 0);
    }
  };

  return (
    <div className="space-y-4">
      <div>
        <Label className="text-sm font-medium">Método de Pago</Label>
        <RadioGroup
          value={metodoId}
          onValueChange={handleSeleccionar}
          className="grid grid-cols-3 gap-2 mt-2"
        >
          {metodosPago.map((metodo) => (
            <div key={metodo.id}>
              <RadioGroupItem
                value={metodo.id.toString()}
                id={`metodo-${metodo.id}`}
                className="peer sr-only"
              />
              <Label
                htmlFor={`metodo-${metodo.id}`}
                className="flex flex-col items-center justify-center rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary [&:has([data-state=checked])]:border-primary cursor-pointer"
              >
                {metodo.icono}
                <span className="text-xs mt-2">{metodo.nombre}</span>
              </Label>
            </div>
          ))}
        </RadioGroup>
      </div>

      {metodoActual?.codigo === "EFECTIVO" && (
        <Card className="p-4 space-y-3">
          <div className="space-y-2">
            <Label htmlFor="monto-pagado">Monto Recibido</Label>
            <Input
              id="monto-pagado"
              type="text"
              inputMode="decimal"
              value={montoPagado}
              onChange={(e) => handleMontoPagadoChange(e.target.value)}
              className="text-lg font-semibold"
              placeholder="0.00"
            />
          </div>

          <div className="flex justify-between items-center pt-2 border-t">
            <span className="text-sm text-muted-foreground">Vuelto:</span>
            <span
              className={`text-lg font-bold ${
                vuelto < 0 ? "text-destructive" : "text-green-600"
              }`}
            >
              {formatearMoneda(Math.max(0, vuelto))}
            </span>
          </div>

          {Math.round(montoNumerico * 100) < Math.round(total * 100) && (
            <p className="text-xs text-destructive">
              El monto recibido es insuficiente
            </p>
          )}
        </Card>
      )}

      <div className="flex justify-between items-center p-3 bg-muted rounded-lg">
        <span className="font-medium">Total a Pagar:</span>
        <span className="text-xl font-bold text-primary">
          {formatearMoneda(total)}
        </span>
      </div>
    </div>
  );
}
