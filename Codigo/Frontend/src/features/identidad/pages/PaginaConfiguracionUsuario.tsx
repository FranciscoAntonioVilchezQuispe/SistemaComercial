import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Separator } from "@/components/ui/separator";
import { Settings, Moon, Sun, Bell, ShieldCheck } from "lucide-react";
import { useTheme } from "next-themes";

export function PaginaConfiguracionUsuario() {
  const { theme, setTheme } = useTheme();

  return (
    <div className="container mx-auto py-8 max-w-2xl animate-in font-sans">
      <div className="flex flex-col gap-6">
        <div className="space-y-1">
          <h1 className="text-3xl font-extrabold tracking-tight flex items-center gap-3">
            <Settings className="h-8 w-8 text-primary" />
            Configuración
          </h1>
          <p className="text-muted-foreground">Adminitras tus preferencias de usuario y cuenta.</p>
        </div>

        <div className="grid gap-6">
          {/* Preferencias de Interfaz */}
          <Card className="shadow-sm border-muted/60">
            <CardHeader>
              <CardTitle className="text-xl flex items-center gap-2">
                <Sun className="h-5 w-5 text-yellow-500" />
                Interfaz y Apariencia
              </CardTitle>
              <CardDescription>Personaliza cómo se ve el sistema para ti.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-muted/30 rounded-lg">
                <div className="space-y-0.5">
                  <Label className="text-sm font-bold flex items-center gap-2">
                    <Moon className="h-4 w-4" /> Modo Oscuro
                  </Label>
                  <p className="text-xs text-muted-foreground">Cambiar entre tema claro y oscuro.</p>
                </div>
                <Switch 
                  checked={theme === "dark"} 
                  onCheckedChange={(checked) => setTheme(checked ? "dark" : "light")}
                />
              </div>
            </CardContent>
          </Card>

          {/* Notificaciones (Placeholder) */}
          <Card className="shadow-sm border-muted/60">
            <CardHeader>
              <CardTitle className="text-xl flex items-center gap-2">
                <Bell className="h-5 w-5 text-primary" />
                Notificaciones
              </CardTitle>
              <CardDescription>Configura tus alertas y avisos del sistema.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between p-4 opacity-70">
                <div className="space-y-0.5">
                  <Label className="text-sm font-bold opacity-50">Notificaciones de Escritorio</Label>
                  <p className="text-xs text-muted-foreground">Mostrar avisos en tiempo real.</p>
                </div>
                <Switch disabled />
              </div>
              <Separator className="bg-muted/50" />
              <p className="text-[11px] text-center text-muted-foreground italic">Opciones avanzadas próximamente</p>
            </CardContent>
          </Card>

          {/* Seguridad (Placeholder) */}
          <Card className="shadow-sm border-muted/60 border-primary/20">
            <CardHeader>
              <CardTitle className="text-xl flex items-center gap-2">
                <ShieldCheck className="h-5 w-5 text-primary" />
                Seguridad de la Cuenta
              </CardTitle>
              <CardDescription>Gestiona el acceso a tu cuenta.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="p-4 bg-primary/5 rounded-lg border border-primary/10 flex flex-col gap-3">
                <p className="text-sm">¿Deseas cambiar tu contraseña?</p>
                <button 
                  disabled
                  className="w-full py-2 bg-primary/10 text-primary rounded-md text-xs font-bold uppercase tracking-wider hover:bg-primary/20 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Cambiar Contraseña
                </button>
                <p className="text-[10px] text-muted-foreground text-center">La gestión de contraseñas actualmente está controlada por el administrador.</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
