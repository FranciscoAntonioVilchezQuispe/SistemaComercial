import { useState } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Card } from "@/components/ui/card";
import { menuService } from "../../servicios/servicioMenu";
import type { Menu, MenuFormData } from "@/types/permisos.types";
import { toast } from "sonner";

interface MenuFormProps {
  menu: Menu | null;
  menusDisponibles: Menu[];
  onGuardar: () => void;
  onCancelar: () => void;
}

export function MenuForm({
  menu,
  menusDisponibles,
  onGuardar,
  onCancelar,
}: MenuFormProps) {
  const [guardando, setGuardando] = useState(false);
  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<MenuFormData>({
    defaultValues: menu
      ? {
          codigo: menu.codigo,
          nombre: menu.nombre,
          descripcion: menu.descripcion || "",
          ruta: menu.ruta || "",
          icono: menu.icono || "",
          orden: menu.orden,
          idMenuPadre: menu.idMenuPadre,
        }
      : {
          codigo: "",
          nombre: "",
          descripcion: "",
          ruta: "",
          icono: "",
          orden: 0,
          idMenuPadre: undefined,
        },
  });

  const idMenuPadre = watch("idMenuPadre");

  // Aplanar menús para el selector (excluir el menú actual si estamos editando)
  const menusParaSelector = (): Menu[] => {
    const aplanar = (menus: Menu[]): Menu[] => {
      return menus.reduce((acc: Menu[], m) => {
        if (menu && m.id === menu.id) return acc; // Excluir el menú actual
        acc.push(m);
        if (m.subMenus && m.subMenus.length > 0) {
          acc.push(...aplanar(m.subMenus));
        }
        return acc;
      }, []);
    };
    return aplanar(menusDisponibles);
  };

  const onSubmit = async (data: MenuFormData) => {
    try {
      setGuardando(true);

      if (menu) {
        await menuService.actualizarMenu(menu.id, data);
      } else {
        await menuService.crearMenu(data);
      }

      onGuardar();
    } catch (error) {
      console.error("Error al guardar menú:", error);
      toast.error("Error al guardar el menú");
    } finally {
      setGuardando(false);
    }
  };

  return (
    <Card className="p-6">
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <div>
          <h2 className="text-2xl font-bold mb-1">
            {menu ? "Editar Menú" : "Nuevo Menú"}
          </h2>
          <p className="text-muted-foreground">
            {menu
              ? "Modifica los datos del menú"
              : "Completa los datos del nuevo menú"}
          </p>
        </div>

        <div className="grid grid-cols-2 gap-4">
          {/* Código */}
          <div className="space-y-2">
            <Label htmlFor="codigo">
              Código <span className="text-destructive">*</span>
            </Label>
            <Input
              id="codigo"
              {...register("codigo", { required: "El código es requerido" })}
              placeholder="ej: VENTAS"
            />
            {errors.codigo && (
              <p className="text-sm text-destructive">
                {errors.codigo.message}
              </p>
            )}
          </div>

          {/* Nombre */}
          <div className="space-y-2">
            <Label htmlFor="nombre">
              Nombre <span className="text-destructive">*</span>
            </Label>
            <Input
              id="nombre"
              {...register("nombre", { required: "El nombre es requerido" })}
              placeholder="ej: Ventas"
            />
            {errors.nombre && (
              <p className="text-sm text-destructive">
                {errors.nombre.message}
              </p>
            )}
          </div>

          {/* Ruta */}
          <div className="space-y-2">
            <Label htmlFor="ruta">Ruta</Label>
            <Input id="ruta" {...register("ruta")} placeholder="ej: /ventas" />
          </div>

          {/* Icono */}
          <div className="space-y-2">
            <Label htmlFor="icono">Icono</Label>
            <Input
              id="icono"
              {...register("icono")}
              placeholder="ej: shopping-cart"
            />
          </div>

          {/* Orden */}
          <div className="space-y-2">
            <Label htmlFor="orden">
              Orden <span className="text-destructive">*</span>
            </Label>
            <Input
              id="orden"
              type="number"
              {...register("orden", {
                required: "El orden es requerido",
                valueAsNumber: true,
              })}
              placeholder="0"
            />
            {errors.orden && (
              <p className="text-sm text-destructive">{errors.orden.message}</p>
            )}
          </div>

          {/* Menú Padre */}
          <div className="space-y-2">
            <Label htmlFor="idMenuPadre">Menú Padre (opcional)</Label>
            <Select
              value={idMenuPadre?.toString() || "ninguno"}
              onValueChange={(value) => {
                setValue(
                  "idMenuPadre",
                  value === "ninguno" ? undefined : parseInt(value),
                );
              }}
            >
              <SelectTrigger>
                <SelectValue placeholder="Seleccionar menú padre" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ninguno">
                  Ninguno (Menú Principal)
                </SelectItem>
                {menusParaSelector().map((m) => (
                  <SelectItem key={m.id} value={m.id.toString()}>
                    {m.nombre} ({m.codigo})
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Descripción */}
        <div className="space-y-2">
          <Label htmlFor="descripcion">Descripción</Label>
          <Textarea
            id="descripcion"
            {...register("descripcion")}
            placeholder="Descripción del menú"
            rows={3}
          />
        </div>

        {/* Botones */}
        <div className="flex justify-end gap-2">
          <Button type="button" variant="outline" onClick={onCancelar}>
            Cancelar
          </Button>
          <Button type="submit" disabled={guardando}>
            {guardando ? "Guardando..." : menu ? "Actualizar" : "Crear"}
          </Button>
        </div>
      </form>
    </Card>
  );
}
