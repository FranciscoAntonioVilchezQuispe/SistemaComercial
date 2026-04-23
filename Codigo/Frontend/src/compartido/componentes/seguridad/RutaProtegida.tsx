import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/features/identidad/context/AuthContext';
import React from 'react';
import { PaginaNoAutorizado } from './PaginaNoAutorizado';

interface RutaProtegidaProps {
    children: React.ReactNode;
    rolesRequeridos?: string[];
    codigoPermiso?: string;
}

export const RutaProtegida = ({ children, rolesRequeridos, codigoPermiso }: RutaProtegidaProps) => {
    const { estaAutenticado, roles, permisos, cargando } = useAuth();
    const location = useLocation();

    if (cargando) {
        return (
            <div className="h-screen w-full flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
        );
    }

    if (!estaAutenticado) {
        return <Navigate to="/login" state={{ from: location }} replace />;
    }

    const esAdmin = roles.includes('ADMINISTRADOR');

    // Validación de código de permiso (ej. "VENTAS:VER")
    if (codigoPermiso && !esAdmin) {
        const tienePermiso = permisos.includes(`${codigoPermiso}:VER`) ||
            permisos.some(p => p.startsWith(`${codigoPermiso}_`) && p.endsWith(":VER"));
        if (!tienePermiso) {
            return <PaginaNoAutorizado />;
        }
    }

    // Validación de roles fijos (si se requiere alguno específico)
    if (rolesRequeridos && !rolesRequeridos.some(r => roles.includes(r))) {
        return <PaginaNoAutorizado />;
    }

    return <>{children}</>;
};
