import { useState } from "react";
import { Plus, Search, Filter } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useVentas } from "../hooks/useVentas";
import { TablaVentas } from "../componentes/ventas/TablaVentas";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { SelectorRangoFecha } from "@/compartido/componentes/formularios/SelectorRangoFecha";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";
import { VentaFiltros, Venta } from "../tipos/ventas.types";

export function PaginaVentas() {
  const navigate = useNavigate();
  const [filtros, setFiltros] = useState<VentaFiltros>({});

  const { data, isLoading } = useVentas(filtros, 1, 100); // Simplificado para este ejemplo

  const handleVerDetalle = (venta: Venta) => {
    console.log("Ver detalle:", venta);
  };

  const handleNuevoPOS = () => {
    navigate("/pos");
  };

  const columnasExportar = [
    { clave: "numeroComprobante" as keyof Venta, titulo: "Comprobante" },
    { clave: "fecha" as keyof Venta, titulo: "Fecha" },
    { clave: "total" as keyof Venta, titulo: "Total" },
  ];

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Ventas</h1>
          <p className="text-muted-foreground">
            Gestiona y visualiza el histórico de ventas realizadas.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <ExportadorTabla
            datos={data?.datos || []}
            nombreArchivo="ventas"
            columnas={columnasExportar}
          />
          <Button onClick={handleNuevoPOS}>
            <Plus className="mr-2 h-4 w-4" />
            Nueva Venta (POS)
          </Button>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Filtros de Búsqueda</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="N° Comprobante..."
                className="pl-8"
                value={filtros.numeroComprobante || ""}
                onChange={(e) =>
                  setFiltros({ ...filtros, numeroComprobante: e.target.value })
                }
              />
            </div>
            <div className="col-span-1 md:col-span-2">
              <SelectorRangoFecha
                alCambiarRango={(rango) =>
                  setFiltros({
                    ...filtros,
                    fechaInicio: rango?.from?.toISOString(),
                    fechaFin: rango?.to?.toISOString(),
                  })
                }
              />
            </div>
            <div className="flex items-center gap-2">
              <Button variant="outline" className="w-full">
                <Filter className="mr-2 h-4 w-4" />
                Más Filtros
              </Button>
              <Button
                variant="ghost"
                onClick={() => setFiltros({})}
                title="Limpiar filtros"
              >
                Limpiar
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="pt-6">
          <TablaVentas
            ventas={data?.datos || []}
            isLoading={isLoading}
            onVerDetalle={handleVerDetalle}
            onGenerarTicket={(v) => console.log("Ticket", v)}
            onGenerarFactura={(v) => console.log("Factura", v)}
          />
        </CardContent>
      </Card>
    </div>
  );
}
