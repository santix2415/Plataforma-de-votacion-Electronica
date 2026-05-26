<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ OBSERVER (Observador)
    // =============================================
    interface Observer {
        void actualizar(String mensaje);
        String getNombre();
        String getUltimoMensaje();
    }
    
    // =============================================
    // INTERFAZ SUBJECT (Sujeto observable)
    // =============================================
    interface Subject {
        void agregarObserver(Observer o);
        void eliminarObserver(Observer o);
        void notificarObservers(String mensaje);
    }
    
    // =============================================
    // SUJETO CONCRETO (Sistema de Votación)
    // =============================================
    class SistemaVotacionObserver implements Subject {
        private java.util.List<Observer> observers = new java.util.ArrayList<>();
        private int votos = 0;
        private String ultimoEvento = "";
        
        public void agregarObserver(Observer o) {
            observers.add(o);
        }
        
        public void eliminarObserver(Observer o) {
            observers.remove(o);
        }
        
        public void notificarObservers(String mensaje) {
            for(Observer o : observers) {
                o.actualizar(mensaje);
            }
        }
        
        public void registrarVoto(String cedula, String candidato) {
            votos++;
            ultimoEvento = "🗳️ Nuevo voto: " + cedula + " → " + candidato + " (Total: " + votos + " votos)";
            notificarObservers(ultimoEvento);
        }
        
        public String getUltimoEvento() { return ultimoEvento; }
        public int getTotalVotos() { return votos; }
    }
    
    // =============================================
    // OBSERVADORES CONCRETOS
    // =============================================
    
    // Observador 1: Panel de Resultados
    class PanelResultadosObserver implements Observer {
        private String ultimoMensaje = "";
        private java.util.List<String> historial = new java.util.ArrayList<>();
        
        public void actualizar(String mensaje) {
            ultimoMensaje = mensaje;
            historial.add(mensaje);
        }
        
        public String getNombre() { return "📊 Panel de Resultados"; }
        public String getUltimoMensaje() { return ultimoMensaje; }
        
        public String getHistorial() {
            if(historial.isEmpty()) return "No hay eventos aún";
            StringBuilder sb = new StringBuilder();
            for(String e : historial) {
                sb.append("• ").append(e).append("\n");
            }
            return sb.toString();
        }
    }
    
    // Observador 2: Logger de Auditoría
    class LoggerAuditoriaObserver implements Observer {
        private String ultimoMensaje = "";
        private java.util.List<String> bitacora = new java.util.ArrayList<>();
        
        public void actualizar(String mensaje) {
            ultimoMensaje = "[LOG] " + new java.util.Date() + " - " + mensaje;
            bitacora.add(ultimoMensaje);
        }
        
        public String getNombre() { return "📋 Logger de Auditoría"; }
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
    
    // Observador 3: Notificador de Administrador
    class NotificadorAdminObserver implements Observer {
        private String ultimoMensaje = "";
        private int notificaciones = 0;
        
        public void actualizar(String mensaje) {
            notificaciones++;
            ultimoMensaje = "🔔 NOTIFICACIÓN #" + notificaciones + ": " + mensaje;
        }
        
        public String getNombre() { return "🔔 Notificador de Administrador"; }
        public String getUltimoMensaje() { return ultimoMensaje; }
        public int getNotificaciones() { return notificaciones; }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Observer</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 900px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .resultado { background: #e8f8f0; padding: 15px; border-radius: 12px; margin: 15px 0; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .input-group { margin-bottom: 15px; display: inline-block; margin-right: 10px; }
        input { padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; width: 200px; }
        label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 12px; }
        .observer-card { background: #f8f9fa; border-radius: 16px; padding: 15px; margin: 15px 0; border-left: 4px solid #667eea; }
        .observer-title { font-weight: bold; margin-bottom: 10px; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>👀 Demostración del Patrón Observer</h1>
        <p>Define una dependencia uno a muchos: cuando un objeto cambia, todos sus dependientes son notificados automáticamente.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Sistema de Votación con Observadores</h3>
        
        <%
            // Obtener o crear el sujeto y observers en sesión
            SistemaVotacionObserver sistema = (SistemaVotacionObserver) session.getAttribute("sistemaObserver");
            PanelResultadosObserver panelObserver = (PanelResultadosObserver) session.getAttribute("panelObserver");
            LoggerAuditoriaObserver loggerObserver = (LoggerAuditoriaObserver) session.getAttribute("loggerObserver");
            NotificadorAdminObserver notificadorObserver = (NotificadorAdminObserver) session.getAttribute("notificadorObserver");
            
            if(sistema == null) {
                sistema = new SistemaVotacionObserver();
                panelObserver = new PanelResultadosObserver();
                loggerObserver = new LoggerAuditoriaObserver();
                notificadorObserver = new NotificadorAdminObserver();
                
                sistema.agregarObserver(panelObserver);
                sistema.agregarObserver(loggerObserver);
                sistema.agregarObserver(notificadorObserver);
                
                session.setAttribute("sistemaObserver", sistema);
                session.setAttribute("panelObserver", panelObserver);
                session.setAttribute("loggerObserver", loggerObserver);
                session.setAttribute("notificadorObserver", notificadorObserver);
            }
            
            String cedula = request.getParameter("cedula");
            String candidato = request.getParameter("candidato");
            String reset = request.getParameter("reset");
            
            if(reset != null) {
                session.invalidate();
                response.sendRedirect("test-observer.jsp");
                return;
            }
            
            if(cedula != null && candidato != null && !cedula.isEmpty() && !candidato.isEmpty()) {
                sistema.registrarVoto(cedula, candidato);
            }
        %>
        
        <form method="get" style="margin-bottom: 20px;">
            <div class="input-group">
                <label>📇 Cédula:</label>
                <input type="text" name="cedula" placeholder="Ej: 12345" required>
            </div>
            <div class="input-group">
                <label>🗳️ Candidato:</label>
                <input type="text" name="candidato" placeholder="Ej: Candidato A" required>
            </div>
            <button type="submit" class="btn">🗳️ Registrar Voto (Notifica a todos)</button>
        </form>
        
        <form method="get">
            <button type="submit" name="reset" value="true" class="btn">🔄 Reiniciar sesión</button>
        </form>
        
        <div class="grid-2">
            <!-- Observador 1: Panel de Resultados -->
            <div class="observer-card">
                <div class="observer-title">📊 <%= panelObserver.getNombre() %></div>
                <div class="pre" style="max-height: 150px; overflow-y: auto;">
                    <strong>Última actualización:</strong><br>
                    <%= panelObserver.getUltimoMensaje() %><br><br>
                    <strong>Historial:</strong><br>
                    <%= panelObserver.getHistorial().replace("\n", "<br>") %>
                </div>
            </div>
            
            <!-- Observador 2: Logger de Auditoría -->
            <div class="observer-card">
                <div class="observer-title">📋 <%= loggerObserver.getNombre() %></div>
                <div class="pre" style="max-height: 150px; overflow-y: auto;">
                    <strong>Última entrada:</strong><br>
                    <%= loggerObserver.getUltimoMensaje() %><br><br>
                    <strong>Bitácora completa:</strong><br>
                    <%= loggerObserver.getBitacora().replace("\n", "<br>") %>
                </div>
            </div>
            
            <!-- Observador 3: Notificador de Administrador -->
            <div class="observer-card">
                <div class="observer-title">🔔 <%= notificadorObserver.getNombre() %></div>
                <div class="pre">
                    <strong>Última notificación:</strong><br>
                    <%= notificadorObserver.getUltimoMensaje() %><br><br>
                    <strong>Total notificaciones:</strong> <%= notificadorObserver.getNotificaciones() %>
                </div>
            </div>
            
            <!-- Sujeto (Sistema de Votación) -->
            <div class="observer-card">
                <div class="observer-title">🎯 Sujeto: Sistema de Votación</div>
                <div class="pre">
                    <strong>Total de votos emitidos:</strong> <%= sistema.getTotalVotos() %><br>
                    <strong>Último evento:</strong><br>
                    <%= sistema.getUltimoEvento() %>
                </div>
            </div>
        </div>
        
        <p><strong>🔍 ¿Qué es el patrón Observer?</strong><br>
        Cuando registras un voto, el <strong>Sistema de Votación</strong> (sujeto) <strong>notifica automáticamente</strong> a todos los observadores:<br>
        📊 Panel de Resultados → Actualiza su información<br>
        📋 Logger de Auditoría → Registra el evento en bitácora<br>
        🔔 Notificador de Admin → Cuenta las notificaciones<br>
        <strong>¡Sin necesidad de que el sujeto conozca los detalles de cada observador!</strong>
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>