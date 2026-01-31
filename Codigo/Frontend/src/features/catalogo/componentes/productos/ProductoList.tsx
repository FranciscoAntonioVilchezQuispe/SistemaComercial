import { Producto } from "../../tipos/catalogo.types";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/componentes/ui/table";

interface Props {
  productos: Producto[];
}

export const ProductoList = ({ productos }: Props) => {
  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Código</TableHead>
            <TableHead>Nombre</TableHead>
            <TableHead>Precio</TableHead>
            <TableHead>Stock</TableHead>
            <TableHead>Estado</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {productos.map((prod) => (
            <TableRow key={prod.id}>
              <TableCell className="font-medium">{prod.codigo}</TableCell>
              <TableCell>{prod.nombre}</TableCell>
              <TableCell>S/ {prod.precioVentaPublico.toFixed(2)}</TableCell>
              <TableCell className="text-center">{prod.stock}</TableCell>
              <TableCell>
                <span
                  className={`px-2 py-1 rounded text-xs font-medium ${prod.activo ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"}`}
                >
                  {prod.activo ? "Activo" : "Inactivo"}
                </span>
              </TableCell>
            </TableRow>
          ))}
          {productos.length === 0 && (
            <TableRow>
              <TableCell colSpan={5} className="h-24 text-center">
                No hay productos registrados.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
    </div>
  );
};
