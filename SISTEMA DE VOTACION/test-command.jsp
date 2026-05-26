<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ COMMAND
    // =============================================
    interface Command {
        String ejecutar();
        String deshacer();
        String getNombre();
    }
    
    // =============================================
    // RECEPTOR (Sistema de votación)
    // =============================================
    class SistemaVotacion {
        private java.util.List<String> historialVotos = new java.util.ArrayList<>();
        private java.util.List<String> historialDeshechos = new java.util.ArrayList<>();
        private int votosEmitidos = 0;
        
        public String registrarVoto(String cedula, String candidato) {
            String resultado = "🗳️ Voto registrado: " + cedula + " → " + candidato;
            historialVotos.add(resultado);
            votosEmitidos++;
            return resultado;
        }
        
        public String eliminarUltimoVoto() {
            if(historialVotos.isEmpty()) return "❌ No hay votos para deshacer";
            String ultimo = historialVotos.remove(historialVotos.size() - 1);
            historialDeshechos.add(ultimo);
            votosEmitidos--;
            return "↩️ Deshecho: " + ultimo;
        }
        
        public String getHistorial() {
            if(historialVotos.isEmpty()) return "No hay votos registrados";
            StringBuilder sb = new StringBuilder();
            for(String v : historialVotos) {
                sb.append(v).append("\n");
            }
            return sb.toString();
        }
        
        public int getTotalVotos() { return votosEmitidos; }
    }
    
    // =============================================
    // COMANDOS CONCRETOS
    // =============================================
    class VotarCommand implements Command {
        private SistemaVotacion sistema;
        private String cedula;
        private String candidato;
        private String resultado;
        
        public VotarCommand(SistemaVotacion sistema, String cedula, String candidato) {
            this.sistema = sistema;
            this.cedula = cedula;
            this.candidato = candidato;
        }
        
        public String ejecutar() {
            resultado = sistema.registrarVoto(cedula, candidato);
            return resultado;
        }
        
        public String deshacer() {
            return sistema.eliminarUltimoVoto();
        }
        
        public String getNombre() { return "VotarCommand (" + cedula + " → " + candidato + ")"; }
    }
    
    class MostrarHistorialCommand implements Command {
        private SistemaVotacion sistema;
        
        public MostrarHistorialCommand(SistemaVotacion sistema) {
            this.sistema = sistema;
        }
        
        public String ejecutar() {
            return "📋 HISTORIAL DE VOTOS:\n" + sistema.getHistorial() + 
                   "\nTotal: " + sistema.getTotalVotos() + " votos";
        }
        
        public String deshacer() { return "❌ No se puede deshacer esta acción"; }
        public String getNombre() { return "MostrarHistorialCommand"; }
    }
    
    // =============================================
    // INVOCADOR (ejecuta y almacena comandos)
    // =============================================
    class Invocador {
        private java.util.List<Command> historialComandos = new java.util.ArrayList<>();
        
        public String ejecutarComando(Command comando) {
            String resultado = comando.ejecutar();
            historialComandos.add(comando);
            return resultado;
        }
        
        public String deshacerUltimoComando() {
            if(historialComandos.isEmpty()) return "❌ No hay comandos para deshacer";
            Command ultimo = historialComandos.remove(historialComandos.size() - 1);
            return ultimo.deshacer();
        }
        
        public String getHistorialComandos() {
            if(historialComandos.isEmpty()) return "No hay comandos ejecutados";
            StringBuilder sb = new StringBuilder();
            for(Command c : historialComandos) {
                sb.append("• ").append(c.getNombre()).append("\n");
            }
            return sb.toString();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Command</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .btn-danger { background: linear-gradient(135deg, #e53e3e, #c53030); }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; }
        .resultado { background: #e8f8f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-weight: bold; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .input-group { margin-bottom: 15px; }
        input { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 12px; font-size: 14px; }
        label { display: block; margin-bottom: 5px; font-weight: 500; }
    </style>
</head>
<body>
    <div class="card">
        <h1>📝 Demostración del Patrón Command</h1>
        <p>Encapsula una solicitud como un objeto, permitiendo parametrizar, encolar y soportar operaciones deshacer/rehacer.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Sistema de Votación con Comandos</h3>
        
        <%
            // Obtener o crear el invocador en sesión
            Invocador invocador = (Invocador) session.getAttribute("invocador");
            SistemaVotacion sistema = (SistemaVotacion) session.getAttribute("sistemaVotacion");
            
            if(invocador == null) {
                invocador = new Invocador();
                sistema = new SistemaVotacion();
                session.setAttribute("invocador", invocador);
                session.setAttribute("sistemaVotacion", sistema);
            }
            
            String accion = request.getParameter("accion");
            String resultado = "";
            
            if("votar".equals(accion)) {
                String cedula = request.getParameter("cedula");
                String candidato = request.getParameter("candidato");
                if(cedula != null && candidato != null && !cedula.isEmpty() && !candidato.isEmpty()) {
                    Command comando = new VotarCommand(sistema, cedula, candidato);
                    resultado = invocador.ejecutarComando(comando);
                } else {
                    resultado = "❌ Por favor ingrese cédula y candidato";
                }
            } else if("mostrar".equals(accion)) {
                Command comando = new MostrarHistorialCommand(sistema);
                resultado = invocador.ejecutarComando(comando);
            } else if("deshacer".equals(accion)) {
                resultado = invocador.deshacerUltimoComando();
            }
        %>
        
        <form method="get" style="margin-bottom: 20px;">
            <input type="hidden" name="accion" value="votar">
            <div class="input-group">
                <label>📇 Cédula del votante:</label>
                <input type="text" name="cedula" placeholder="Ej: 12345" required>
            </div>
            <div class="input-group">
                <label>🗳️ Candidato:</label>
                <input type="text" name="candidato" placeholder="Ej: Candidato A" required>
            </div>
            <button type="submit" class="btn">🗳️ Ejecutar VotarCommand</button>
        </form>
        
        <div>
            <form method="get" style="display: inline-block;">
                <input type="hidden" name="accion" value="mostrar">
                <button type="submit" class="btn">📋 Ejecutar MostrarHistorialCommand</button>
            </form>
            <form method="get" style="display: inline-block;">
                <input type="hidden" name="accion" value="deshacer">
                <button type="submit" class="btn btn-danger">↩️ Deshacer último comando (Undo)</button>
            </form>
            <form method="get" style="display: inline-block;">
                <button type="submit" name="reset" value="true" class="btn">🔄 Reiniciar sesión</button>
            </form>
        </div>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <div class="resultado">
                <strong>📌 Resultado:</strong><br>
                <%= resultado.replace("\n", "<br>") %>
            </div>
        <% } %>
        
        <div class="pre">
            <strong>📚 Historial de comandos ejecutados:</strong><br>
            <%= invocador.getHistorialComandos().replace("\n", "<br>") %>
        </div>
        
        <p><strong>🔍 ¿Qué es el patrón Command?</strong><br>
        Cada acción (votar, mostrar, deshacer) es un objeto Command. El Invocador almacena el historial y permite deshacer operaciones.</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>