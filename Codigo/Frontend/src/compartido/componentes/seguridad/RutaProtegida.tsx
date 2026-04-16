import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/features/identidad/context/AuthContext';
import React from 'react';

interface RutaProtegidaProps {
    children: React.ReactNode;
    rolesRequeridos?: string[];
}

export const RutaProtegida = ({ children, rolesRequeridos }: RutaProtegidaProps) => {
    const { estaAutenticado, roles, cargando } = useAuth();
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

    if (rolesRequeridos && !rolesRequeridos.some(r => roles.includes(r))) {
        // Podríamos redirigir a una página de "No Autorizado" o al dashboard
        return <Navigate to="/dashboard" replace />;
    }

    return <>{children}</>;
};
