import { useState } from "react";
import { ContenedorPagina } from "@/compartido/componentes/ContenedorPagina";
import { UbigeoSelector } from "@/componentes/shared/UbigeoSelector";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/componentes/ui/card";
import { Badge } from "@/componentes/ui/badge";
import { MapPin, Info, Globe, Search } from "lucide-react";
import { motion } from "framer-motion";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaUbigeos() {
  const [ubigeoSeleccionado, setUbigeoSeleccionado] = useState<string>("");

  return (
    <ContenedorPagina
      titulo="Catálogo de Ubigeos"
      descripcion="Consulta la estructura jerárquica de Departamentos, Provincias y Distritos del Perú (INEI)."
    >
      <div className="space-y-4">
        <ModuleTabBar 
          tabs={[
            { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
            { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
            { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
            { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
            { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
            { label: RUTAS_TITULOS["/configuracion/reglas-sunat"], to: "/configuracion/reglas-sunat" },
            { label: RUTAS_TITULOS["/configuracion/operaciones-sunat"], to: "/configuracion/operaciones-sunat" },
            { label: RUTAS_TITULOS["/configuracion/matriz-sunat"], to: "/configuracion/matriz-sunat" },
            { label: RUTAS_TITULOS["/configuracion/tablas-generales"], to: "/configuracion/tablas-generales" },
            { label: RUTAS_TITULOS["/configuracion/ubigeos"], to: "/configuracion/ubigeos" },
          ]} 
        />
        
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Panel de Selección */}
        <Card className="lg:col-span-2 shadow-sm border-muted-foreground/10">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-xl tracking-tight">
              <Globe className="h-5 w-5 text-primary" />
              Explorador Territorial
            </CardTitle>
            <CardDescription>
              Selecciona una ubicación para ver sus detalles jerárquicos y código SUNAT.
            </CardDescription>
          </CardHeader>
          <CardContent className="pt-2">
            <div className="p-6 bg-muted/20 rounded-2xl border border-dashed border-muted-foreground/20">
              <UbigeoSelector 
                value={ubigeoSeleccionado} 
                onValueChange={setUbigeoSeleccionado} 
              />
            </div>
            
            <div className="mt-8 grid grid-cols-1 md:grid-cols-2 gap-4">
               <div className="flex items-start gap-3 p-4 rounded-xl bg-blue-50/50 dark:bg-blue-900/10 border border-blue-100 dark:border-blue-900/20">
                  <div className="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg">
                    <Info className="h-4 w-4 text-blue-600 dark:text-blue-400" />
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-semibold text-blue-900 dark:text-blue-300">¿Para qué sirve?</p>
                    <p className="text-xs text-blue-700/80 dark:text-blue-400/70 leading-relaxed">
                      El Ubigeo es el código oficial usado por SUNAT (UBL 2.1) para identificar direcciones en facturas, boletas y guías de remisión.
                    </p>
                  </div>
               </div>

               <div className="flex items-start gap-3 p-4 rounded-xl bg-emerald-50/50 dark:bg-emerald-900/10 border border-emerald-100 dark:border-emerald-900/20">
                  <div className="p-2 bg-emerald-100 dark:bg-emerald-900/30 rounded-lg">
                    <Search className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-semibold text-emerald-900 dark:text-emerald-300">Normativa INEI</p>
                    <p className="text-xs text-emerald-700/80 dark:text-emerald-400/70 leading-relaxed">
                      Este sistema utiliza los 1,874 códigos de distritos actualizados según el estándar del Instituto Nacional de Estadística e Informática.
                    </p>
                  </div>
               </div>
            </div>
          </CardContent>
        </Card>

        {/* Panel de Info / Resumen */}
        <div className="space-y-6">
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
          >
            <Card className="overflow-hidden border-primary/20 bg-gradient-to-b from-primary/5 to-transparent">
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-bold uppercase tracking-widest text-muted-foreground">Estado de Selección</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6 flex flex-col items-center justify-center min-h-[220px]">
                {ubigeoSeleccionado ? (
                  <div className="flex flex-col items-center gap-4 text-center">
                    <div className="p-4 bg-primary/10 rounded-full animate-pulse">
                      <MapPin className="h-10 w-10 text-primary" />
                    </div>
                    <div className="space-y-1">
                       <p className="text-3xl font-black tracking-tighter text-primary">
                         {ubigeoSeleccionado}
                       </p>
                       <Badge variant="outline" className="font-mono text-[10px] px-3">
                         CÓDIGO SUNAT VÁLIDO
                       </Badge>
                    </div>
                  </div>
                ) : (
                  <div className="flex flex-col items-center gap-4 text-center opacity-40">
                    <MapPin className="h-12 w-12 text-muted-foreground" />
                    <p className="text-sm font-medium italic">Esperando selección...</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </motion.div>

          {/* Estadísticas Rápidas (Simuladas basadas en INEI) */}
          <Card className="shadow-none border-dashed">
            <CardHeader className="pb-2">
               <CardTitle className="text-xs font-bold uppercase tracking-widest text-muted-foreground">Estadísticas del Catálogo</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
               <div className="flex justify-between items-center text-sm">
                  <span className="text-muted-foreground">Departamentos</span>
                  <span className="font-bold">25</span>
               </div>
               <div className="flex justify-between items-center text-sm">
                  <span className="text-muted-foreground">Provincias</span>
                  <span className="font-bold">196</span>
               </div>
               <div className="flex justify-between items-center text-sm">
                  <span className="text-muted-foreground">Distritos Totales</span>
                  <span className="font-bold">1,874</span>
               </div>
               <div className="pt-2 border-t mt-2">
                  <p className="text-[10px] text-center text-muted-foreground italic">
                    Actualizado al estándar SUNAT 2024
                  </p>
               </div>
            </CardContent>
          </Card>
        </div>
        </div>
      </div>
    </ContenedorPagina>
  );
}
