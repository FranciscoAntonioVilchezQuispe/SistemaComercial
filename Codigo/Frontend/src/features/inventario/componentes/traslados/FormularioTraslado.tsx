import { useState } from "react";
import { useAlmacenes, useStock } from "../../hooks/useInventario";
import { useCrearTraslado } from "../../hooks/useTraslados";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Trash2 } from "lucide-react";

interface Props {
  onSuccess: () => void;
  onCancel: () => void;
}

export function FormularioTraslado({ onSuccess, onCancel }: Props) {
  const { data: almacenes } = useAlmacenes();
  const crearTraslado = useCrearTraslado();

  const [origen, setOrigen] = useState<string>("");
  const [destino, setDestino] = useState<string>("");
  const [observaciones, setObservaciones] = useState("");
  const [detalles, setDetalles] = useState<
    { productoId: number; cantidad: number; nombre?: string }[]
  >([]);

  const { data: stockOrigen } = useStock({ idAlmacen: Number(origen) });

  const agregarProducto = (producto: any) => {
    if (!producto) return;
    if (detalles.find((d) => d.productoId === producto.idProducto)) return;
    setDetalles([
      ...detalles,
      {
        productoId: producto.idProducto,
        cantidad: 1,
        nombre: producto.nombreProducto,
      },
    ]);
  };

  const quitarProducto = (id: number) => {
    setDetalles(detalles.filter((d) => d.productoId !== id));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!origen || !destino || detalles.length === 0) return;

    crearTraslado.mutate(
      {
        almacenOrigenId: Number(origen),
        almacenDestinoId: Number(destino),
        observaciones,
        detalles: detalles.map((d) => ({
          productoId: d.productoId,
          cantidad: d.cantidad,
        })),
      },
      {
        onSuccess: () => onSuccess(),
      },
    );
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 pt-4">
      <div className="grid grid-cols-2 gap-4">
        <div className="space-y-2">
          <Label>Almacén Origen</Label>
          <Select onValueChange={setOrigen} value={origen}>
            <SelectTrigger>
              <SelectValue placeholder="Seleccionar" />
            </SelectTrigger>
            <SelectContent>
              {almacenes?.map((a: any) => (
                <SelectItem key={a.id} value={a.id.toString()}>
                  {a.nombreAlmacen || a.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-2">
          <Label>Almacén Destino</Label>
          <Select onValueChange={setDestino} value={destino}>
            <SelectTrigger>
              <SelectValue placeholder="Seleccionar" />
            </SelectTrigger>
            <SelectContent>
              {almacenes
                ?.filter((a: any) => a.id.toString() !== origen)
                .map((a: any) => (
                  <SelectItem key={a.id} value={a.id.toString()}>
                    {a.nombreAlmacen || a.nombre}
                  </SelectItem>
                ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="space-y-2">
        <Label>Producto</Label>
        <Select
          onValueChange={(val) => {
            const prod = stockOrigen?.datos?.find(
              (s: any) => s.idProducto === Number(val),
            );
            agregarProducto(prod);
          }}
        >
          <SelectTrigger>
            <SelectValue placeholder="Buscar producto en origen..." />
          </SelectTrigger>
          <SelectContent>
            {stockOrigen?.datos?.map((s: any) => (
              <SelectItem key={s.idProducto} value={s.idProducto.toString()}>
                {s.nombreProducto} (Stock: {s.cantidad})
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="border rounded-md p-4 space-y-2">
        <Label className="text-sm text-muted-foreground">
          Productos a Trasladar
        </Label>
        {detalles.map((d, index) => (
          <div
            key={d.productoId}
            className="flex items-center gap-2 border-b pb-2 last:border-0"
          >
            <div className="flex-1 text-sm font-medium">{d.nombre}</div>
            <Input
              type="number"
              className="w-24 h-8"
              value={d.cantidad}
              onChange={(e) => {
                const newDetalles = [...detalles];
                newDetalles[index].cantidad = Number(e.target.value);
                setDetalles(newDetalles);
              }}
            />
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8 text-destructive"
              onClick={() => quitarProducto(d.productoId)}
            >
              <Trash2 className="h-4 w-4" />
            </Button>
          </div>
        ))}
        {detalles.length === 0 && (
          <p className="text-center py-4 text-xs text-muted-foreground italic">
            No hay productos seleccionados
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label>Observaciones</Label>
        <Input
          value={observaciones}
          onChange={(e) => setObservaciones(e.target.value)}
          placeholder="Ej: Traslado por reposición de stock..."
        />
      </div>

      <div className="flex justify-end gap-2 pt-4 border-t">
        <Button variant="outline" type="button" onClick={onCancel}>
          Cancelar
        </Button>
        <Button type="submit" disabled={crearTraslado.isPending}>
          {crearTraslado.isPending ? "Procesando..." : "Despachar Traslado"}
        </Button>
      </div>
    </form>
  );
}
