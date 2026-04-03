import { useEffect, useState } from "react";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { Card, CardContent } from "@/components/ui/card";
import { DataTable, DataTableColumn } from "@/componentes/ui/DataTable";
import { servicioVentas } from "@/features/ventas/servicios/servicioVentas";
import { toast } from "sonner";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { EstadoCpe, MotivoNota } from "@/features/ventas/tipos/notas.types";

export function PaginaCatalogosSunat() {
  const [tipoRender, setTipoRender] = useState<"MOTIVO_CREDITO" | "MOTIVO_DEBITO" | "ESTADO_CPE">("MOTIVO_CREDITO");
  
  const [datosCatalogo, setDatosCatalogo] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    fetchCatalogo();
  }, [tipoRender]);

  const fetchCatalogo = async () => {
    setIsLoading(true);
    try {
      let data = [];
      if (tipoRender === "MOTIVO_CREDITO") {
         data = await servicioVentas.obtenerMotivosCredito();
      } else if (tipoRender === "MOTIVO_DEBITO") {
         data = await servicioVentas.obtenerMotivosDebito();
      } else if (tipoRender === "ESTADO_CPE") {
         data = await servicioVentas.obtenerEstadosCpe();
      }
      setDatosCatalogo(data);
    } catch (e) {
      toast.error("No se pudieron cargar los catálogos SUNAT");
    } finally {
      setIsLoading(false);
    }
  };

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/general"], to: "/configuracion/general" },
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
    { label: RUTAS_TITULOS["/configuracion/sunat"], to: "/configuracion/sunat" }
  ];

  const columnsMotivo: DataTableColumn<any>[] = [
    {
      header: "Código SUNAT",
      cell: (item: MotivoNota) => (
        <span className="font-bold font-mono text-primary">{item.codigoSunat}</span>
      ),
    },
    {
      header: "Descripción",
      accessorKey: "descripcion",
    }
  ];

  const columnsEstadoCpe: DataTableColumn<any>[] = [
    {
      header: "Cód. Estado",
      cell: (item: EstadoCpe) => (
        <span className="font-bold font-mono text-primary">{item.idEstado}</span>
      ),
    },
    {
      header: "Descripción",
      accessorKey: "descripcion",
    }
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Tabs defaultValue="MOTIVO_CREDITO" onValueChange={(val: any) => setTipoRender(val)}>
        <div className="flex justify-between items-center mb-4">
          <TabsList>
            <TabsTrigger value="MOTIVO_CREDITO">Motivos (Crédito)</TabsTrigger>
            <TabsTrigger value="MOTIVO_DEBITO">Motivos (Débito)</TabsTrigger>
            <TabsTrigger value="ESTADO_CPE">Estados CPE</TabsTrigger>
          </TabsList>
        </div>

        <TabsContent value="MOTIVO_CREDITO">
          <Card>
            <CardContent className="p-6">
              <DataTable 
                data={datosCatalogo} 
                columns={columnsMotivo} 
                isLoading={isLoading}
                searchPlaceholder="Buscar por descripción..."
              />
            </CardContent>
          </Card>
        </TabsContent>
        
        <TabsContent value="MOTIVO_DEBITO">
          <Card>
            <CardContent className="p-6">
              <DataTable 
                data={datosCatalogo} 
                columns={columnsMotivo} 
                isLoading={isLoading}
                searchPlaceholder="Buscar por descripción..."
              />
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="ESTADO_CPE">
          <Card>
            <CardContent className="p-6">
              <DataTable 
                data={datosCatalogo} 
                columns={columnsEstadoCpe} 
                isLoading={isLoading}
                searchPlaceholder="Buscar por descripción..."
              />
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
