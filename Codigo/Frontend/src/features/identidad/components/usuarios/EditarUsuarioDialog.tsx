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
    identidadAdminService,
    UsuarioDto,
    RolDto
} from "../../servicios/identidadAdminService";
import { toast } from "sonner";
import { Badge } from "@/componentes/ui/badge";
import { Mail, Shield, ShieldCheck } from "lucide-react";

interface EditarUsuarioDialogProps {
    usuario: UsuarioDto | null;
    open: boolean;
    onOpenChange: (open: boolean) => void;
    onSuccess: () => void;
}

export function EditarUsuarioDialog({ usuario, open, onOpenChange, onSuccess }: EditarUsuarioDialogProps) {
    const [roles, setRoles] = useState<RolDto[]>([]);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);

    const [form, setForm] = useState({
        email: "",
        nombres: "",
        apellidos: "",
        roles: [] as number[]
    });

    useEffect(() => {
        if (open && usuario) {
            cargarDatos();
            setForm({
                email: usuario.email,
                nombres: usuario.nombres,
                apellidos: usuario.apellidos,
                roles: usuario.usuariosRoles?.map(ur => ur.idRol) || []
            });
        }
    }, [open, usuario]);

    const cargarDatos = async () => {
        setLoading(true);
        try {
            const rData = await identidadAdminService.obtenerRoles();
            setRoles(rData);
        } catch (error) {
            toast.error("Error al cargar roles");
        } finally {
            setLoading(false);
        }
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!usuario) return;

        setSaving(true);
        try {
            await identidadAdminService.actualizarUsuario(usuario.id, {
                email: form.email,
                nombres: form.nombres,
                apellidos: form.apellidos,
                roles: form.roles
            });
            toast.success("Usuario actualizado correctamente");
            onSuccess();
            onOpenChange(false);
        } catch (error: any) {
            toast.error(error.response?.data?.message || "Error al actualizar usuario");
        } finally {
            setSaving(false);
        }
    };

    if (!usuario) return null;

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[500px] rounded-2xl">
                <form onSubmit={handleSubmit}>
                    <DialogHeader>
                        <DialogTitle className="flex items-center gap-2 text-2xl">
                            <ShieldCheck className="h-6 w-6 text-primary" /> Editar Perfil y Roles
                        </DialogTitle>
                        <DialogDescription>
                            Configure la información de @{usuario.username} y sus privilegios de acceso.
                        </DialogDescription>
                    </DialogHeader>

                    <div className="grid gap-6 py-6">
                        <div className="p-4 bg-primary/5 rounded-xl border border-primary/10 mb-2">
                            <p className="text-[10px] font-bold text-primary uppercase tracking-wider mb-1">Usuario Vinculado</p>
                            <p className="text-sm font-semibold">{usuario.nombres} {usuario.apellidos}</p>
                            <p className="text-xs text-muted-foreground mt-0.5">La vinculación con el trabajador no puede cambiarse.</p>
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div className="grid gap-2">
                                <Label htmlFor="edit-nombres">Nombres</Label>
                                <Input
                                    id="edit-nombres"
                                    className="h-11 bg-slate-50 rounded-xl"
                                    value={form.nombres}
                                    onChange={(e) => setForm({ ...form, nombres: e.target.value })}
                                    required
                                />
                            </div>
                            <div className="grid gap-2">
                                <Label htmlFor="edit-apellidos">Apellidos</Label>
                                <Input
                                    id="edit-apellidos"
                                    className="h-11 bg-slate-50 rounded-xl"
                                    value={form.apellidos}
                                    onChange={(e) => setForm({ ...form, apellidos: e.target.value })}
                                    required
                                />
                            </div>
                        </div>

                        <div className="grid gap-2">
                            <Label htmlFor="edit-email">Correo Electrónico</Label>
                            <div className="relative">
                                <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                                <Input
                                    id="edit-email"
                                    type="email"
                                    className="pl-10 h-11 bg-slate-50 rounded-xl"
                                    value={form.email}
                                    onChange={(e) => setForm({ ...form, email: e.target.value })}
                                    required
                                />
                            </div>
                        </div>

                        <div className="grid gap-2">
                            <Label className="flex items-center gap-2">
                                <Shield className="h-4 w-4 text-muted-foreground" /> Privilegios de Acceso
                            </Label>
                            <div className="flex flex-wrap gap-2 p-3 bg-slate-50 rounded-xl border border-slate-200 min-h-[50px]">
                                {roles.length === 0 && !loading && <p className="text-xs text-muted-foreground">No existen roles configurados.</p>}
                                {roles.map(r => (
                                    <Badge 
                                        key={r.id}
                                        variant={form.roles.includes(r.id) ? "default" : "outline"}
                                        className="cursor-pointer px-3 py-1 text-xs transition-all active:scale-95"
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
                            disabled={saving}
                            className="bg-primary shadow-lg shadow-primary/20 h-11 px-8 rounded-xl font-bold"
                        >
                            {saving ? "Guardando..." : "Guardar Cambios"}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
