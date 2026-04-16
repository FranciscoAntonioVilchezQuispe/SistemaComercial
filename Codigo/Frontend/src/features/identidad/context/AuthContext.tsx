import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { authService, UsuarioInfo } from '@/features/identidad/servicios/authService';
import { jwtDecode } from 'jwt-decode';

interface AuthContextData {
    usuario: UsuarioInfo | null;
    estaAutenticado: boolean;
    roles: string[];
    permisos: string[];
    loginInfo: (userInfo: UsuarioInfo, token: string) => void;
    logout: () => void;
    cargando: boolean;
}

const AuthContext = createContext<AuthContextData | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
    const [usuario, setUsuario] = useState<UsuarioInfo | null>(null);
    const [roles, setRoles] = useState<string[]>([]);
    const [permisos, setPermisos] = useState<string[]>([]);
    const [cargando, setCargando] = useState(true);

    useEffect(() => {
        validarSesion();
    }, []);

    const validarSesion = () => {
        const token = authService.getToken();
        if (token) {
            try {
                const decoded: any = jwtDecode(token);
                const currentTime = Date.now() / 1000;
                
                if (decoded.exp < currentTime) {
                    // Token expirado, intentar refresh (reemplazar por hook si es necesario)
                    authService.logout();
                } else {
                    const rolesIds = typeof decoded.roles === 'string' ? decoded.roles.split(',') : (decoded.roles || []);
                    const permisosIds = typeof decoded.permisos === 'string' ? decoded.permisos.split(',') : (decoded.permisos || []);
                    
                    setRoles(rolesIds);
                    setPermisos(permisosIds);
                    
                    setUsuario({
                        id: parseInt(decoded.nameid || '0'),
                        username: decoded.unique_name || '',
                        nombres: decoded.given_name || '',
                        apellidos: decoded.family_name || '',
                        email: decoded.email || '',
                        roles: rolesIds.join(',')
                    });
                }
            } catch (e) {
                authService.logout();
            }
        }
        setCargando(false);
    };

    const loginInfo = (_userInfo: UsuarioInfo, _token: string) => {
        validarSesion(); // Esto reparará y configurará estados
    };

    const logout = () => {
        authService.logout();
        setUsuario(null);
        setRoles([]);
        setPermisos([]);
    };

    return (
        <AuthContext.Provider value={{
            usuario,
            estaAutenticado: !!usuario,
            roles,
            permisos,
            loginInfo,
            logout,
            cargando
        }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error("useAuth debe usarse dentro de AuthProvider");
    }
    return context;
};
