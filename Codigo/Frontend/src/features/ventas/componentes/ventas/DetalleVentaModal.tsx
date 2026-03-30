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
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { EstadoVenta } from "@compartido/enums";

const ESTADO_VENTA_COLORES: Record<number, string> = {
  [EstadoVenta.Completada]: "bg-green-100 text-green-700 border-green-200 hover:bg-green-100",
  [EstadoVenta.PendientePago]: "bg-amber-100 text-amber-700 border-amber-200 hover:bg-amber-100",
  [EstadoVenta.Anulada]: "bg-red-100 text-red-700 border-red-200 hover:bg-red-100",
};

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
          <p className="text-base font-bold text-primary">
            {venta.serie}-{venta.numeroFormateado}
          </p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Tipo</p>
          <p className="text-base uppercase font-medium">{venta.tipoComprobante || 'NOTA DE VENTA'}</p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Fecha</p>
          <p className="text-base">{formatearFechaHora(venta.fechaEmision)}</p>
        </div>
        <div>
          <p className="text-sm font-medium text-muted-foreground">Estado</p>
          <Badge 
            variant="outline"
            className={ESTADO_VENTA_COLORES[venta.idEstado] || "bg-gray-100 text-gray-700"}
          >
            {venta.estado || "Completada"}
          </Badge>
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
            <p className="text-base font-medium">
              {venta.nombreCliente || "Cliente General"}
            </p>
          </div>
          <div>
            <p className="text-sm font-medium text-muted-foreground">
              Moneda
            </p>
            <p className="text-base uppercase">
              {venta.moneda} {venta.moneda === 'USD' ? `(TC: ${venta.tipoCambio})` : ''}
            </p>
          </div>
        </div>
      </div>

      <Separator />

      <div className="space-y-2">
        <h3 className="text-lg font-bold">Detalle de Productos</h3>
        <div className="rounded-md border overflow-hidden">
          <Table>
            <TableHeader className="bg-muted/50">
              <TableRow>
                <TableHead>Producto</TableHead>
                <TableHead className="text-right">Cant.</TableHead>
                <TableHead className="text-right">Precio</TableHead>
                <TableHead className="text-right">Desc.</TableHead>
                <TableHead className="text-right">Subtotal</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {venta.detalles?.map((detalle, index) => (
                <TableRow key={index}>
                  <TableCell>
                    <span className="font-medium">
                      {detalle.producto?.nombre || `Producto #${detalle.idProducto}`}
                    </span>
                  </TableCell>
                  <TableCell className="text-right">
                    {detalle.cantidad}
                  </TableCell>
                  <TableCell className="text-right">
                    {formatearMoneda(detalle.precioUnitario)}
                  </TableCell>
                  <TableCell className="text-right text-destructive">
                    {detalle.descuento > 0 ? `-${formatearMoneda(detalle.descuento)}` : '-'}
                  </TableCell>
                  <TableCell className="text-right font-bold">
                    {formatearMoneda(detalle.subtotal)}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>

      <div className="flex justify-end">
        <div className="w-full md:w-1/3 space-y-2 bg-slate-50 p-4 rounded-lg border">
          <div className="flex justify-between text-sm">
            <span className="text-muted-foreground uppercase font-bold text-[10px]">Subtotal Gravado:</span>
            <span className="font-medium">{formatearMoneda(venta.subtotalGravado)}</span>
          </div>
          {venta.totalDescuentoGlobal > 0 && (
            <div className="flex justify-between text-sm text-destructive">
              <span className="uppercase font-bold text-[10px]">Desc. Global:</span>
              <span className="font-medium">-{formatearMoneda(venta.totalDescuentoGlobal)}</span>
            </div>
          )}
          <div className="flex justify-between text-sm">
            <span className="text-muted-foreground uppercase font-bold text-[10px]">I.G.V. (18%):</span>
            <span className="font-medium">{formatearMoneda(venta.totalImpuesto)}</span>
          </div>
          <Separator className="my-2" />
          <div className="flex justify-between text-xl font-black">
            <span>TOTAL:</span>
            <span className="text-primary">{formatearMoneda(venta.totalVenta)}</span>
          </div>
        </div>
      </div>

      {venta.observaciones && (
        <div className="mt-4 p-4 bg-muted/30 rounded-md text-sm border-l-4 border-primary">
          <p className="font-bold mb-1 uppercase text-[10px] text-muted-foreground">Observaciones:</p>
          <p className="italic">"{venta.observaciones}"</p>
        </div>
      )}
    </div>
  );
}
