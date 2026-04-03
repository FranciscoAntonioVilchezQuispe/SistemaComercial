import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence, Variants } from 'framer-motion';
import { ArrowLeft, Grip } from 'lucide-react';
import { ItemMenu, menuItems } from '@/config/menu';
import { ContenedorPagina } from '@/compartido/componentes/ContenedorPagina';
import { Button } from '@/components/ui/button';
import { cn } from '@/lib/utils';

// Mapa de colores dinámicos para los módulos
const MODULE_COLORS: Record<string, string> = {
  "Dashboard": "from-cyan-500 to-blue-600",
  "Catálogo": "from-blue-500 to-indigo-600",
  "Ventas": "from-emerald-500 to-teal-600",
  "Inventario": "from-amber-500 to-orange-600",
  "Compras": "from-purple-500 to-fuchsia-600",
  "Reportes": "from-rose-500 to-pink-600",
  "Configuración": "from-slate-600 to-gray-800",
};

// Variantes para animar la cuadrícula
const containerVariants: Variants = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1
    }
  },
  exit: {
    opacity: 0,
    y: 20,
    transition: { duration: 0.2 }
  }
};

const itemVariants: Variants = {
  hidden: { opacity: 0, scale: 0.9, y: 20 },
  show: { 
    opacity: 1, 
    scale: 1, 
    y: 0,
    transition: { type: "spring", stiffness: 300, damping: 24 }
  }
};

export function PaginaDashboard() {
  const navigate = useNavigate();
  const [moduloSeleccionado, setModuloSeleccionado] = useState<ItemMenu | null>(null);

  // Filtramos "Dashboard" del menú principal porque ya estamos en él
  const modulosDisponibles = menuItems.filter(m => m.ruta !== "/dashboard");

  const handleModuleClick = (modulo: ItemMenu) => {
    if (modulo.subItems && modulo.subItems.length > 0) {
      setModuloSeleccionado(modulo);
    } else if (modulo.ruta) {
      navigate(modulo.ruta);
    }
  };

  const handleSubItemClick = (subItem: ItemMenu) => {
    if (subItem.ruta) {
      navigate(subItem.ruta);
    }
  };

  return (
    <ContenedorPagina
      titulo="Bienvenido al Sistema Comercial"
      descripcion={
        moduloSeleccionado 
          ? `Módulo: ${moduloSeleccionado.titulo} - Selecciona una opción para continuar` 
          : "Selecciona el módulo con el que deseas trabajar el día de hoy."
      }
      acciones={
        <div className="flex gap-2">
          {moduloSeleccionado && (
            <Button
              variant="outline"
              className="gap-2 transition-all hover:bg-muted"
              onClick={() => setModuloSeleccionado(null)}
            >
              <ArrowLeft className="h-4 w-4" />
              Volver a Módulos
            </Button>
          )}
        </div>
      }
    >
      <div className="min-h-[60vh] flex flex-col pt-8">
        <AnimatePresence mode="wait">
          {!moduloSeleccionado ? (
            // VISTA PRINCIPAL: MÓDULOS
            <motion.div
              key="modulos"
              variants={containerVariants}
              initial="hidden"
              animate="show"
              exit="exit"
              className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
            >
              {modulosDisponibles.map((modulo) => {
                const gradient = MODULE_COLORS[modulo.titulo] || "from-gray-500 to-gray-700";
                return (
                  <motion.div
                    key={modulo.titulo}
                    variants={itemVariants}
                    whileHover={{ scale: 1.03 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => handleModuleClick(modulo)}
                    className={cn(
                      "relative overflow-hidden cursor-pointer group rounded-3xl p-6 shadow-md transition-all",
                      "hover:shadow-2xl border border-white/20 bg-gradient-to-br text-white",
                      gradient
                    )}
                  >
                    {/* Efecto de resplandor interno */}
                    <div className="absolute inset-0 bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                    
                    <div className="relative z-10 flex flex-col items-center justify-center gap-4 h-full min-h-[160px]">
                      <div className="p-4 bg-white/20 rounded-2xl backdrop-blur-sm shadow-inner group-hover:scale-110 transition-transform duration-300">
                        {modulo.icono}
                      </div>
                      <h3 className="text-2xl font-bold tracking-tight text-center">
                        {modulo.titulo}
                      </h3>
                      {modulo.subItems && (
                        <p className="text-sm text-white/80 font-medium bg-black/20 px-3 py-1 rounded-full">
                          {modulo.subItems.length} opciones
                        </p>
                      )}
                    </div>
                  </motion.div>
                );
              })}
            </motion.div>
          ) : (
            // VISTA SECUNDARIA: OPCIONES DEL MÓDULO (Submenús)
            <motion.div
              key="submodulos"
              variants={containerVariants}
              initial="hidden"
              animate="show"
              exit="exit"
              className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4"
            >
              {moduloSeleccionado.subItems?.map((subItem) => (
                <motion.div
                  key={subItem.titulo}
                  variants={itemVariants}
                  whileHover={{ scale: 1.03, y: -4 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => handleSubItemClick(subItem)}
                  className={cn(
                    "flex flex-col items-center justify-center p-6 gap-3 cursor-pointer",
                    "bg-card text-card-foreground border rounded-2xl shadow-sm",
                    "hover:shadow-xl hover:border-primary/50 transition-all duration-300 group relative overflow-hidden"
                  )}
                >
                  {/* Dekoración superior (Acento) */}
                  <div className="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary/60 to-primary opacity-0 group-hover:opacity-100 transition-opacity" />
                  
                  <div className="p-3 bg-muted/50 rounded-xl group-hover:bg-primary/10 transition-colors duration-300 relative">
                    {subItem.icono || <Grip className="h-6 w-6 text-muted-foreground group-hover:text-primary transition-colors" />}
                  </div>
                  <h4 className="font-semibold text-center text-lg leading-tight group-hover:text-primary transition-colors">
                    {subItem.titulo}
                  </h4>
                </motion.div>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </ContenedorPagina>
  );
}
