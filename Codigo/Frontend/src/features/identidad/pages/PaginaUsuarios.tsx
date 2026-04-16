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
    Search, 
    UserPlus, 
    UserIcon, 
    ShieldCheck, 
    Mail, 
    Clock, 
    MoreVertical,
    Edit3
} from "lucide-react";
import { identidadAdminService, UsuarioDto, TrabajadorDto } from "../servicios/identidadAdminService";
import { toast } from "sonner";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { CrearUsuarioDialog } from "../components/usuarios/CrearUsuarioDialog";

export function PaginaUsuarios() {
    const [usuarios, setUsuarios] = useState<UsuarioDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [filtro, setFiltro] = useState("");
    const [showCrearDialog, setShowCrearDialog] = useState(false);

    useEffect(() => {
        cargarUsuarios();
    }, []);

    const cargarUsuarios = async () => {
        try {
            setLoading(true);
            const data = await identidadAdminService.obtenerUsuarios();
            setUsuarios(data);
        } catch (error) {
            toast.error("Error al cargar la lista de usuarios");
        } finally {
            setLoading(false);
        }
    };

    const usuariosFiltrados = usuarios.filter(u => 
        u.username.toLowerCase().includes(filtro.toLowerCase()) ||
        (u.nombres || "").toLowerCase().includes(filtro.toLowerCase()) ||
        (u.apellidos || "").toLowerCase().includes(filtro.toLowerCase()) ||
        u.email.toLowerCase().includes(filtro.toLowerCase())
    );

    if (loading) return <Loading mensaje="Cargando directorio de usuarios..." />;

    return (
        <div className="p-6 space-y-6 animate-in fade-in duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Cuentas de Acceso</h1>
                    <p className="text-muted-foreground mt-1">Directorio de usuarios vinculados a trabajadores de la empresa.</p>
                </div>
                <Button 
                    onClick={() => setShowCrearDialog(true)}
                    className="h-12 px-6 shadow-lg shadow-primary/20 flex gap-2 rounded-xl transition-all hover:scale-105"
                >
                    <UserPlus className="h-5 w-5" /> Nueva Cuenta
                </Button>
            </div>

            <CrearUsuarioDialog 
                open={showCrearDialog} 
                onOpenChange={setShowCrearDialog} 
                onSuccess={cargarUsuarios} 
            />

            <Card className="border-none shadow-sm bg-white/50 backdrop-blur-sm">
                <CardHeader className="pb-3">
                    <div className="flex items-center gap-4">
                        <div className="relative flex-1 max-w-sm">
                            <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                            <Input 
                                placeholder="Buscar por nombre o usuario..." 
                                className="pl-10 h-10 bg-slate-50 border-slate-200"
                                value={filtro}
                                onChange={(e) => setFiltro(e.target.value)}
                            />
                        </div>
                    </div>
                </CardHeader>
                <CardContent>
                    <div className="rounded-xl border border-slate-200 overflow-hidden">
                        <Table>
                            <TableHeader className="bg-slate-50">
                                <TableRow>
                                    <TableHead className="w-[300px]">Usuario</TableHead>
                                    <TableHead>Email</TableHead>
                                    <TableHead>Roles</TableHead>
                                    <TableHead>Último Acceso</TableHead>
                                    <TableHead className="text-right">Acciones</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                                {usuariosFiltrados.length === 0 ? (
                                    <TableRow>
                                        <TableCell colSpan={5} className="h-32 text-center text-muted-foreground">
                                            No se encontraron usuarios que coincidan con la búsqueda.
                                        </TableCell>
                                    </TableRow>
                                ) : (
                                    usuariosFiltrados.map((u) => (
                                        <TableRow key={u.id} className="hover:bg-slate-50/50 transition-colors">
                                            <TableCell>
                                                <div className="flex items-center gap-3">
                                                    <div className="h-10 w-10 rounded-full bg-slate-100 flex items-center justify-center border border-white shadow-sm font-bold text-slate-600">
                                                        {(u.nombres?.[0] || u.username[0])}{(u.apellidos?.[0] || "")}
                                                    </div>
                                                    <div>
                                                        <p className="font-semibold leading-none">{u.nombres || "Usuario"} {u.apellidos || ""}</p>
                                                        <p className="text-xs text-muted-foreground mt-1 flex items-center gap-1">
                                                            <UserIcon className="h-3 w-3" /> @{u.username}
                                                        </p>
                                                    </div>
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex items-center gap-2 text-sm text-slate-600">
                                                    <Mail className="h-3.5 w-3.5" />
                                                    {u.email}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex flex-wrap gap-1">
                                                    {u.usuariosRoles?.map(ur => (
                                                        <Badge key={ur.idRol} variant="outline" className="bg-primary/5 text-primary border-primary/20 px-2 py-0">
                                                            <ShieldCheck className="h-3 w-3 mr-1" /> {ur.rol.nombreRol}
                                                        </Badge>
                                                    )) || <span className="text-xs text-slate-400 italic">Sin roles</span>}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                <div className="flex items-center gap-2 text-xs text-slate-500">
                                                    <Clock className="h-3.5 w-3.5" />
                                                    {u.ultimoAcceso ? new Date(u.ultimoAcceso).toLocaleDateString() : "Nunca"}
                                                </div>
                                            </TableCell>
                                            <TableCell className="text-right">
                                                <Button variant="ghost" size="icon" className="h-8 w-8 text-slate-400 hover:text-primary">
                                                    <Edit3 className="h-4 w-4" />
                                                </Button>
                                                <Button variant="ghost" size="icon" className="h-8 w-8 text-slate-400">
                                                    <MoreVertical className="h-4 w-4" />
                                                </Button>
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
