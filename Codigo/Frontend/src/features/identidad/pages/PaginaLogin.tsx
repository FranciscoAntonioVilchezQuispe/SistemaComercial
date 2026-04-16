import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { authService } from '../servicios/authService';
import { useAuth } from '../context/AuthContext';
import { toast } from 'sonner';
import { 
  Card, 
  CardContent, 
  CardDescription, 
  CardFooter, 
  CardHeader, 
  CardTitle 
} from '@/componentes/ui/card';
import { Button } from '@/componentes/ui/button';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { Lock, User, Loader2, ArrowRight } from 'lucide-react';

export const PaginaLogin = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const { loginInfo } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);

        try {
            const data = await authService.login({ username, password });
            loginInfo(data.usuario, data.token);
            toast.success(`Bienvenido, ${data.usuario.nombres}`);
            
            // Redirigir según rol (Simplificado por ahora a dashboard)
            navigate('/dashboard');
        } catch (error: any) {
            const errorMsg = error.response?.data?.message 
                || error.response?.data 
                || "Credenciales inválidas. Verifique su usuario y contraseña.";
            toast.error(errorMsg);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen w-full flex items-center justify-center bg-slate-50 dark:bg-slate-950 px-4">
            <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
                <div className="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] bg-primary/10 rounded-full blur-[120px]" />
                <div className="absolute -bottom-[10%] -right-[10%] w-[40%] h-[40%] bg-blue-500/10 rounded-full blur-[120px]" />
            </div>

            <Card className="w-full max-w-md z-10 border-none shadow-2xl bg-white/80 dark:bg-slate-900/80 backdrop-blur-xl">
                <CardHeader className="space-y-1 text-center pb-8">
                    <div className="flex justify-center mb-4">
                        <div className="h-12 w-12 rounded-xl bg-primary flex items-center justify-center shadow-lg shadow-primary/30">
                            <Lock className="h-6 w-6 text-primary-foreground" />
                        </div>
                    </div>
                    <CardTitle className="text-3xl font-bold tracking-tight">Sistema Comercial</CardTitle>
                    <CardDescription className="text-base text-muted-foreground">
                        Bienvenido de nuevo, ingresa tus credenciales
                    </CardDescription>
                </CardHeader>
                <form onSubmit={handleSubmit}>
                    <CardContent className="space-y-4">
                        <div className="space-y-2">
                            <Label htmlFor="username">Usuario</Label>
                            <div className="relative">
                                <User className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                                <Input 
                                    id="username" 
                                    placeholder="nombre.usuario" 
                                    className="pl-10 h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700" 
                                    value={username}
                                    onChange={(e) => setUsername(e.target.value)}
                                    required
                                />
                            </div>
                        </div>
                        <div className="space-y-2">
                            <div className="flex items-center justify-between">
                                <Label htmlFor="password">Contraseña</Label>
                                <a href="#" className="text-xs text-primary hover:underline">Olvide mi contraseña</a>
                            </div>
                            <div className="relative">
                                <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                                <Input 
                                    id="password" 
                                    type="password" 
                                    placeholder="••••••••"
                                    className="pl-10 h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                    required
                                />
                            </div>
                        </div>
                    </CardContent>
                    <CardFooter className="pt-4 flex flex-col gap-4">
                        <Button 
                            type="submit" 
                            className="w-full h-12 text-base font-semibold transition-all hover:scale-[1.01]" 
                            disabled={loading}
                        >
                            {loading ? (
                                <>
                                    <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                                    Autenticando...
                                </>
                            ) : (
                                <>
                                    Iniciar Sesión
                                    <ArrowRight className="ml-2 h-5 w-5" />
                                </>
                            )}
                        </Button>
                        <p className="text-center text-xs text-muted-foreground">
                            &copy; 2026 - Soluciones Tecnológicas Perú
                        </p>
                    </CardFooter>
                </form>
            </Card>
        </div>
    );
};
