import { useAuth } from '@/features/identidad/context/AuthContext';

type Accion = 'VER' | 'CREAR' | 'EDITAR' | 'ELIMINAR';

export const usePermiso = (modulo: string, accion: Accion): boolean => {
    const { permisos, roles } = useAuth();
    if (roles.includes('ADMINISTRADOR')) return true;
    return permisos.includes(`${modulo}:${accion}`);
};

export const useEsAdmin = (): boolean => {
    const { roles } = useAuth();
    return roles.includes('ADMINISTRADOR');
};
