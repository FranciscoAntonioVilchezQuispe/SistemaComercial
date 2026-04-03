/**
 * Utilidad para la captura sistemática de errores en el Frontend.
 * Permite registrar errores con metadatos contextuales y enviarlos a un sumidero de logs.
 */

export interface ErrorContext {
  componente?: string;
  accion?: string;
  metadata?: Record<string, any>;
  userId?: string | number;
}

export interface LogErrorEntry {
  timestamp: string;
  mensaje: string;
  stack?: string;
  url: string;
  contexto: ErrorContext;
  tipo: 'API' | 'RENDER' | 'PROMISE' | 'GENERIC';
}

class CapturadorErrores {
  private static MAX_LOGS = 50;
  private logs: LogErrorEntry[] = [];

  constructor() {
    // Intentar recuperar logs de la sesión previa (opcional)
    const saved = sessionStorage.getItem('frontend_error_logs');
    if (saved) {
      try {
        this.logs = JSON.parse(saved);
      } catch {
        this.logs = [];
      }
    }
  }

  /**
   * Captura y registra un error de forma estructurada.
   */
  public capturar(
    error: any,
    tipo: LogErrorEntry['tipo'] = 'GENERIC',
    contexto: ErrorContext = {}
  ) {
    const entry: LogErrorEntry = {
      timestamp: new Date().toISOString(),
      mensaje: error?.message || String(error),
      stack: error?.stack,
      url: window.location.href,
      tipo,
      contexto: {
        ...contexto,
        metadata: {
          ...contexto.metadata,
          userAgent: navigator.userAgent,
          platform: navigator.platform,
        }
      }
    };

    // Guardar en memoria
    this.logs.unshift(entry);
    if (this.logs.length > CapturadorErrores.MAX_LOGS) {
      this.logs.pop();
    }

    // Persistir en sesión para auditoría ante recarga
    sessionStorage.setItem('frontend_error_logs', JSON.stringify(this.logs));

    // Mostrar en consola con estilo para desarrollo
    this.mostrarEnConsola(entry);

    // TODO: Enviar al Backend si existe un endpoint de logs
    // this.enviarAlBackend(entry);
  }

  private mostrarEnConsola(entry: LogErrorEntry) {
    const colors = {
      API: '#f87171',
      RENDER: '#fb923c',
      PROMISE: '#fbbf24',
      GENERIC: '#94a3b8'
    };

    console.groupCollapsed(
      `%c[🚨 Error ${entry.tipo}] %c${entry.mensaje}`,
      `color: ${colors[entry.tipo]}; font-weight: bold;`,
      'color: inherit; font-weight: normal;'
    );
    console.error('Stack:', entry.stack);
    console.log('Contexto:', entry.contexto);
    console.log('URL:', entry.url);
    console.log('Timestamp:', entry.timestamp);
    console.groupEnd();
  }

  public obtenerLogs(): LogErrorEntry[] {
    return this.logs;
  }

  public limpiarLogs() {
    this.logs = [];
    sessionStorage.removeItem('frontend_error_logs');
  }
}

export const capturadorErrores = new CapturadorErrores();
