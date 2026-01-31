import { Marca } from "../../tipos/catalogo.types";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Edit2, Trash2 } from "lucide-react";

interface Props {
  marcas: Marca[];
  alEditar: (marca: Marca) => void;
  alEliminar: (id: number) => void;
}

export const MarcaList = ({ marcas, alEditar, alEliminar }: Props) => {
  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Nombre</TableHead>
            <TableHead>Descripción</TableHead>
            <TableHead>Estado</TableHead>
            <TableHead className="text-right">Acciones</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {marcas.map((marca) => (
            <TableRow key={marca.id}>
              <TableCell className="font-medium">{marca.nombre}</TableCell>
              <TableCell>{marca.descripcion || "-"}</TableCell>
              <TableCell>
                <span
                  className={`px-2 py-1 rounded text-xs font-medium ${marca.activo ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"}`}
                >
                  {marca.activo ? "Activo" : "Inactivo"}
                </span>
              </TableCell>
              <TableCell className="text-right space-x-2">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => alEditar(marca)}
                >
                  <Edit2 className="h-4 w-4" />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  className="text-destructive"
                  onClick={() => alEliminar(marca.id)}
                >
                  <Trash2 className="h-4 w-4" />
                </Button>
              </TableCell>
            </TableRow>
          ))}
          {marcas.length === 0 && (
            <TableRow>
              <TableCell colSpan={4} className="h-24 text-center">
                No hay marcas registradas.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
    </div>
  );
};
