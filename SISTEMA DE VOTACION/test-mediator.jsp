<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ MEDIADOR
    // =============================================
    interface MediadorVotacion {
        void enviar(String mensaje, ComponenteVotacion emisor);
        void registrarComponente(ComponenteVotacion componente);
    }
    
    // =============================================
    // CLASE BASE COMPONENTE
    // =============================================
    abstract class ComponenteVotacion {
        protected MediadorVotacion mediador;
        protected String nombre;
        
        public ComponenteVotacion(String nombre) {
            this.nombre = nombre;
        }
        
        public void setMediador(MediadorVotacion mediador) {
            this.mediador = mediador;
        }
        
        public abstract void recibir(String mensaje, String emisor);
        public abstract String getUltimoMensaje();
        public String getNombre() { return nombre; }
    }
    
    // =============================================
    // MEDIADOR CONCRETO
    // =============================================
    class MediadorVotacionConcreto implements MediadorVotacion {
        private java.util.List<ComponenteVotacion> componentes = new java.util.ArrayList<>();
        private java.util.List<String> historial = new java.util.ArrayList<>();
        
        public void registrarComponente(ComponenteVotacion componente) {
            componentes.add(componente);
            componente.setMediador(this);
            registrarHistorial("🔌 Componente registrado: " + componente.getNombre());
        }
        
        public void enviar(String mensaje, ComponenteVotacion emisor) {
            registrarHistorial("📨 " + emisor.getNombre() + " envía: " + mensaje);
            for(ComponenteVotacion c : componentes) {
                if(c != emisor) {
                    c.recibir(mensaje, emisor.getNombre());
                }
            }
        }
        
        private void registrarHistorial(String evento) {
            historial.add(new java.util.Date() + " - " + evento);
        }
        
        public String getHistorial() {
            if(historial.isEmpty()) return "No hay eventos registrados";
            StringBuilder sb = new StringBuilder();
            for(String h : historial) {
                sb.append(h).append("\n");
            }
            return sb.toString();
        }
    }
    
    // =============================================
    // COMPONENTES CONCRETOS
    // =============================================
    
    // Componente 1: Votante
    class VotanteComponente extends ComponenteVotacion {
        private String ultimoMensaje = "";
        private String cedula;
        
        public VotanteComponente(String nombre, String cedula) {
            super(nombre);
            this.cedula = cedula;
        }
        
        public void votar(String candidato) {
            String mensaje = "VOTO|" + cedula + "|" + candidato;
            mediador.enviar(mensaje, this);
        }
        
        public void recibir(String mensaje, String emisor) {
            ultimoMensaje = "📩 Recibido de " + emisor + ": " + mensaje;
        }
        
        public String getUltimoMensaje() { return ultimoMensaje; }
        public String getCedula() { return cedula; }
    }
    
    // Componente 2: Administrador
    class AdministradorComponente extends ComponenteVotacion {
        private String ultimoMensaje = "";
        private java.util.List<String> notificaciones = new java.util.ArrayList<>();
        
        public AdministradorComponente(String nombre) {
            super(nombre);
        }
        
        public void abrirVotacion() {
            mediador.enviar("COMANDO|ABRIR_VOTACION", this);
        }
        
        public void cerrarVotacion() {
            mediador.enviar("COMANDO|CERRAR_VOTACION", this);
        }
        
        public void verResultados() {
            mediador.enviar("COMANDO|VER_RESULTADOS", this);
        }
        
        public void recibir(String mensaje, String emisor) {
            ultimoMensaje = "📩 Recibido de " + emisor + ": " + mensaje;
            notificaciones.add("De " + emisor + ": " + mensaje);
        }
        
        public String getUltimoMensaje() { return ultimoMensaje; }
        public java.util.List<String> getNotificaciones() { return notificaciones; }
    }
    
    // Componente 3: Sistema de Votación (procesa los votos)
    class SistemaVotacionComponente extends ComponenteVotacion {
        private String ultimoMensaje = "";
        private java.util.Map<String, Integer> votos = new java.util.HashMap<>();
        private boolean votacionAbierta = false;
        
        public SistemaVotacionComponente(String nombre) {
            super(nombre);
            votos.put("Candidato A", 0);
            votos.put("Candidato B", 0);
            votos.put("Candidato C", 0);
            votos.put("Voto en Blanco", 0);
        }
        
        public void recibir(String mensaje, String emisor) {
            ultimoMensaje = "📩 Recibido de " + emisor + ": " + mensaje;
            
            if(mensaje.startsWith("VOTO|")) {
                if(!votacionAbierta) {
                    mediador.enviar("ERROR|La votación no está abierta", this);
                    return;
                }
                String[] partes = mensaje.split("\\|");
                String cedula = partes[1];
                String candidato = partes[2];
                if(yaVoto(cedula)) {
                    mediador.enviar("ERROR|El votante " + cedula + " ya ha votado", this);
                } else {
                    votos.put(candidato, votos.getOrDefault(candidato, 0) + 1);
                    registrarVoto(cedula, candidato);
                    mediador.enviar("CONFIRMACION|Voto registrado: " + cedula + " → " + candidato, this);
                }
            } else if(mensaje.equals("COMANDO|ABRIR_VOTACION")) {
                votacionAbierta = true;
                mediador.enviar("NOTIFICACION|Votación abierta. ¡Pueden votar!", this);
            } else if(mensaje.equals("COMANDO|CERRAR_VOTACION")) {
                votacionAbierta = false;
                mediador.enviar("NOTIFICACION|Votación cerrada. No se aceptan más votos.", this);
            } else if(mensaje.equals("COMANDO|VER_RESULTADOS")) {
                String resultados = obtenerResultados();
                mediador.enviar("RESULTADOS|" + resultados, this);
            }
        }
        
        private java.util.Map<String, Boolean> votantes = new java.util.HashMap<>();
        private boolean yaVoto(String cedula) { return votantes.containsKey(cedula); }
        private void registrarVoto(String cedula, String candidato) { votantes.put(cedula, true); }
        
        private String obtenerResultados() {
            StringBuilder sb = new StringBuilder();
            int total = 0;
            for(int v : votos.values()) total += v;
            for(java.util.Map.Entry<String, Integer> e : votos.entrySet()) {
                int pct = total > 0 ? (e.getValue() * 100 / total) : 0;
                sb.append(e.getKey()).append(": ").append(e.getValue()).append(" (").append(pct).append("%), ");
            }
            return sb.toString();
        }
        
        public String getUltimoMensaje() { return ultimoMensaje; }
        public boolean isVotacionAbierta() { return votacionAbierta; }
        public java.util.Map<String, Integer> getVotos() { return votos; }
    }
    
    // Componente 4: Logger (registra todas las acciones)
    class LoggerComponente extends ComponenteVotacion {
        private String ultimoMensaje = "";
        private java.util.List<String> bitacora = new java.util.ArrayList<>();
        
        public LoggerComponente(String nombre) {
            super(nombre);
        }
        
        public void recibir(String mensaje, String emisor) {
            ultimoMensaje = "📝 Registrado: " + mensaje;
            bitacora.add(new java.util.Date() + " [" + emisor + "]: " + mensaje);
        }
        
        public String getUltimoMensaje() { return ultimoMensaje; }
        public String getBitacora() {
            if(bitacora.isEmpty()) return "No hay registros";
            StringBuilder sb = new StringBuilder();
            for(String b : bitacora) {
                sb.append(b).append("\n");
            }
            return sb.toString();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Mediator</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 900px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 13px; }
        .btn-success { background: #48bb78; }
        .btn-warning { background: #f6ad55; }
        .btn-danger { background: #e53e3e; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 12px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .componente-card { background: #f8f9fa; border-radius: 16px; padding: 15px; margin: 10px 0; border-left: 4px solid #667eea; }
        .componente-title { font-weight: bold; margin-bottom: 10px; }
        input, select { padding: 8px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 13px; width: 180px; }
        .estado { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .abierta { background: #48bb78; color: white; }
        .cerrada { background: #e53e3e; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h1>📢 Demostración del Patrón Mediator</h1>
        <p>Define un objeto intermediario que encapsula cómo interactúan un conjunto de objetos, reduciendo dependencias directas.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Sistema de Votación con Mediador</h3>
        
        <%
            MediadorVotacionConcreto mediador = (MediadorVotacionConcreto) session.getAttribute("mediador");
            VotanteComponente votante = (VotanteComponente) session.getAttribute("votante");
            AdministradorComponente admin = (AdministradorComponente) session.getAttribute("admin");
            SistemaVotacionComponente sistema = (SistemaVotacionComponente) session.getAttribute("sistema");
            LoggerComponente logger = (LoggerComponente) session.getAttribute("logger");
            
            if(mediador == null) {
                mediador = new MediadorVotacionConcreto();
                votante = new VotanteComponente("Juan Votante", "12345");
                admin = new AdministradorComponente("Admin Principal");
                sistema = new SistemaVotacionComponente("Sistema de Votación");
                logger = new LoggerComponente("Logger");
                
                mediador.registrarComponente(votante);
                mediador.registrarComponente(admin);
                mediador.registrarComponente(sistema);
                mediador.registrarComponente(logger);
                
                session.setAttribute("mediador", mediador);
                session.setAttribute("votante", votante);
                session.setAttribute("admin", admin);
                session.setAttribute("sistema", sistema);
                session.setAttribute("logger", logger);
            }
            
            String accion = request.getParameter("accion");
            String resultado = "";
            
            if("abrirVotacion".equals(accion)) {
                admin.abrirVotacion();
                resultado = "✅ Administrador envió comando: ABRIR VOTACIÓN";
            } else if("cerrarVotacion".equals(accion)) {
                admin.cerrarVotacion();
                resultado = "✅ Administrador envió comando: CERRAR VOTACIÓN";
            } else if("verResultados".equals(accion)) {
                admin.verResultados();
                resultado = "✅ Administrador solicitó: VER RESULTADOS";
            } else if("votar".equals(accion)) {
                String candidato = request.getParameter("candidato");
                if(candidato != null && !candidato.isEmpty()) {
                    votante.votar(candidato);
                    resultado = "🗳️ Votante emitió voto para: " + candidato;
                }
            } else if("reset".equals(accion)) {
                session.invalidate();
                response.sendRedirect("test-mediator.jsp");
                return;
            }
        %>
        
        <!-- Estado de la votación -->
        <div style="text-align: center; margin-bottom: 20px;">
            <span class="estado <%= sistema.isVotacionAbierta() ? "abierta" : "cerrada" %>">
                <%= sistema.isVotacionAbierta() ? "🔓 VOTACIÓN ABIERTA" : "🔒 VOTACIÓN CERRADA" %>
            </span>
        </div>
        
        <div class="grid-2">
            <!-- Panel de Administrador -->
            <div class="componente-card">
                <div class="componente-title">👑 Administrador</div>
                <form method="get" style="display: inline;">
                    <input type="hidden" name="accion" value="abrirVotacion">
                    <button type="submit" class="btn btn-success">🔓 Abrir votación</button>
                </form>
                <form method="get" style="display: inline;">
                    <input type="hidden" name="accion" value="cerrarVotacion">
                    <button type="submit" class="btn btn-danger">🔒 Cerrar votación</button>
                </form>
                <form method="get" style="display: inline;">
                    <input type="hidden" name="accion" value="verResultados">
                    <button type="submit" class="btn">📊 Ver resultados</button>
                </form>
                <div class="pre" style="margin-top: 10px; font-size: 11px;">
                    <strong>Último mensaje:</strong> <%= admin.getUltimoMensaje() %>
                </div>
            </div>
            
            <!-- Panel de Votante -->
            <div class="componente-card">
                <div class="componente-title">🗳️ Votante (Juan - 12345)</div>
                <form method="get">
                    <input type="hidden" name="accion" value="votar">
                    <select name="candidato" style="margin-right: 5px;">
                        <option>Candidato A</option>
                        <option>Candidato B</option>
                        <option>Candidato C</option>
                        <option>Voto en Blanco</option>
                    </select>
                    <button type="submit" class="btn">🗳️ Votar</button>
                </form>
                <div class="pre" style="margin-top: 10px; font-size: 11px;">
                    <strong>Último mensaje:</strong> <%= votante.getUltimoMensaje() %>
                </div>
            </div>
        </div>
        
        <div class="grid-2">
            <!-- Panel del Sistema -->
            <div class="componente-card">
                <div class="componente-title">⚙️ Sistema de Votación</div>
                <div class="pre" style="font-size: 11px;">
                    <strong>Estado:</strong> <%= sistema.isVotacionAbierta() ? "Abierta" : "Cerrada" %><br>
                    <strong>Resultados:</strong><br>
                    <% for(java.util.Map.Entry<String, Integer> e : sistema.getVotos().entrySet()) { %>
                        <%= e.getKey() %>: <%= e.getValue() %> votos<br>
                    <% } %>
                </div>
                <div class="pre" style="margin-top: 5px; font-size: 11px;">
                    <strong>Último mensaje:</strong> <%= sistema.getUltimoMensaje() %>
                </div>
            </div>
            
            <!-- Panel del Logger -->
            <div class="componente-card">
                <div class="componente-title">📝 Logger (Auditoría)</div>
                <div class="pre" style="font-size: 11px; max-height: 150px; overflow-y: auto;">
                    <strong>Último registro:</strong> <%= logger.getUltimoMensaje() %><br><br>
                    <strong>Bitácora completa:</strong><br>
                    <%= logger.getBitacora().replace("\n", "<br>") %>
                </div>
            </div>
        </div>
        
        <!-- Historial del mediador -->
        <div class="componente-card">
            <div class="componente-title">📋 Mediador (Historial de comunicación)</div>
            <div class="pre" style="font-size: 11px; max-height: 150px; overflow-y: auto;">
                <%= ((MediadorVotacionConcreto)mediador).getHistorial().replace("\n", "<br>") %>
            </div>
        </div>
        
        <form method="get" style="text-align: center;">
            <input type="hidden" name="accion" value="reset">
            <button type="submit" class="btn" style="background:#999;">🔄 Reiniciar todo</button>
        </form>
        
        <p><strong>🔍 ¿Qué es el patrón Mediator?</strong><br>
        Todos los componentes se comunican <strong>SOLO a través del Mediador</strong>:<br>
        - 👑 Administrador envía comandos → Mediador los distribuye<br>
        - 🗳️ Votante vota → Mediador envía al Sistema<br>
        - ⚙️ Sistema procesa → Mediador notifica al Votante y al Logger<br>
        - 📝 Logger registra TODO lo que pasa<br>
        <strong>¡Los componentes no se conocen entre sí! Todo pasa por el Mediador.</strong>
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>