import { useState } from "react";
import { ShoppingCart, Trash2, Plus, Minus } from "lucide-react";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useCarrito } from "../../hooks/useCarrito";
import { formatearMoneda } from "@compartido/utilidades/formateo/formatearMoneda";
import { SelectorCliente } from "./SelectorCliente";
import { SelectorMetodoPago, MetodoPago } from "./SelectorMetodoPago";
import { DialogoFinalizarVenta } from "./DialogoFinalizarVenta";
import { Cliente } from "@/features/clientes/types/cliente.types";
import { toast } from "sonner";
import { useCrearVenta } from "../../hooks/useVentas";
import { VentaFormData, DetalleVentaFormData } from "../../tipos/ventas.types";

export function CarritoCompras() {
  const {
    items,
    subtotal,
    descuento,
    igv,
    total,
    actualizarCantidad,
    eliminarProducto,
    limpiarCarrito,
    obtenerCantidadItems,
  } = useCarrito();

  const [clienteSeleccionado, setClienteSeleccionado] =
    useState<Cliente | null>(null);
  const [metodoPagoSeleccionado, setMetodoPagoSeleccionado] =
    useState<MetodoPago>({
      id: 1,
      nombre: "Efectivo",
      codigo: "EFECTIVO",
      icono: null,
    });
  const [montoPagado, setMontoPagado] = useState<number>(total);
  const [dialogoOpen, setDialogoOpen] = useState(false);

  const crearVentaMutation = useCrearVenta();
  const cantidadTotal = obtenerCantidadItems();

  const handleMetodoPagoChange = (metodo: MetodoPago, monto?: number) => {
    setMetodoPagoSeleccionado(metodo);
    if (monto !== undefined) {
      setMontoPagado(monto);
    }
  };

  const handleProcesarVenta = () => {
    if (items.length === 0) {
      toast.error("El carrito está vacío");
      return;
    }

    if (metodoPagoSeleccionado.codigo === "EFECTIVO" && montoPagado < total) {
      toast.error("El monto recibido es insuficiente");
      return;
    }

    setDialogoOpen(true);
  };

  const handleConfirmarVenta = async (
    tipoComprobante: string,
    serie: string,
    numero: number,
  ) => {
    try {
      // Mapear tipo de comprobante a ID
      // Preparar detalles de venta
      const detalles: DetalleVentaFormData[] = items.map((item) => ({
        idProducto: item.producto.id,
        cantidad: item.cantidad,
        precioUnitario: item.precioUnitario,
        descuento: item.descuento,
      }));

      // Preparar datos de venta
      const ventaData: VentaFormData = {
        idCliente: clienteSeleccionado?.id || 0, // 0 = Público General
        idTipoComprobante: Number(tipoComprobante),
        idAlmacen: 1, // TODO: Obtener del contexto de usuario/sucursal. Por ahora 1.
        idMoneda: 1, // TODO: Selector de moneda. Por ahora 1 (Soles).
        serie: serie,
        numero: numero,
        tipoCambio: 1, // TODO: Obtener tipo de cambio actual.
        observaciones: `Método de pago: ${metodoPagoSeleccionado.nombre}`,
        detalles,
      };

      // Registrar venta
      await crearVentaMutation.mutateAsync(ventaData);

      toast.success("Venta registrada exitosamente");
      // Limpiar carrito y resetear estado
      limpiarCarrito();
      setClienteSeleccionado(null);
      setDialogoOpen(false);
    } catch (error) {
      console.error("Error al procesar la venta:", error);
      toast.error("Error al procesar la venta");
      throw error;
    }
  };

  return (
    <>
      <Card className="h-full flex flex-col">
        <CardHeader>
          <CardTitle className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <ShoppingCart className="h-5 w-5" />
              <span>Carrito</span>
            </div>
            {cantidadTotal > 0 && (
              <span className="text-sm font-normal text-muted-foreground">
                {cantidadTotal} {cantidadTotal === 1 ? "item" : "items"}
              </span>
            )}
          </CardTitle>
        </CardHeader>

        <CardContent className="flex-1 p-4 space-y-4 overflow-y-auto">
          {/* Selector de Cliente */}
          <SelectorCliente
            onSeleccionar={setClienteSeleccionado}
            clienteSeleccionado={clienteSeleccionado}
          />

          <Separator />

          {/* Items del Carrito */}
          {items.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-[200px] text-center">
              <ShoppingCart className="h-16 w-16 text-muted-foreground mb-4" />
              <p className="text-muted-foreground">El carrito está vacío</p>
              <p className="text-sm text-muted-foreground">
                Agrega productos para comenzar
              </p>
            </div>
          ) : (
            <ScrollArea className="h-[200px]">
              <div className="space-y-4">
                {items.map((item) => (
                  <div key={item.producto.id} className="space-y-2">
                    <div className="flex items-start justify-between gap-2">
                      <div className="flex-1 min-w-0">
                        <p className="font-medium truncate">
                          {item.producto.nombre}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {formatearMoneda(item.precioUnitario)}
                        </p>
                      </div>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="h-8 w-8 text-destructive"
                        onClick={() => eliminarProducto(item.producto.id)}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>

                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <Button
                          variant="outline"
                          size="icon"
                          className="h-8 w-8"
                          onClick={() =>
                            actualizarCantidad(
                              item.producto.id,
                              item.cantidad - 1,
                            )
                          }
                        >
                          <Minus className="h-3 w-3" />
                        </Button>
                        <Input
                          type="number"
                          value={item.cantidad}
                          onChange={(e) =>
                            actualizarCantidad(
                              item.producto.id,
                              parseInt(e.target.value) || 0,
                            )
                          }
                          className="w-16 text-center"
                        />
                        <Button
                          variant="outline"
                          size="icon"
                          className="h-8 w-8"
                          onClick={() =>
                            actualizarCantidad(
                              item.producto.id,
                              item.cantidad + 1,
                            )
                          }
                        >
                          <Plus className="h-3 w-3" />
                        </Button>
                      </div>
                      <p className="font-semibold">
                        {formatearMoneda(item.subtotal)}
                      </p>
                    </div>

                    <Separator />
                  </div>
                ))}
              </div>
            </ScrollArea>
          )}

          {items.length > 0 && (
            <>
              <Separator />

              {/* Selector de Método de Pago */}
              <SelectorMetodoPago
                total={total}
                onSeleccionar={handleMetodoPagoChange}
                metodoSeleccionado={metodoPagoSeleccionado}
              />
            </>
          )}
        </CardContent>

        {items.length > 0 && (
          <CardFooter className="flex-col gap-4 p-4 border-t">
            {/* Totales */}
            <div className="w-full space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Subtotal:</span>
                <span>{formatearMoneda(subtotal)}</span>
              </div>
              {descuento > 0 && (
                <div className="flex justify-between text-sm">
                  <span className="text-muted-foreground">Descuento:</span>
                  <span className="text-destructive">
                    -{formatearMoneda(descuento)}
                  </span>
                </div>
              )}
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">IGV (18%):</span>
                <span>{formatearMoneda(igv)}</span>
              </div>
              <Separator />
              <div className="flex justify-between text-lg font-bold">
                <span>Total:</span>
                <span className="text-primary">{formatearMoneda(total)}</span>
              </div>
            </div>

            {/* Acciones */}
            <div className="w-full flex gap-2">
              <Button
                variant="outline"
                className="flex-1"
                onClick={limpiarCarrito}
              >
                Limpiar
              </Button>
              <Button className="flex-1" onClick={handleProcesarVenta}>
                Procesar Venta
              </Button>
            </div>
          </CardFooter>
        )}
      </Card>

      {/* Diálogo Finalizar Venta */}
      <DialogoFinalizarVenta
        open={dialogoOpen}
        onOpenChange={setDialogoOpen}
        carrito={items}
        cliente={
          clienteSeleccionado || {
            id: 0,
            razonSocial: "Público General",
            numeroDocumento: "00000000",
            idTipoDocumento: 1,
            idTipoCliente: 1,
            email: "",
            telefono: "",
            direccion: "",
            activado: true,
          }
        }
        metodoPago={metodoPagoSeleccionado}
        subtotal={subtotal}
        descuento={descuento}
        igv={igv}
        total={total}
        montoPagado={montoPagado}
        onConfirmar={handleConfirmarVenta}
      />
    </>
  );
}
