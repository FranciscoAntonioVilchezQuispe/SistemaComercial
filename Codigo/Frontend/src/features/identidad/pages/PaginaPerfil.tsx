import { useAuth } from "../context/AuthContext";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { User, Mail, Shield, UserCircle, Calendar } from "lucide-react";

export function PaginaPerfil() {
  const { usuario, roles } = useAuth();

  if (!usuario) {
    return (
      <div className="flex items-center justify-center h-full">
        <p className="text-muted-foreground">No se pudo cargar la información del usuario.</p>
      </div>
    );
  }

  const iniciales = `${usuario.nombres?.[0] || ""}${usuario.apellidos?.[0] || ""}`.toUpperCase() || usuario.username?.[0]?.toUpperCase() || "U";

  return (
    <div className="container mx-auto py-8 max-w-4xl animate-in fade-in duration-500">
      <div className="flex flex-col gap-8">
        {/* Encabezado de Perfil */}
        <div className="flex items-center gap-6">
          <Avatar className="h-24 w-24 border-4 border-background shadow-xl">
            <AvatarImage src="" alt={usuario.username} />
            <AvatarFallback className="text-2xl bg-primary text-primary-foreground font-bold">
              {iniciales}
            </AvatarFallback>
          </Avatar>
          <div className="space-y-1">
            <h1 className="text-3xl font-extrabold tracking-tight">
              {usuario.nombres} {usuario.apellidos}
            </h1>
            <p className="text-muted-foreground text-lg">@{usuario.username}</p>
            <div className="flex gap-2 mt-2">
              {roles.map((rol) => (
                <Badge key={rol} variant="secondary" className="px-3 py-0.5 text-xs font-semibold uppercase tracking-wider">
                  {rol}
                </Badge>
              ))}
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Información Personal */}
          <Card className="md:col-span-2 shadow-sm border-muted/60">
            <CardHeader className="pb-3">
              <CardTitle className="text-xl flex items-center gap-2">
                <UserCircle className="h-5 w-5 text-primary" />
                Información Personal
              </CardTitle>
              <CardDescription>Detalles de tu cuenta en el sistema.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-1">
                  <span className="text-xs font-bold text-muted-foreground uppercase tracking-widest">Nombres</span>
                  <p className="text-[15px] font-medium">{usuario.nombres}</p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs font-bold text-muted-foreground uppercase tracking-widest">Apellidos</span>
                  <p className="text-[15px] font-medium">{usuario.apellidos}</p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs font-bold text-muted-foreground uppercase tracking-widest flex items-center gap-1.5">
                    <Mail className="h-3 w-3" /> Email
                  </span>
                  <p className="text-[15px] font-medium">{usuario.email || "No especificado"}</p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs font-bold text-muted-foreground uppercase tracking-widest flex items-center gap-1.5">
                    <User className="h-3 w-3" /> Usuario
                  </span>
                  <p className="text-[15px] font-medium">{usuario.username}</p>
                </div>
              </div>

              <Separator className="bg-muted/50" />

              <div className="space-y-3">
                <h3 className="text-[13px] font-bold text-primary uppercase tracking-widest flex items-center gap-2">
                  <Shield className="h-4 w-4" /> Roles y Permisos
                </h3>
                <div className="flex flex-wrap gap-2">
                  {roles.length > 0 ? (
                    roles.map((rol) => (
                      <Badge key={rol} variant="outline" className="text-xs">
                        {rol}
                      </Badge>
                    ))
                  ) : (
                    <p className="text-xs text-muted-foreground italic">Sin roles asignados</p>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Estado de Cuenta / Actividad */}
          <Card className="shadow-sm border-muted/60 bg-muted/10">
            <CardHeader className="pb-3">
              <CardTitle className="text-lg flex items-center gap-2">
                <Calendar className="h-5 w-5 text-primary" />
                Estado
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
               <div className="flex justify-between items-center bg-background p-3 rounded-lg border border-muted/50 shadow-sm">
                  <span className="text-sm font-semibold">Sesión Actual</span>
                  <Badge variant="default" className="bg-green-500/10 text-green-600 border-green-200 hover:bg-green-500/20 px-2 py-0">
                    Activa
                  </Badge>
               </div>
               <div className="p-4 bg-primary/5 rounded-lg border border-primary/10">
                 <p className="text-[11px] text-primary/70 font-bold uppercase tracking-wider mb-1">Nota de Seguridad</p>
                 <p className="text-xs text-muted-foreground leading-relaxed">
                   Tu cuenta está protegida por autorización granular basada en roles. Cualquier cambio en tus permisos requerirá un reinicio de sesión.
                 </p>
               </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
