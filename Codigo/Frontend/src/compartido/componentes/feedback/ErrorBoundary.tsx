import { Component, ErrorInfo, ReactNode } from "react";
import { AlertCircle, RefreshCw, Home } from "lucide-react";
import { Button } from "@/components/ui/button";
import { capturadorErrores } from "../../utilidades/capturadorErrores";

interface Props {
  children?: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  public static getDerivedStateFromError(error: Error): State {
    // Actualiza el estado para que el siguiente renderizado muestre la interfaz de repuesto.
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Registra el error en nuestro capturador central
    capturadorErrores.capturar(error, 'RENDER', {
      metadata: {
        componentStack: errorInfo.componentStack,
      }
    });
  }

  private handleReset = () => {
    this.setState({ hasError: false, error: undefined });
    window.location.reload();
  };

  private handleGoHome = () => {
    this.setState({ hasError: false, error: undefined });
    window.location.href = "/";
  };

  public render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <div className="flex flex-col items-center justify-center min-h-[400px] p-8 text-center bg-background rounded-lg border-2 border-dashed border-destructive/20 m-4">
          <div className="bg-destructive/10 p-4 rounded-full mb-6">
            <AlertCircle className="h-12 w-12 text-destructive" />
          </div>
          
          <h1 className="text-2xl font-bold tracking-tight mb-2">Ups, algo salió mal</h1>
          <p className="text-muted-foreground max-w-md mb-8">
            Lo sentimos, ha ocurrido un error inesperado en la interfaz. 
            El equipo técnico ha sido notificado automáticamente.
          </p>

          <div className="flex flex-wrap gap-4 justify-center">
            <Button 
              variant="default" 
              onClick={this.handleReset}
              className="gap-2"
            >
              <RefreshCw className="h-4 w-4" />
              Reintentar Cargar
            </Button>
            
            <Button 
              variant="outline" 
              onClick={this.handleGoHome}
              className="gap-2"
            >
              <Home className="h-4 w-4" />
              Ir al Inicio
            </Button>
          </div>

          {process.env.NODE_ENV === 'development' && this.state.error && (
            <div className="mt-8 p-4 bg-muted rounded-md text-left w-full max-w-2xl overflow-auto border">
              <p className="text-xs font-mono font-bold text-destructive mb-2 uppercase tracking-widest">Detalle del Error (Dev Only):</p>
              <pre className="text-xs font-mono text-muted-foreground whitespace-pre-wrap">
                {this.state.error.message}
                {this.state.error.stack}
              </pre>
            </div>
          )}
        </div>
      );
    }

    return this.props.children;
  }
}
