import { useState } from "react";
import { Plus, Search, Filter } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";
import { useVentas } from "../hooks/useVentas";
import { TablaVentas } from "../componentes/ventas/TablaVentas";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { SelectorRangoFecha } from "@/compartido/componentes/formularios/SelectorRangoFecha";
import { ExportadorTabla } from "@/compartido/componentes/tablas/ExportadorTabla";
import { VentaFiltros, Venta } from "../tipos/ventas.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaVentas() {
  const navigate = useNavigate();
  const [filtros, setFiltros] = useState<VentaFiltros>({});

  const { data, isLoading } = useVentas(filtros, 1, 100);

  const handleVerDetalle = (_venta: Venta) => {
    toast.info("Próximamente: ver detalle de venta");
  };

  const handleNuevoPOS = () => {
    navigate("/ventas/pos");
  };

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  const columnasExportar = [
    { clave: "numeroComprobante" as keyof Venta, titulo: "Comprobante" },
    { clave: "fecha" as keyof Venta, titulo: "Fecha" },
    { clave: "total" as keyof Venta, titulo: "Total" },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsVentas} />

      <div className="flex justify-end gap-2">
        <ExportadorTabla
          datos={data?.datos || []}
          nombreArchivo="ventas"
          columnas={columnasExportar}
        />
        <Button onClick={handleNuevoPOS} size="sm">
          <Plus className="mr-2 h-4 w-4" />
          Nueva Venta (POS)
        </Button>
      </div>

      <Card>
        <CardContent className="pt-6">
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
                size="sm"
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
            onGenerarTicket={() => toast.info("Próximamente: generar ticket")}
            onGenerarFactura={() => toast.info("Próximamente: generar factura")}
          />
        </CardContent>
      </Card>
    </div>
  );
}
