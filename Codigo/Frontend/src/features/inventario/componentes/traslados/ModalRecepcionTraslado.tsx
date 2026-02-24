import { useState } from "react";
import { useRecibirTraslado } from "../../hooks/useTraslados";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertCircle } from "lucide-react";

interface Props {
  traslado: any;
  onSuccess: () => void;
  onCancel: () => void;
}

export function ModalRecepcionTraslado({
  traslado,
  onSuccess,
  onCancel,
}: Props) {
  const recibirTraslado = useRecibirTraslado();
  const [observaciones, setObservaciones] = useState("");
  const [detalles, setDetalles] = useState<any[]>(
    traslado.detalles.map((d: any) => ({
      productoId: d.productoId,
      nombre: d.productoNombre,
      cantidadDespachada: d.cantidadDespachada,
      cantidadRecibida: d.cantidadDespachada, // Por defecto recibimos todo
    })),
  );

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    recibirTraslado.mutate(
      {
        trasladoId: traslado.id,
        observaciones,
        detalles: detalles.map((d) => ({
          productoId: d.productoId,
          cantidadRecibida: d.cantidadRecibida,
        })),
      },
      {
        onSuccess: () => onSuccess(),
      },
    );
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 pt-4">
      <div className="bg-blue-50 p-3 rounded-md border border-blue-100 flex gap-2">
        <AlertCircle className="h-5 w-5 text-blue-600 shrink-0" />
        <div className="text-xs text-blue-800">
          Está confirmando la llegada del traslado{" "}
          <strong>{traslado.numeroTraslado}</strong> desde{" "}
          <strong>{traslado.almacenOrigenNombre}</strong>.
        </div>
      </div>

      <div className="border rounded-md overflow-hidden">
        <table className="w-full text-xs">
          <thead className="bg-slate-50">
            <tr>
              <th className="text-left p-2 border-b">Producto</th>
              <th className="text-right p-2 border-b">Despachado</th>
              <th className="text-center p-2 border-b w-24">Recibido</th>
            </tr>
          </thead>
          <tbody>
            {detalles.map((d, index) => (
              <tr
                key={d.productoId}
                className="border-b last:border-0 hover:bg-slate-50"
              >
                <td className="p-2 font-medium">{d.nombre}</td>
                <td className="p-2 text-right">{d.cantidadDespachada}</td>
                <td className="p-2 text-center">
                  <Input
                    type="number"
                    className="h-7 text-center font-bold"
                    value={d.cantidadRecibida}
                    onChange={(e) => {
                      const newDetalles = [...detalles];
                      newDetalles[index].cantidadRecibida = Number(
                        e.target.value,
                      );
                      setDetalles(newDetalles);
                    }}
                  />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="space-y-2">
        <Label className="text-sm">Observaciones de Recepción</Label>
        <Input
          value={observaciones}
          onChange={(e) => setObservaciones(e.target.value)}
          placeholder="Ej: Todo llegó conforme..."
        />
      </div>

      <div className="flex justify-end gap-2 pt-4 border-t">
        <Button variant="outline" type="button" onClick={onCancel}>
          Cerrar
        </Button>
        <Button
          type="submit"
          disabled={recibirTraslado.isPending}
          className="bg-green-600 hover:bg-green-700"
        >
          {recibirTraslado.isPending ? "Confirmando..." : "Confirmar Recepción"}
        </Button>
      </div>
    </form>
  );
}
