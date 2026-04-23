import { ShieldX, Home } from 'lucide-react';
import { Button } from '@/componentes/ui/button';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/componentes/ui/card';

export const PaginaNoAutorizado = () => {
    const navigate = useNavigate();

    return (
        <div className="flex items-center justify-center min-h-[calc(100vh-200px)] p-4">
            <Card className="w-full max-w-md shadow-lg border-2 border-destructive/20 animate-in fade-in zoom-in duration-300">
                <CardHeader className="text-center pb-2">
                    <div className="flex justify-center mb-4">
                        <div className="p-4 rounded-full bg-destructive/10">
                            <ShieldX className="w-16 h-16 text-destructive" strokeWidth={1.5} />
                        </div>
                    </div>
                    <CardTitle className="text-3xl font-bold tracking-tight text-foreground">
                        Acceso Denegado
                    </CardTitle>
                    <CardDescription className="text-base text-muted-foreground mt-2">
                        Lo sentimos, no tienes los permisos necesarios para acceder a esta sección del sistema.
                    </CardDescription>
                </CardHeader>
                <CardContent className="text-center pb-6">
                    <p className="text-sm text-muted-foreground">
                        Si crees que esto es un error, por favor contacta al administrador de TI para revisar tus privilegios de acceso.
                    </p>
                </CardContent>
                <CardFooter className="flex justify-center border-t pt-6 bg-muted/30">
                    <Button 
                        onClick={() => navigate('/dashboard')}
                        variant="default"
                        size="lg"
                        className="gap-2 font-semibold shadow-sm"
                    >
                        <Home className="w-4 h-4" />
                        Volver al Dashboard
                    </Button>
                </CardFooter>
            </Card>
        </div>
    );
};

export default PaginaNoAutorizado;
