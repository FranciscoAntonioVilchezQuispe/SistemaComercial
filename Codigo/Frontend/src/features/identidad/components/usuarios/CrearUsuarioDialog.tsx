import { useState, useEffect } from "react";
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from "@/componentes/ui/dialog";
import { Button } from "@/componentes/ui/button";
import { Input } from "@/componentes/ui/input";
import { Label } from "@/componentes/ui/label";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/componentes/ui/select";
import { identidadAdminService, TrabajadorDto, RolDto } from "../../servicios/identidadAdminService";
import { toast } from "sonner";
import { Badge } from "@/componentes/ui/badge";
import { User, Mail, Shield, Contact } from "lucide-react";

interface CrearUsuarioDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSuccess: () => void;
}

export function CrearUsuarioDialog({ open, onOpenChange, onSuccess }: CrearUsuarioDialogProps) {
    const [trabajadores, setTrabajadores] = useState<TrabajadorDto[]>([]);
    const [roles, setRoles] = useState<RolDto[]>([]);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);

    const [form, setForm] = useState({
        username: "",
        email: "",
        idTrabajador: "",
        roles: [] as number[]
    });

    useEffect(() => {
        if (open) {
            cargarDatos();
        }
    }, [open]);

    const cargarDatos = async () => {
        setLoading(true);
        try {
            const [tData, rData] = await Promise.all([
                identidadAdminService.obtenerTrabajadores(),
                identidadAdminService.obtenerRoles()
            ]);
            // Solo mostrar trabajadores que NO tengan usuario vinculado
            setTrabajadores(tData.filter((t: TrabajadorDto) => !t.idUsuario));
            setRoles(rData);
        } catch (error) {
            toast.error("Error al cargar datos maestros");
        } finally {
            setLoading(false);
        }
    };

    const handleSumbit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!form.idTrabajador) {
            toast.error("Debe seleccionar un trabajador");
            return;
        }

        setSaving(true);
        try {
            await identidadAdminService.crearUsuario({
                username: form.username,
                email: form.email,
                idTrabajador: parseInt(form.idTrabajador),
                roles: form.roles
            });
            toast.success("Usuario creado exitosamente. Contraseña: Temporal123!");
            onSuccess();
            onOpenChange(false);
            setForm({ username: "", email: "", idTrabajador: "", roles: [] });
        } catch (error: any) {
            toast.error(error.response?.data?.message || "Error al crear usuario");
        } finally {
            setSaving(false);
        }
    };

    const trabajadorSeleccionado = trabajadores.find(t => t.id === parseInt(form.idTrabajador));

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px] rounded-2xl">
                <form onSubmit={handleSumbit}>
                    <DialogHeader>
                        <DialogTitle className="flex items-center gap-2 text-2xl">
                            <User className="h-6 w-6 text-primary" /> Crear Nueva Cuenta
                        </DialogTitle>
                        <DialogDescription>
                            Vincule un trabajador existente a una nueva cuenta de acceso.
                        </DialogDescription>
                    </DialogHeader>

                    <div className="grid gap-6 py-6">
                        {/* Selección de Trabajador */}
                        <div className="grid gap-2">
                            <Label htmlFor="trabajador" className="flex items-center gap-2">
                                <Contact className="h-4 w-4 text-muted-foreground" /> Trabajador Responsable
                            </Label>
                            <Select 
                                value={form.idTrabajador} 
                                onValueChange={(val) => setForm({ ...form, idTrabajador: val })}
                            >
                                <SelectTrigger className="h-12 rounded-xl bg-slate-50">
                                    <SelectValue placeholder="Seleccione un trabajador disponible..." />
                                </SelectTrigger>
                                <SelectContent>
                                    {trabajadores.length === 0 ? (
                                        <SelectItem value="0" disabled>No hay trabajadores disponibles</SelectItem>
                                    ) : (
                                        trabajadores.map(t => (
                                            <SelectItem key={t.id} value={t.id.toString()}>
                                                {t.nombres} {t.apellidos} ({t.numeroDocumento})
                                            </SelectItem>
                                        ))
                                    )}
                                </SelectContent>
                            </Select>
                        </div>

                        {/* Vista Previa de Datos del Trabajador */}
                        {trabajadorSeleccionado && (
                            <div className="p-4 bg-primary/5 rounded-xl border border-primary/10 animate-in fade-in zoom-in duration-300">
                                <p className="text-xs font-bold text-primary uppercase tracking-wider mb-1">Información de Perfil</p>
                                <div className="grid grid-cols-2 gap-2 text-sm">
                                    <div>
                                        <p className="text-muted-foreground text-[10px]">Nombre Completo</p>
                                        <p className="font-semibold">{trabajadorSeleccionado.nombres} {trabajadorSeleccionado.apellidos}</p>
                                    </div>
                                    <div>
                                        <p className="text-muted-foreground text-[10px]">Cargo</p>
                                        <p className="font-semibold">{trabajadorSeleccionado.cargo?.nombreCargo || "N/A"}</p>
                                    </div>
                                </div>
                            </div>
                        )}

                        <div className="grid grid-cols-2 gap-4">
                            <div className="grid gap-2">
                                <Label htmlFor="username">Nombre de Usuario</Label>
                                <div className="relative">
                                    <User className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                                    <Input
                                        id="username"
                                        placeholder="ej. jdoe"
                                        className="pl-10 h-11 bg-slate-50 rounded-xl"
                                        value={form.username}
                                        onChange={(e) => setForm({ ...form, username: e.target.value })}
                                        required
                                    />
                                </div>
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="email">Correo Electrónico</Label>
                                <div className="relative">
                                    <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                                    <Input
                                        id="email"
                                        type="email"
                                        placeholder="correo@empresa.com"
                                        className="pl-10 h-11 bg-slate-50 rounded-xl"
                                        value={form.email}
                                        onChange={(e) => setForm({ ...form, email: e.target.value })}
                                        required
                                    />
                                </div>
                            </div>
                        </div>

                        <div className="grid gap-2">
                            <Label className="flex items-center gap-2">
                                <Shield className="h-4 w-4 text-muted-foreground" /> Asignación de Roles
                            </Label>
                            <div className="flex flex-wrap gap-2 p-3 bg-slate-50 rounded-xl border border-slate-200 min-h-[50px]">
                                {roles.map(r => (
                                    <Badge 
                                        key={r.id}
                                        variant={form.roles.includes(r.id) ? "default" : "outline"}
                                        className="cursor-pointer px-3 py-1 text-xs"
                                        onClick={() => {
                                            const nuevos = form.roles.includes(r.id)
                                                ? form.roles.filter(id => id !== r.id)
                                                : [...form.roles, r.id];
                                            setForm({ ...form, roles: nuevos });
                                        }}
                                    >
                                        {r.nombreRol}
                                    </Badge>
                                ))}
                            </div>
                        </div>
                    </div>

                    <DialogFooter>
                        <Button type="button" variant="ghost" onClick={() => onOpenChange(false)}>
                            Cancelar
                        </Button>
                        <Button 
                            type="submit" 
                            disabled={saving || loading || !form.idTrabajador}
                            className="bg-primary shadow-lg shadow-primary/20 h-11 px-8 rounded-xl font-bold"
                        >
                            {saving ? "Creando..." : (loading ? "Cargando..." : "Crear Usuario")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
