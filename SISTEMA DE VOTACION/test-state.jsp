<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ STATE
    // =============================================
    interface EstadoVotacion {
        String registrar(String cedula, String nombre);
        String votar(String cedula, String candidato);
        String verResultados();
        String getNombre();
        String getColor();
    }
    
    // =============================================
    // CONTEXTO (Sistema de Votación)
    // =============================================
    class ContextoVotacion {
        private EstadoVotacion estadoActual;
        private java.util.Map<String, String> usuarios = new java.util.HashMap<>();
        private java.util.Map<String, String> votos = new java.util.HashMap<>();
        private java.util.Map<String, Integer> conteo = new java.util.HashMap<>();
        
        public ContextoVotacion() {
            // Estado inicial
            estadoActual = new RegistroAbiertoState(this);
            // Candidatos predefinidos
            conteo.put("Candidato A", 0);
            conteo.put("Candidato B", 0);
            conteo.put("Candidato C", 0);
            conteo.put("Voto en Blanco", 0);
        }
        
        public void setEstado(EstadoVotacion estado) {
            this.estadoActual = estado;
        }
        
        public EstadoVotacion getEstado() { return estadoActual; }
        
        public String registrar(String cedula, String nombre) {
            return estadoActual.registrar(cedula, nombre);
        }
        
        public String votar(String cedula, String candidato) {
            return estadoActual.votar(cedula, candidato);
        }
        
        public String verResultados() {
            return estadoActual.verResultados();
        }
        
        // Métodos auxiliares para los estados
        public boolean usuarioExiste(String cedula) { return usuarios.containsKey(cedula); }
        public void agregarUsuario(String cedula, String nombre) { usuarios.put(cedula, nombre); }
        public boolean yaVoto(String cedula) { return votos.containsKey(cedula); }
        public void registrarVoto(String cedula, String candidato) { 
            votos.put(cedula, candidato);
            conteo.put(candidato, conteo.getOrDefault(candidato, 0) + 1);
        }
        public java.util.Map<String, Integer> getResultados() { return conteo; }
        public int getTotalVotos() { return votos.size(); }
    }
    
    // =============================================
    // ESTADOS CONCRETOS
    // =============================================
    
    // Estado 1: Registro Abierto
    class RegistroAbiertoState implements EstadoVotacion {
        private ContextoVotacion contexto;
        
        public RegistroAbiertoState(ContextoVotacion ctx) { this.contexto = ctx; }
        
        public String registrar(String cedula, String nombre) {
            if(contexto.usuarioExiste(cedula)) {
                return "❌ La cédula " + cedula + " ya está registrada";
            }
            contexto.agregarUsuario(cedula, nombre);
            return "✅ Votante registrado: " + nombre + " (" + cedula + ")";
        }
        
        public String votar(String cedula, String candidato) {
            if(!contexto.usuarioExiste(cedula)) {
                return "❌ Debes registrarte antes de votar";
            }
            return "⚠️ La votación no está abierta aún. Solo puedes registrarte.";
        }
        
        public String verResultados() {
            return "📊 No hay resultados disponibles. La votación aún no ha comenzado.";
        }
        
        public String getNombre() { return "🔓 REGISTRO ABIERTO"; }
        public String getColor() { return "#48bb78"; }
    }
    
    // Estado 2: Votación Abierta
    class VotacionAbiertaState implements EstadoVotacion {
        private ContextoVotacion contexto;
        
        public VotacionAbiertaState(ContextoVotacion ctx) { this.contexto = ctx; }
        
        public String registrar(String cedula, String nombre) {
            return "⚠️ El período de registro ha cerrado. No se pueden registrar nuevos votantes.";
        }
        
        public String votar(String cedula, String candidato) {
            if(!contexto.usuarioExiste(cedula)) {
                return "❌ No estás registrado. No puedes votar.";
            }
            if(contexto.yaVoto(cedula)) {
                return "❌ Ya has votado. No puedes votar nuevamente.";
            }
            contexto.registrarVoto(cedula, candidato);
            return "🗳️ Voto registrado: " + cedula + " → " + candidato;
        }
        
        public String verResultados() {
            java.util.Map<String, Integer> resultados = contexto.getResultados();
            StringBuilder sb = new StringBuilder("📊 RESULTADOS PARCIALES:\n");
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                sb.append("• ").append(e.getKey()).append(": ").append(e.getValue()).append(" votos\n");
            }
            sb.append("Total votos emitidos: ").append(contexto.getTotalVotos());
            return sb.toString();
        }
        
        public String getNombre() { return "🗳️ VOTACIÓN ABIERTA"; }
        public String getColor() { return "#f6ad55"; }
    }
    
    // Estado 3: Votación Cerrada
    class VotacionCerradaState implements EstadoVotacion {
        private ContextoVotacion contexto;
        
        public VotacionCerradaState(ContextoVotacion ctx) { this.contexto = ctx; }
        
        public String registrar(String cedula, String nombre) {
            return "⛔ La votación ha finalizado. No se aceptan más registros.";
        }
        
        public String votar(String cedula, String candidato) {
            return "⛔ La votación ha finalizado. No se aceptan más votos.";
        }
        
        public String verResultados() {
            java.util.Map<String, Integer> resultados = contexto.getResultados();
            int total = contexto.getTotalVotos();
            String ganador = "";
            int maxVotos = -1;
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                if(e.getValue() > maxVotos) {
                    maxVotos = e.getValue();
                    ganador = e.getKey();
                }
            }
            StringBuilder sb = new StringBuilder("🏆 RESULTADOS FINALES:\n");
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                int porcentaje = total > 0 ? (e.getValue() * 100 / total) : 0;
                sb.append("• ").append(e.getKey()).append(": ").append(e.getValue())
                  .append(" votos (").append(porcentaje).append("%)\n");
            }
            sb.append("\n🎉 GANADOR: ").append(ganador);
            return sb.toString();
        }
        
        public String getNombre() { return "🔒 VOTACIÓN CERRADA"; }
        public String getColor() { return "#e53e3e"; }
    }
    
    // Estado 4: Escrutinio (solo administradores)
    class EscrutinioState implements EstadoVotacion {
        private ContextoVotacion contexto;
        
        public EscrutinioState(ContextoVotacion ctx) { this.contexto = ctx; }
        
        public String registrar(String cedula, String nombre) {
            return "⛔ En fase de escrutinio. No se permiten registros.";
        }
        
        public String votar(String cedula, String candidato) {
            return "⛔ En fase de escrutinio. No se permiten votos.";
        }
        
        public String verResultados() {
            java.util.Map<String, Integer> resultados = contexto.getResultados();
            StringBuilder sb = new StringBuilder("🔍 RESULTADOS PRELIMINARES (ESCRUTINIO):\n");
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                sb.append("• ").append(e.getKey()).append(": ").append(e.getValue()).append(" votos\n");
            }
            sb.append("\n⚠️ Resultados no oficiales - En verificación.");
            return sb.toString();
        }
        
        public String getNombre() { return "📋 ESCRUTINIO"; }
        public String getColor() { return "#4299e1"; }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo State</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .resultado { background: #e8f8f0; padding: 15px; border-radius: 12px; margin: 15px 0; }
        .estado-actual { padding: 10px; border-radius: 12px; text-align: center; font-weight: bold; margin: 15px 0; color: white; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .input-group { margin-bottom: 15px; display: inline-block; margin-right: 10px; }
        input { padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; width: 200px; }
        label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 12px; }
        .grid-botones { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔄 Demostración del Patrón State</h1>
        <p>Permite que un objeto cambie su comportamiento cuando su estado interno cambia.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Ciclo de vida de una votación</h3>
        
        <%
            ContextoVotacion contexto = (ContextoVotacion) session.getAttribute("contextoState");
            
            if(contexto == null) {
                contexto = new ContextoVotacion();
                session.setAttribute("contextoState", contexto);
            }
            
            String accion = request.getParameter("accion");
            String resultado = "";
            
            if("cambiarEstado".equals(accion)) {
                String nuevoEstado = request.getParameter("estado");
                if("registro".equals(nuevoEstado)) contexto.setEstado(new RegistroAbiertoState(contexto));
                else if("votacion".equals(nuevoEstado)) contexto.setEstado(new VotacionAbiertaState(contexto));
                else if("cerrada".equals(nuevoEstado)) contexto.setEstado(new VotacionCerradaState(contexto));
                else if("escrutinio".equals(nuevoEstado)) contexto.setEstado(new EscrutinioState(contexto));
                resultado = "🔁 Estado cambiado a: " + contexto.getEstado().getNombre();
            } else if("registrar".equals(accion)) {
                String cedula = request.getParameter("cedula");
                String nombre = request.getParameter("nombre");
                if(cedula != null && nombre != null && !cedula.isEmpty() && !nombre.isEmpty()) {
                    resultado = contexto.registrar(cedula, nombre);
                } else {
                    resultado = "❌ Por favor ingrese cédula y nombre";
                }
            } else if("votar".equals(accion)) {
                String cedula = request.getParameter("cedula");
                String candidato = request.getParameter("candidato");
                if(cedula != null && candidato != null && !cedula.isEmpty() && !candidato.isEmpty()) {
                    resultado = contexto.votar(cedula, candidato);
                } else {
                    resultado = "❌ Por favor ingrese cédula y candidato";
                }
            } else if("verResultados".equals(accion)) {
                resultado = contexto.verResultados();
            } else if("reset".equals(accion)) {
                session.invalidate();
                response.sendRedirect("test-state.jsp");
                return;
            }
            
            EstadoVotacion estado = contexto.getEstado();
        %>
        
        <!-- Botones para cambiar el estado -->
        <div class="grid-botones">
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="estado" value="registro">
                <button type="submit" class="btn" style="background:#48bb78;">🔓 Registro Abierto</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="estado" value="votacion">
                <button type="submit" class="btn" style="background:#f6ad55;">🗳️ Votación Abierta</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="estado" value="cerrada">
                <button type="submit" class="btn" style="background:#e53e3e;">🔒 Votación Cerrada</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarEstado">
                <input type="hidden" name="estado" value="escrutinio">
                <button type="submit" class="btn" style="background:#4299e1;">📋 Escrutinio</button>
            </form>
        </div>
        
        <!-- Mostrar estado actual -->
        <div class="estado-actual" style="background: <%= estado.getColor() %>;">
            📍 ESTADO ACTUAL: <%= estado.getNombre() %>
        </div>
        
        <!-- Acciones según el estado -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <!-- Formulario de Registro -->
            <div>
                <h4>📝 Registro de votantes</h4>
                <form method="get">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="input-group">
                        <label>📇 Cédula:</label>
                        <input type="text" name="cedula" placeholder="Ej: 12345">
                    </div>
                    <div class="input-group">
                        <label>👤 Nombre:</label>
                        <input type="text" name="nombre" placeholder="Ej: Juan Pérez">
                    </div>
                    <button type="submit" class="btn">📝 Registrar</button>
                </form>
            </div>
            
            <!-- Formulario de Votación -->
            <div>
                <h4>🗳️ Emitir voto</h4>
                <form method="get">
                    <input type="hidden" name="accion" value="votar">
                    <div class="input-group">
                        <label>📇 Cédula:</label>
                        <input type="text" name="cedula" placeholder="Ej: 12345">
                    </div>
                    <div class="input-group">
                        <label>🗳️ Candidato:</label>
                        <select name="candidato" style="padding: 10px; border-radius: 8px; width: 200px;">
                            <option>Candidato A</option>
                            <option>Candidato B</option>
                            <option>Candidato C</option>
                            <option>Voto en Blanco</option>
                        </select>
                    </div>
                    <button type="submit" class="btn">🗳️ Votar</button>
                </form>
            </div>
        </div>
        
        <!-- Botón Ver Resultados -->
        <div style="margin: 20px 0;">
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="verResultados">
                <button type="submit" class="btn">📊 Ver Resultados</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="reset">
                <button type="submit" class="btn" style="background:#999;">🔄 Reiniciar todo</button>
            </form>
        </div>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <div class="pre">
                <strong>📌 Resultado de la acción:</strong><br>
                <%= resultado.replace("\n", "<br>") %>
            </div>
        <% } %>
        
        <p><strong>🔍 ¿Qué es el patrón State?</strong><br>
        El comportamiento del sistema cambia según el estado actual:<br>
        - En <strong>Registro Abierto</strong>: solo se pueden registrar votantes<br>
        - En <strong>Votación Abierta</strong>: solo se pueden emitir votos<br>
        - En <strong>Votación Cerrada</strong>: solo se pueden ver resultados<br>
        - En <strong>Escrutinio</strong>: resultados preliminares no oficiales<br>
        Cada estado sabe qué operaciones permite y cuáles no.
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>