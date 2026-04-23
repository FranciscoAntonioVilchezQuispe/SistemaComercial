import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { 
    Plus, 
    Edit, 
    Power, 
    PowerOff, 
    Building2,
    LayoutGrid,
    Search,
    Monitor,
    MoreHorizontal,
    Store
} from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/compartido/componentes/ui/button';
import { Input } from '@/compartido/componentes/ui/input';
import { Badge } from '@/compartido/componentes/ui/badge';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/compartido/componentes/ui/card';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/compartido/componentes/ui/dialog';
import { Label } from '@/compartido/componentes/ui/label';
import { 
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/compartido/componentes/ui/dropdown-menu';

import { servicioCajas } from '../servicios/servicioCajas';
import type { CajaListItem } from '../tipos/ventas.types';

export function PaginaCajas() {
    const queryClient = useQueryClient();
    const [showForm, setShowForm] = useState(false);
    const [editando, setEditando] = useState<CajaListItem | null>(null);
    const [nombreCaja, setNombreCaja] = useState('');
    const [idAlmacen, setIdAlmacen] = useState('1');
    const [filtro, setFiltro] = useState('');

    const { data: cajas = [], isLoading } = useQuery({
        queryKey: ['cajas-admin'],
        queryFn: () => servicioCajas.obtenerTodas()
    });

    const mutacionCrear = useMutation({
        mutationFn: () => servicioCajas.crear({ nombreCaja, idAlmacen: parseInt(idAlmacen) }),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Caja creada correctamente');
            cerrarForm();
        },
        onError: () => toast.error('Error al crear la caja')
    });

    const mutacionActualizar = useMutation({
        mutationFn: () => servicioCajas.actualizar(editando!.id, { nombreCaja, idAlmacen: parseInt(idAlmacen) }),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Caja actualizada correctamente');
            cerrarForm();
        },
        onError: () => toast.error('Error al actualizar la caja')
    });

    const mutacionEstado = useMutation({
        mutationFn: ({ id, activado }: { id: number; activado: boolean }) =>
            servicioCajas.cambiarEstado(id, activado),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Estado de la caja actualizado');
        },
        onError: () => toast.error('Error al cambiar el estado')
    });

    const cerrarForm = () => {
        setShowForm(false);
        setEditando(null);
        setNombreCaja('');
        setIdAlmacen('1');
    };

    const abrirEditar = (caja: CajaListItem) => {
        setEditando(caja);
        setNombreCaja(caja.nombreCaja);
        setIdAlmacen(String(caja.idAlmacen));
        setShowForm(true);
    };

    const handleGuardar = () => {
        if (!nombreCaja.trim()) {
            toast.error('El nombre de la caja es obligatorio');
            return;
        }
        if (editando) mutacionActualizar.mutate();
        else mutacionCrear.mutate();
    };

    const cajasFiltradas = cajas.filter(c => 
        c.nombreCaja.toLowerCase().includes(filtro.toLowerCase())
    );

    const formatCurrency = (value: number) => {
        return new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(value);
    };

    return (
        <div className="p-6 space-y-6 animate-in fade-in slide-in-from-bottom-2 duration-500">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight">Gestión de Cajas</h1>
                    <p className="text-muted-foreground">Administra las cajas registradoras de tus puntos de venta.</p>
                </div>
                <Button onClick={() => setShowForm(true)} className="gap-2 shadow-lg hover:shadow-primary/20 transition-all">
                    <Plus className="h-4 w-4" /> Nueva Caja
                </Button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <Card className="md:col-span-1 bg-gradient-to-br from-primary/5 to-primary/10 border-primary/20">
                    <CardHeader>
                        <CardTitle className="text-lg flex items-center gap-2">
                            <Monitor className="h-5 w-5 text-primary" /> Resumen del Módulo
                        </CardTitle>
                        <CardDescription>Estadísticas rápidas de tus terminales.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-4">
                        <div className="flex justify-between items-center">
                            <span className="text-sm text-muted-foreground">Cajas Activas</span>
                            <span className="text-xl font-bold">{cajas.filter(c => c.activado !== false).length}</span>
                        </div>
                        <div className="flex justify-between items-center">
                            <span className="text-sm text-muted-foreground">Total Cajas</span>
                            <span className="text-xl font-bold">{cajas.length}</span>
                        </div>
                        <div className="flex justify-between items-center">
                            <span className="text-sm text-muted-foreground">Efectivo en Red</span>
                            <span className="text-xl font-bold text-primary">
                                {formatCurrency(cajas.reduce((acc, c) => acc + (c.montoActual || 0), 0))}
                            </span>
                        </div>
                    </CardContent>
                </Card>

                <div className="md:col-span-2 space-y-4">
                    <div className="relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                        <Input 
                            placeholder="Buscar caja por nombre..." 
                            className="pl-10 bg-white/50 dark:bg-slate-900/50" 
                            value={filtro}
                            onChange={(e) => setFiltro(e.target.value)}
                        />
                    </div>

                    {isLoading ? (
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            {[1, 2, 3, 4].map(i => (
                                <div key={i} className="h-32 rounded-xl bg-slate-100 dark:bg-slate-800 animate-pulse" />
                            ))}
                        </div>
                    ) : cajasFiltradas.length === 0 ? (
                        <div className="flex flex-col items-center justify-center py-20 text-muted-foreground border-2 border-dashed rounded-xl">
                            <LayoutGrid className="h-12 w-12 opacity-20 mb-4" />
                            <p>No se encontraron cajas registradas.</p>
                        </div>
                    ) : (
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            {cajasFiltradas.map(caja => (
                                <Card key={caja.id} className="group hover:border-primary/50 transition-all shadow-sm hover:shadow-md">
                                    <CardHeader className="p-4 pb-2 flex flex-row items-start justify-between">
                                        <div className="flex items-center gap-3">
                                            <div className={`p-2 rounded-lg ${caja.activado !== false ? 'bg-primary/10 text-primary' : 'bg-slate-100 text-slate-400'}`}>
                                                <Building2 className="h-5 w-5" />
                                            </div>
                                            <div>
                                                <CardTitle className="text-base">{caja.nombreCaja}</CardTitle>
                                                <CardDescription className="text-xs flex items-center gap-1">
                                                    <Store className="h-3 w-3" /> Almacén #{caja.idAlmacen}
                                                </CardDescription>
                                            </div>
                                        </div>
                                        <DropdownMenu>
                                            <DropdownMenuTrigger asChild>
                                                <Button variant="ghost" size="icon" className="h-8 w-8 opacity-0 group-hover:opacity-100 transition-opacity">
                                                    <MoreHorizontal className="h-4 w-4" />
                                                </Button>
                                            </DropdownMenuTrigger>
                                            <DropdownMenuContent align="end">
                                                <DropdownMenuLabel>Opciones</DropdownMenuLabel>
                                                <DropdownMenuItem onClick={() => abrirEditar(caja)}>
                                                    <Edit className="mr-2 h-4 w-4" /> Editar
                                                </DropdownMenuItem>
                                                <DropdownMenuSeparator />
                                                <DropdownMenuItem 
                                                    className={caja.activado !== false ? 'text-red-600' : 'text-green-600'}
                                                    onClick={() => mutacionEstado.mutate({ id: caja.id, activado: !(caja.activado !== false) })}
                                                >
                                                    {caja.activado !== false ? (
                                                        <><PowerOff className="mr-2 h-4 w-4" /> Desactivar</>
                                                    ) : (
                                                        <><Power className="mr-2 h-4 w-4" /> Activar</>
                                                    )}
                                                </DropdownMenuItem>
                                            </DropdownMenuContent>
                                        </DropdownMenu>
                                    </CardHeader>
                                    <CardContent className="p-4 pt-2">
                                        <div className="flex justify-between items-center">
                                            <div className="space-y-1">
                                                <p className="text-[10px] uppercase font-bold text-muted-foreground">Efectivo Actual</p>
                                                <p className="text-lg font-bold text-primary">{formatCurrency(caja.montoActual || 0)}</p>
                                            </div>
                                            <Badge variant={caja.activado !== false ? 'default' : 'secondary'} 
                                                   className={caja.activado !== false 
                                                       ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-100 border-emerald-200' 
                                                       : 'bg-red-100 text-red-700 hover:bg-red-100 border-red-200'}>
                                                {caja.activado !== false ? 'Activa' : 'Inactiva'}
                                            </Badge>
                                        </div>
                                    </CardContent>
                                </Card>
                            ))}
                        </div>
                    )}
                </div>
            </div>

            <Dialog open={showForm} onOpenChange={cerrarForm}>
                <DialogContent className="sm:max-w-[400px]">
                    <DialogHeader>
                        <DialogTitle>{editando ? 'Editar Caja' : 'Registrar Nueva Caja'}</DialogTitle>
                        <DialogDescription>
                            Configure los datos básicos de la caja registradora.
                        </DialogDescription>
                    </DialogHeader>
                    <div className="space-y-4 py-4">
                        <div className="space-y-2">
                            <Label htmlFor="nombre">Nombre de la Caja</Label>
                            <Input 
                                id="nombre" 
                                value={nombreCaja} 
                                onChange={(e) => setNombreCaja(e.target.value)} 
                                placeholder="Ej: Caja Principal 01" 
                                className="focus-visible:ring-primary"
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="almacen">ID Almacén / Sucursal</Label>
                            <Input 
                                id="almacen" 
                                type="number" 
                                value={idAlmacen} 
                                onChange={(e) => setIdAlmacen(e.target.value)} 
                                className="focus-visible:ring-primary"
                            />
                            <p className="text-[10px] text-muted-foreground italic">
                                La caja se vinculará a este almacén para el control de inventario.
                            </p>
                        </div>
                    </div>
                    <DialogFooter className="gap-2">
                        <Button variant="ghost" onClick={cerrarForm}>Cancelar</Button>
                        <Button onClick={handleGuardar} disabled={mutacionCrear.isPending || mutacionActualizar.isPending}>
                            {editando ? 'Guardar Cambios' : 'Crear Caja'}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
        </div>
    );
}
