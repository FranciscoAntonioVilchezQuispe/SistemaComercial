import { MoveDown, MoveUp, RefreshCw, ArrowLeftRight } from "lucide-react";
import { MovimientoInventario } from "../../tipos/inventario.types";
import { TablaPaginada } from "@/compartido/componentes/tablas/TablaPaginada";
import { formatearFechaHora } from "@compartido/utilidades";

interface Props {
  movimientos: MovimientoInventario[];
  isLoading: boolean;
}

export function TablaMovimientos({ movimientos, isLoading }: Props) {
  const getIconoTipo = (idTipo: number) => {
    switch (idTipo) {
      case 1:
        return <MoveUp className="h-4 w-4 text-green-500" />; // Entrada
      case 2:
        return <MoveDown className="h-4 w-4 text-destructive" />; // Salida
      case 3:
        return <RefreshCw className="h-4 w-4 text-blue-500" />; // Ajuste
      case 4:
        return <ArrowLeftRight className="h-4 w-4 text-orange-500" />; // Traslado
      default:
        return null;
    }
  };

  const columnas = [
    {
      clave: "fecha",
      titulo: "Fecha y Hora",
      renderizar: (m: MovimientoInventario) => formatearFechaHora(m.fecha),
    },
    {
      clave: "producto",
      titulo: "Producto",
      renderizar: (m: MovimientoInventario) => (
        <span className="font-medium">
          {m.producto?.nombre || `Producto #${m.idProducto}`}
        </span>
      ),
    },
    {
      clave: "tipoMovimiento",
      titulo: "Tipo",
      renderizar: (m: MovimientoInventario) => (
        <div className="flex items-center gap-2">
          {getIconoTipo(m.idTipoMovimiento)}
          <span>{m.tipoMovimiento}</span>
        </div>
      ),
    },
    {
      clave: "entrada",
      titulo: "Entradas",
      renderizar: (m: MovimientoInventario) =>
        m.idTipoMovimiento === 1 || m.idTipoMovimiento === 3 ? (
          <div className="flex flex-col text-right">
            <span className="text-green-600 font-bold">+{m.cantidad}</span>
            <span className="text-xs text-muted-foreground">
              {m.precioCosto ? `S/ ${m.precioCosto.toFixed(2)}` : "-"}
            </span>
          </div>
        ) : (
          "-"
        ),
    },
    {
      clave: "salida",
      titulo: "Salidas",
      renderizar: (m: MovimientoInventario) =>
        m.idTipoMovimiento === 2 ? (
          <div className="flex flex-col text-right">
            <span className="text-destructive font-bold">-{m.cantidad}</span>
            <span className="text-xs text-muted-foreground">
              {m.costoPromedioActual
                ? `S/ ${m.costoPromedioActual.toFixed(2)}`
                : "-"}
            </span>
          </div>
        ) : (
          "-"
        ),
    },
    {
      clave: "saldo",
      titulo: "Saldos (Kardex)",
      renderizar: (m: MovimientoInventario) => (
        <div className="flex flex-col text-right bg-blue-50/50 p-1 rounded">
          <span className="font-bold">{m.saldoCantidad}</span>
          <span className="text-xs font-medium text-blue-700">
            CP: S/ {m.costoPromedioActual.toFixed(4)}
          </span>
          <span className="text-[10px] text-muted-foreground">
            Val: S/ {m.saldoValorizado.toFixed(2)}
          </span>
        </div>
      ),
    },

    {
      clave: "almacen",
      titulo: "Almacén",
      renderizar: (m: MovimientoInventario) => m.almacen,
    },
    {
      clave: "referencia",
      titulo: "Referencia",
      renderizar: (m: MovimientoInventario) => (
        <span className="text-sm font-mono">{m.referencia || "-"}</span>
      ),
    },
    {
      clave: "usuario",
      titulo: "Responsable",
      renderizar: (m: MovimientoInventario) => m.usuario || "Sistema",
    },
  ];

  return (
    <TablaPaginada
      datos={movimientos}
      columnas={columnas}
      cargando={isLoading}
    />
  );
}
