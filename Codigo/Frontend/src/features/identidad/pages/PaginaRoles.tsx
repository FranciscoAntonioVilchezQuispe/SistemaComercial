import { useState, useEffect } from "react";
import { Button } from "@/componentes/ui/button";
import { Badge } from "@/componentes/ui/badge";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/componentes/ui/card";
import { Checkbox } from "@/componentes/ui/checkbox";
import { 
    Shield, 
    Save, 
    Layers, 
    Info, 
    Key, 
    CheckCircle2, 
    Plus
} from "lucide-react";
import { 
    identidadAdminService, 
    RolDto, 
    AccesoMenuDto 
} from "../servicios/identidadAdminService";
import { menuService } from "../servicios/servicioMenu";
import { tipoPermisoService } from "../servicios/servicioTipoPermiso";
import { rolMenuService } from "../servicios/servicioRolMenu";
import { Menu, TipoPermiso } from "@/types/permisos.types";
import { toast } from "sonner";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { Separator } from "@/componentes/ui/separator";
import { ScrollArea } from "@/componentes/ui/scroll-area";
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/componentes/ui/table";

export function PaginaRoles() {
    const [roles, setRoles] = useState<RolDto[]>([]);
    const [menus, setMenus] = useState<Menu[]>([]);
    const [tiposPermiso, setTiposPermiso] = useState<TipoPermiso[]>([]);
    const [rolSeleccionado, setRolSeleccionado] = useState<RolDto | null>(null);
    
    // Matriz de accesos: [idMenu]: [idTipoPermiso1, idTipoPermiso2]
    const [matrizAccesos, setMatrizAccesos] = useState<Record<number, number[]>>({});
    
    const [loading, setLoading] = useState(true);
    const [loadingAccesos, setLoadingAccesos] = useState(false);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        cargarDatosMaestros();
    }, []);

    const cargarDatosMaestros = async () => {
        try {
            setLoading(true);
            const [rolesData, menusData, tiposData] = await Promise.all([
                identidadAdminService.obtenerRoles(),
                menuService.obtenerMenusJerarquicos(),
                tipoPermisoService.obtenerTiposPermiso()
            ]);
            setRoles(rolesData);
            setMenus(flattenMenus(menusData));
            setTiposPermiso(tiposData);
            
            if (rolesData.length > 0) {
                seleccionarRol(rolesData[0]);
            }
        } catch (error) {
            toast.error("Error al cargar configuración de seguridad");
        } finally {
            setLoading(false);
        }
    };

    const flattenMenus = (menus: Menu[]): Menu[] => {
        let result: Menu[] = [];
        menus.forEach(m => {
            result.push(m);
            if (m.subMenus && m.subMenus.length > 0) {
                result = [...result, ...flattenMenus(m.subMenus)];
            }
        });
        return result;
    };

    const seleccionarRol = async (rol: RolDto) => {
        setRolSeleccionado(rol);
        setLoadingAccesos(true);
        try {
            const accesosActuales = await rolMenuService.obtenerMenusPorRol(rol.id);
            const nuevaMatriz: Record<number, number[]> = {};
            
            accesosActuales.forEach(am => {
                nuevaMatriz[am.idMenu] = am.permisos?.map(p => p.idTipoPermiso) || [];
            });
            
            setMatrizAccesos(nuevaMatriz);
        } catch (error) {
            toast.error("Error al cargar accesos del rol");
        } finally {
            setLoadingAccesos(false);
        }
    };

    const togglePermiso = (idMenu: number, idTipoPermiso: number) => {
        setMatrizAccesos(prev => {
            const actuales = prev[idMenu] || [];
            const nuevos = actuales.includes(idTipoPermiso)
                ? actuales.filter(id => id !== idTipoPermiso)
                : [...actuales, idTipoPermiso];
            
            return { ...prev, [idMenu]: nuevos };
        });
    };

    const handleGuardar = async () => {
        if (!rolSeleccionado) return;
        setSaving(true);
        try {
            const accesosDto: AccesoMenuDto[] = Object.entries(matrizAccesos)
                .filter(([_, permisos]) => permisos.length > 0)
                .map(([idMenu, permisos]) => ({
                    idMenu: parseInt(idMenu),
                    tiposPermisoIds: permisos
                }));

            await identidadAdminService.actualizarAccesoRol(rolSeleccionado.id, accesosDto);
            toast.success("Accesos granulares actualizados exitosamente");
        } catch (error) {
            toast.error("Error al guardar la matriz de accesos");
        } finally {
            setSaving(false);
        }
    };

    if (loading) return <Loading mensaje="Cargando matriz de seguridad..." />;

    return (
        <div className="p-6 space-y-6 animate-in slide-in-from-bottom-4 duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Roles y Seguridad Granular</h1>
                    <p className="text-muted-foreground mt-1">Configura qué módulos y qué acciones puede realizar cada perfil.</p>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
                {/* Panel lateral de Roles */}
                <div className="lg:col-span-3 space-y-4">
                    <Card className="border-none shadow-sm h-fit">
                        <CardHeader className="pb-3 px-4">
                            <CardTitle className="text-sm font-bold uppercase tracking-wider text-slate-500 flex items-center gap-2">
                                <Shield className="h-4 w-4" /> Roles Disponibles
                            </CardTitle>
                        </CardHeader>
                        <CardContent className="px-2 pb-2">
                            <div className="space-y-1">
                                {roles.map(r => (
                                    <button
                                        key={r.id}
                                        onClick={() => seleccionarRol(r)}
                                        className={`w-full text-left px-4 py-3 rounded-xl transition-all flex items-center justify-between group ${
                                            rolSeleccionado?.id === r.id 
                                            ? "bg-primary text-primary-foreground shadow-md shadow-primary/20 scale-[1.02]" 
                                            : "hover:bg-slate-100 text-slate-600"
                                        }`}
                                    >
                                        <div>
                                            <p className="font-bold text-sm">{r.nombreRol}</p>
                                            <p className={`text-[10px] ${rolSeleccionado?.id === r.id ? "text-primary-foreground/70" : "text-muted-foreground"}`}>
                                                {r.descripcion || "Sin descripción"}
                                            </p>
                                        </div>
                                        {rolSeleccionado?.id === r.id && <CheckCircle2 className="h-4 w-4" />}
                                    </button>
                                ))}
                            </div>
                            <Separator className="my-2 mx-auto w-[90%]" />
                            <Button variant="ghost" className="w-full justify-start gap-2 h-10 text-slate-500 font-medium">
                                <Plus className="h-4 w-4" /> Nuevo Rol
                            </Button>
                        </CardContent>
                    </Card>
                    
                    <div className="bg-amber-50 dark:bg-amber-950/20 p-4 rounded-xl border border-amber-100 dark:border-amber-900 flex gap-3 text-amber-700 dark:text-amber-400">
                        <Info className="h-5 w-5 shrink-0" />
                        <p className="text-xs leading-relaxed">
                            <strong>Nota:</strong> Los permisos marcados aquí se reflejarán en el JWT del usuario la próxima vez que inicie sesión.
                        </p>
                    </div>
                </div>

                {/* Matriz de Permisos */}
                <div className="lg:col-span-9 space-y-4">
                    <Card className="border-none shadow-sm overflow-hidden flex flex-col h-[calc(100vh-200px)]">
                        <CardHeader className="bg-slate-50 dark:bg-slate-900 border-b flex flex-row items-center justify-between py-4 sticky top-0 z-10">
                            <div>
                                <CardTitle className="text-lg flex items-center gap-2">
                                    <Key className="h-5 w-5 text-primary" /> 
                                    Accesos para: <span className="text-primary">{rolSeleccionado?.nombreRol}</span>
                                </CardTitle>
                                <CardDescription>Define permisos específicos por cada opción del menú.</CardDescription>
                            </div>
                            <Button 
                                onClick={handleGuardar} 
                                disabled={saving || loadingAccesos}
                                className="h-10 px-6 gap-2 shadow-lg shadow-primary/20"
                            >
                                <Save className="h-4 w-4" /> {saving ? "Guardando..." : "Guardar Permisos"}
                            </Button>
                        </CardHeader>
                        
                        <ScrollArea className="flex-1">
                            <CardContent className="p-0">
                                {loadingAccesos ? (
                                    <div className="h-64 flex items-center justify-center">
                                        <Loading mensaje="Cargando matriz..." />
                                    </div>
                                ) : (
                                    <Table>
                                        <TableHeader className="bg-slate-50/50 sticky top-0 z-20">
                                            <TableRow>
                                                <TableHead className="w-[250px] font-bold">Módulo / Opción</TableHead>
                                                {tiposPermiso.map(tp => (
                                                    <TableHead key={tp.id} className="text-center font-bold">
                                                        <div className="flex flex-col items-center">
                                                            <span className="text-[10px] text-muted-foreground uppercase">{tp.codigo}</span>
                                                            <span className="text-xs">{tp.nombre}</span>
                                                        </div>
                                                    </TableHead>
                                                ))}
                                            </TableRow>
                                        </TableHeader>
                                        <TableBody>
                                            {menus.map(m => (
                                                <TableRow key={m.id} className="hover:bg-slate-50/30">
                                                    <TableCell>
                                                        <div className={`flex items-center gap-2 ${m.idMenuPadre ? "pl-8" : "font-bold"}`}>
                                                            {!m.idMenuPadre && <Layers className="h-4 w-4 text-primary/50" />}
                                                            <span className="text-sm">{m.nombre}</span>
                                                            {m.codigo && <Badge variant="outline" className="text-[9px] px-1 h-4">{m.codigo}</Badge>}
                                                        </div>
                                                    </TableCell>
                                                    {tiposPermiso.map(tp => (
                                                        <TableCell key={`${m.id}-${tp.id}`} className="text-center">
                                                            <Checkbox 
                                                                checked={(matrizAccesos[m.id] || []).includes(tp.id)}
                                                                onCheckedChange={() => togglePermiso(m.id, tp.id)}
                                                                className="mx-auto"
                                                            />
                                                        </TableCell>
                                                    ))}
                                                </TableRow>
                                            ))}
                                        </TableBody>
                                    </Table>
                                )}
                            </CardContent>
                        </ScrollArea>
                    </Card>
                </div>
            </div>
        </div>
    );
}
