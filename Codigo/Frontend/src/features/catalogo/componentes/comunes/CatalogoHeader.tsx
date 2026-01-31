import { Button } from "@/components/ui/button";
import { Link, useLocation } from "react-router-dom";

const subMenus = [
  { label: "Productos", path: "/catalogo/productos" },
  { label: "Categorías", path: "/catalogo/categorias" },
  { label: "Marcas", path: "/catalogo/marcas" },
  { label: "Unidades de Medida", path: "/catalogo/unidades-medida" },
  { label: "Listas de Precios", path: "/catalogo/listas-precios" },
];

export const CatalogoHeader = () => {
  const location = useLocation();

  return (
    <div className="flex space-x-2 border-b pb-4 mb-6 overflow-x-auto">
      {subMenus.map((menu) => {
        const isActive = location.pathname === menu.path;
        return (
          <Button
            key={menu.path}
            asChild
            variant={isActive ? "default" : "outline"}
            className="rounded-full"
          >
            <Link to={menu.path}>{menu.label}</Link>
          </Button>
        );
      })}
    </div>
  );
};
