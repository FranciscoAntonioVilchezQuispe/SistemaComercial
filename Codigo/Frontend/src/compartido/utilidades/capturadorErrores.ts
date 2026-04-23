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
      API: '#EF4444',     // Red-500
      RENDER: '#F97316',  // Orange-500
      PROMISE: '#F59E0B', // Amber-500
      GENERIC: '#64748B'  // Slate-500
    };

    const icon = entry.tipo === 'API' ? '🌐' : '⚠️';

    console.groupCollapsed(
      `%c ${icon} [Error ${entry.tipo}] %c ${entry.mensaje}`,
      `background: ${colors[entry.tipo]}; color: white; padding: 2px 4px; border-radius: 3px; font-weight: bold;`,
      'color: inherit; font-weight: normal;'
    );
    
    if (entry.stack) {
      console.error('%c Stack Trace ', 'background: #334155; color: white; font-weight: bold;', entry.stack);
    }
    
    console.log('%c Contexto ', 'color: #3B82F6; font-weight: bold;', entry.contexto);
    console.log('%c URL      ', 'color: #3B82F6; font-weight: bold;', entry.url);
    console.log('%c Time     ', 'color: #3B82F6; font-weight: bold;', entry.timestamp);
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
