import { useState, useEffect } from "react";
import { 
    Table, 
    TableBody, 
    TableCell, 
    TableHead, 
    TableHeader, 
    TableRow 
} from "@/componentes/ui/table";
import { Button } from "@/componentes/ui/button";
import { Card, CardHeader, CardContent } from "@/componentes/ui/card";
import { Input } from "@/componentes/ui/input";
import { Badge } from "@/componentes/ui/badge";
import { 
    Users, 
    Search, 
    UserPlus, 
    Link as LinkIcon, 
    Briefcase, 
    Contact 
} from "lucide-react";
import { identidadAdminService, TrabajadorDto } from "../servicios/identidadAdminService";
import { toast } from "sonner";
import { Loading } from "@compartido/componentes/feedback/Loading";

export function PaginaTrabajadores() {
    const [trabajadores, setTrabajadores] = useState<TrabajadorDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [filtro, setFiltro] = useState("");

    useEffect(() => {
        cargarTrabajadores();
    }, []);

    const cargarTrabajadores = async () => {
        try {
            setLoading(true);
            const data = await identidadAdminService.obtenerTrabajadores();
            setTrabajadores(data || []);
        } catch (error) {
            toast.error("Error al cargar la lista de personal");
        } finally {
            setLoading(false);
        }
    };

    const trabajadoresFiltrados = trabajadores.filter(t => 
        t.nombres.toLowerCase().includes(filtro.toLowerCase()) ||
        t.apellidos.toLowerCase().includes(filtro.toLowerCase()) ||
        t.numeroDocumento.includes(filtro)
    );

    if (loading) return <Loading mensaje="Cargando directorio de personal..." />;

    return (
        <div className="p-6 space-y-6 animate-in slide-in-from-right-4 duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Directorio de Personal</h1>
                    <p className="text-muted-foreground mt-1">Gestiona los perfiles de los trabajadores y su vinculación con usuarios.</p>
                </div>
                <Button className="h-12 px-6 shadow-lg shadow-primary/20 flex gap-2">
                    <UserPlus className="h-5 w-5" /> Registrar Personal
                </Button>
            </div>

            <Card className="border-none shadow-sm bg-white/50 backdrop-blur-sm">
                <CardHeader className="pb-3 px-6">
                    <div className="flex items-center gap-4">
                        <div className="relative flex-1 max-w-sm">
                            <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                            <Input 
                                placeholder="Buscar por DNI o nombre..." 
                                className="pl-10 h-11 bg-slate-50 border-slate-200 rounded-xl"
                                value={filtro}
                                onChange={(e) => setFiltro(e.target.value)}
                            />
                        </div>
                    </div>
                </CardHeader>
                <CardContent className="px-6 pb-6">
                    <div className="rounded-2xl border border-slate-200 overflow-hidden bg-white">
                        <Table>
                            <TableHeader className="bg-slate-50/80">
                                <TableRow>
                                    <TableHead className="py-4">Trabajador</TableHead>
                                    <TableHead>Identificación</TableHead>
                                    <TableHead>Cargo / Área</TableHead>
                                    <TableHead>Estado de Cuenta</TableHead>
                                    <TableHead className="text-right">Acciones</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {trabajadoresFiltrados.length === 0 ? (
                                    <TableRow>
                                        <TableCell colSpan={5} className="h-40 text-center text-muted-foreground">
                                            <div className="flex flex-col items-center justify-center gap-2">
                                                <Users className="h-10 w-10 text-slate-200" />
                                                <p>No se encontró personal registrado.</p>
                                            </div>
                                        </TableCell>
                                    </TableRow>
                                ) : (
                                    trabajadoresFiltrados.map((t) => (
                                        <TableRow key={t.id} className="hover:bg-slate-50/50 transition-colors">
                                            <TableCell>
                                                <div className="flex items-center gap-3 py-1">
                                                    <div className="h-11 w-11 rounded-xl bg-primary/5 flex items-center justify-center text-primary border border-primary/10 font-bold">
                                                        {t.nombres[0]}{t.apellidos[0]}
                                                    </div>
                                                    <div>
                                                        <p className="font-bold text-slate-900 leading-tight">{t.nombres} {t.apellidos}</p>
                                                        <p className="text-xs text-muted-foreground mt-0.5">{t.emailCorporativo}</p>
                                                    </div>
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex items-center gap-2 text-sm text-slate-600 font-medium font-mono bg-slate-100/50 w-fit px-2 py-0.5 rounded border border-slate-200">
                                                    <Contact className="h-3.5 w-3.5 text-slate-400" />
                                                    {t.numeroDocumento}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="space-y-1">
                                                    <div className="flex items-center gap-2 text-sm text-slate-700">
                                                        <Briefcase className="h-3.5 w-3.5 text-slate-400" />
                                                        {t.cargo?.nombreCargo || <span className="text-slate-400 italic">No asignado</span>}
                                                    </div>
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                {t.idUsuario ? (
                                                    <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 flex items-center gap-1 w-fit">
                                                        <LinkIcon className="h-3 w-3" /> Vinculado
                                                    </Badge>
                                                ) : (
                                                    <Badge variant="outline" className="text-slate-400 border-slate-200 bg-slate-50 flex items-center gap-1 w-fit">
                                                        Sin cuenta
                                                    </Badge>
                                                )}
                                            </TableCell>
                                            <TableCell className="text-right">
                                                {!t.idUsuario ? (
                                                    <Button variant="outline" size="sm" className="h-8 text-[10px] uppercase font-bold tracking-wider">
                                                        Vincular Cuenta
                                                    </Button>
                                                ) : (
                                                    <Button variant="ghost" size="sm" className="h-8 text-xs text-primary font-bold">
                                                        Ver Perfil
                                                    </Button>
                                                )}
                                            </TableCell>
                                        </TableRow>
                                    ))
                                )}
                            </TableBody>
                        </Table>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}
