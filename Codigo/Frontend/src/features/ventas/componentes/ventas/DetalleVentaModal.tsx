import { Venta } from "../../tipos/ventas.types";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { formatearMoneda } from "@/compartido/utilidades/formateo/formatearMoneda";
import { formatearFechaHora } from "@/compartido/utilidades/formateo/formatearFecha";

interface Props {
  venta: Venta;
}

export function DetalleVentaModal({ venta }: Props) {
  return (
    <div className="space-y-6">
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div>
          <p className="text-sm font-medium text-muted-foreground">
            Comprobante
          </p>
          <p className="text-base font-bold">{venta.numeroComprobante}</p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Tipo</p>
          <p className="text-base">{venta.tipoComprobante}</p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Fecha</p>
          <p className="text-base">{formatearFechaHora(venta.fecha)}</p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Estado</p>
          <Badge>{venta.estado || "Completada"}</Badge>
        </div>
      </div>

      <Separator />

      <div className="space-y-2">
        <h3 className="text-lg font-bold">Información del Cliente</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Nombre / Razón Social
            </p>
            <p className="text-base">
              {venta.cliente?.razonSocial ||
                venta.cliente?.nombres ||
                "Cliente General"}
            </p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Número Documento
            </p>
            <p className="text-base">
              {venta.cliente?.numeroDocumento || "N/A"}
            </p>
          </div>
        </div>
      </div>

      <Separator />

      <div className="space-y-2">
        <h3 className="text-lg font-bold">Detalle de Productos</h3>
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Producto</TableHead>
                <TableHead className="text-right">Cant.</TableHead>
                <TableHead className="text-right">Precio</TableHead>
                <TableHead className="text-right">Desc.</TableHead>
                <TableHead className="text-right">Subtotal</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {venta.detalles.map((detalle, index) => (
                <TableRow key={index}>
                  <TableCell>
                    {detalle.producto?.nombre ||
                      `Producto #${detalle.idProducto}`}
                  </TableCell>
                  <TableCell className="text-right">
                    {detalle.cantidad}
                  </TableCell>
                  <TableCell className="text-right">
                    {formatearMoneda(detalle.precioUnitario)}
                  </TableCell>
                  <TableCell className="text-right">
                    {formatearMoneda(detalle.descuento)}
                  </TableCell>
                  <TableCell className="text-right font-medium">
                    {formatearMoneda(detalle.subtotal)}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>

      <div className="flex justify-end">
        <div className="w-full md:w-1/3 space-y-2">
          <div className="flex justify-between text-sm">
            <span>Subtotal:</span>
            <span>{formatearMoneda(venta.subtotal)}</span>
          </div>
          <div className="flex justify-between text-sm text-destructive">
            <span>Descuento:</span>
            <span>-{formatearMoneda(venta.descuento)}</span>
          </div>
          <div className="flex justify-between text-sm">
            <span>IGV (18%):</span>
            <span>{formatearMoneda(venta.igv)}</span>
          </div>
          <Separator />
          <div className="flex justify-between text-lg font-bold">
            <span>Total:</span>
            <span>{formatearMoneda(venta.total)}</span>
          </div>
        </div>
      </div>

      {venta.observaciones && (
        <div className="mt-4 p-4 bg-muted rounded-md text-sm">
          <p className="font-medium mb-1">Observaciones:</p>
          <p>{venta.observaciones}</p>
        </div>
      )}
    </div>
  );
}
