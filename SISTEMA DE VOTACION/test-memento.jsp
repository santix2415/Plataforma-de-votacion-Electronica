<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // MEMENTO (Almacena el estado)
    // =============================================
    class MementoVotacion {
        private java.util.Map<String, Integer> resultados;
        private String timestamp;
        private String descripcion;
        
        public MementoVotacion(java.util.Map<String, Integer> resultados, String descripcion) {
            this.resultados = new java.util.LinkedHashMap<>(resultados);
            this.timestamp = new java.util.Date().toString();
            this.descripcion = descripcion;
        }
        
        public java.util.Map<String, Integer> getResultados() {
            return new java.util.LinkedHashMap<>(resultados);
        }
        
        public String getTimestamp() { return timestamp; }
        public String getDescripcion() { return descripcion; }
    }
    
    // =============================================
    // ORIGINATOR (Objeto cuyo estado queremos guardar)
    // =============================================
    class VotacionOriginator {
        private java.util.Map<String, Integer> resultados;
        private int totalVotos;
        
        public VotacionOriginator() {
            resultados = new java.util.LinkedHashMap<>();
            resultados.put("Candidato A", 0);
            resultados.put("Candidato B", 0);
            resultados.put("Candidato C", 0);
            resultados.put("Voto en Blanco", 0);
            totalVotos = 0;
        }
        
        public void votar(String candidato) {
            int actual = resultados.getOrDefault(candidato, 0);
            resultados.put(candidato, actual + 1);
            totalVotos++;
        }
        
        public void simularVotosAleatorios(int cantidad) {
            String[] candidatos = {"Candidato A", "Candidato B", "Candidato C", "Voto en Blanco"};
            java.util.Random rand = new java.util.Random();
            for(int i = 0; i < cantidad; i++) {
                String candidato = candidatos[rand.nextInt(candidatos.length)];
                votar(candidato);
            }
        }
        
        public MementoVotacion crearMemento(String descripcion) {
            return new MementoVotacion(resultados, descripcion);
        }
        
        public void restaurarMemento(MementoVotacion memento) {
            this.resultados = memento.getResultados();
            this.totalVotos = 0;
            for(int v : resultados.values()) totalVotos += v;
        }
        
        public java.util.Map<String, Integer> getResultados() { return resultados; }
        public int getTotalVotos() { return totalVotos; }
        
        public String getResultadosHTML() {
            StringBuilder sb = new StringBuilder();
            sb.append("<table style='width:100%;border-collapse:collapse;'>");
            sb.append("<tr style='background:#667eea;color:white;'><th>Candidato</th><th>Votos</th><th>%</th></tr>");
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                int porcentaje = totalVotos > 0 ? (e.getValue() * 100 / totalVotos) : 0;
                sb.append("<tr style='border-bottom:1px solid #ddd;'>");
                sb.append("<td style='padding:8px;'>").append(e.getKey()).append("</td>");
                sb.append("<td style='padding:8px;'>").append(e.getValue()).append("</td>");
                sb.append("<td style='padding:8px;'>").append(porcentaje).append("%</td>");
                sb.append("</tr>");
            }
            sb.append("</table>");
            return sb.toString();
        }
    }
    
    // =============================================
    // CARETAKER (Administra los mementos)
    // =============================================
    class HistoricoVotacion {
        private java.util.List<MementoVotacion> historial = new java.util.ArrayList<>();
        private int posicionActual = -1;
        
        public void guardar(MementoVotacion memento) {
            // Eliminar estados futuros si estamos en medio del historial
            if(posicionActual < historial.size() - 1) {
                historial = historial.subList(0, posicionActual + 1);
            }
            historial.add(memento);
            posicionActual++;
        }
        
        public MementoVotacion deshacer() {
            if(posicionActual > 0) {
                posicionActual--;
                return historial.get(posicionActual);
            }
            return null;
        }
        
        public MementoVotacion rehacer() {
            if(posicionActual < historial.size() - 1) {
                posicionActual++;
                return historial.get(posicionActual);
            }
            return null;
        }
        
        public boolean puedeDeshacer() { return posicionActual > 0; }
        public boolean puedeRehacer() { return posicionActual < historial.size() - 1; }
        
        public String getHistorialHTML() {
            if(historial.isEmpty()) return "No hay estados guardados";
            StringBuilder sb = new StringBuilder();
            sb.append("<ul style='margin:0; padding-left:20px;'>");
            for(int i = 0; i < historial.size(); i++) {
                MementoVotacion m = historial.get(i);
                String marker = (i == posicionActual) ? "📍 " : (i < posicionActual ? "✅ " : "⏳ ");
                sb.append("<li>").append(marker).append(m.getTimestamp()).append(" - ").append(m.getDescripcion()).append("</li>");
            }
            sb.append("</ul>");
            return sb.toString();
        }
        
        public String getPosicionInfo() {
            return "Estado " + (posicionActual + 1) + " de " + historial.size();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Memento</title>
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
        .btn-secondary { background: #999; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-card { background: #f8f9fa; border-radius: 16px; padding: 15px; margin: 10px 0; border-left: 4px solid #667eea; }
        .estado-actual { background: #e8f4f8; padding: 10px; border-radius: 8px; margin: 10px 0; text-align: center; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>💾 Demostración del Patrón Memento</h1>
        <p>Captura y externaliza el estado interno de un objeto para poder restaurarlo más tarde sin violar la encapsulación.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Votación con Deshacer/Rehacer</h3>
        
        <%
            VotacionOriginator votacion = (VotacionOriginator) session.getAttribute("votacionMemento");
            HistoricoVotacion historico = (HistoricoVotacion) session.getAttribute("historicoMemento");
            
            if(votacion == null) {
                votacion = new VotacionOriginator();
                historico = new HistoricoVotacion();
                // Guardar estado inicial
                historico.guardar(votacion.crearMemento("Estado inicial"));
                session.setAttribute("votacionMemento", votacion);
                session.setAttribute("historicoMemento", historico);
            }
            
            String accion = request.getParameter("accion");
            String resultado = "";
            
            if("votar".equals(accion)) {
                String candidato = request.getParameter("candidato");
                if(candidato != null && !candidato.isEmpty()) {
                    votacion.votar(candidato);
                    historico.guardar(votacion.crearMemento("Voto: " + candidato));
                    resultado = "🗳️ Voto registrado para: " + candidato;
                }
            } else if("simular".equals(accion)) {
                try {
                    int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                    votacion.simularVotosAleatorios(cantidad);
                    historico.guardar(votacion.crearMemento("Simulación: " + cantidad + " votos aleatorios"));
                    resultado = "🎲 " + cantidad + " votos aleatorios simulados";
                } catch(Exception e) {}
            } else if("deshacer".equals(accion)) {
                MementoVotacion m = historico.deshacer();
                if(m != null) {
                    votacion.restaurarMemento(m);
                    resultado = "↩️ Se deshizo la última acción. Estado restaurado: " + m.getDescripcion();
                } else {
                    resultado = "❌ No hay más acciones para deshacer";
                }
            } else if("rehacer".equals(accion)) {
                MementoVotacion m = historico.rehacer();
                if(m != null) {
                    votacion.restaurarMemento(m);
                    resultado = "↪️ Se rehízo la acción. Estado restaurado: " + m.getDescripcion();
                } else {
                    resultado = "❌ No hay más acciones para rehacer";
                }
            } else if("reset".equals(accion)) {
                session.invalidate();
                response.sendRedirect("test-memento.jsp");
                return;
            }
        %>
        
        <div class="grid-2">
            <!-- Panel de votación -->
            <div>
                <div class="info-card">
                    <div class="estado-actual">
                        📍 <%= historico.getPosicionInfo() %>
                    </div>
                    <div class="pre" style="margin: 0;">
                        <%= votacion.getResultadosHTML() %>
                        <div style="text-align: center; margin-top: 10px;">
                            <strong>Total votos:</strong> <%= votacion.getTotalVotos() %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Panel de acciones -->
            <div>
                <div class="info-card">
                    <div class="componente-title">⚡ Acciones</div>
                    
                    <!-- Votar manual -->
                    <form method="get" style="margin-bottom: 10px;">
                        <input type="hidden" name="accion" value="votar">
                        <select name="candidato" style="padding: 6px; border-radius: 6px; margin-right: 5px;">
                            <option>Candidato A</option>
                            <option>Candidato B</option>
                            <option>Candidato C</option>
                            <option>Voto en Blanco</option>
                        </select>
                        <button type="submit" class="btn">🗳️ Votar</button>
                    </form>
                    
                    <!-- Simular votos aleatorios -->
                    <form method="get" style="margin-bottom: 10px;">
                        <input type="hidden" name="accion" value="simular">
                        <select name="cantidad" style="padding: 6px; border-radius: 6px; margin-right: 5px;">
                            <option>1</option>
                            <option>5</option>
                            <option>10</option>
                            <option>20</option>
                        </select>
                        <button type="submit" class="btn btn-warning">🎲 Simular votos</button>
                    </form>
                    
                    <!-- Botones Deshacer/Rehacer -->
                    <div style="margin-top: 15px;">
                        <form method="get" style="display: inline;">
                            <input type="hidden" name="accion" value="deshacer">
                            <button type="submit" class="btn btn-danger" <%= !historico.puedeDeshacer() ? "disabled" : "" %>>↩️ Deshacer (Ctrl+Z)</button>
                        </form>
                        <form method="get" style="display: inline;">
                            <input type="hidden" name="accion" value="rehacer">
                            <button type="submit" class="btn btn-success" <%= !historico.puedeRehacer() ? "disabled" : "" %>>↪️ Rehacer (Ctrl+Y)</button>
                        </form>
                    </div>
                    
                    <form method="get" style="margin-top: 15px;">
                        <input type="hidden" name="accion" value="reset">
                        <button type="submit" class="btn btn-secondary">🔄 Reiniciar todo</button>
                    </form>
                </div>
                
                <div class="info-card">
                    <div class="componente-title">📋 Historial de estados guardados</div>
                    <div class="pre" style="font-size: 11px; max-height: 150px; overflow-y: auto;">
                        <%= historico.getHistorialHTML() %>
                    </div>
                </div>
            </div>
        </div>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <div class="pre" style="background: #e8f8f0;">
                <strong>📌 Resultado:</strong> <%= resultado %>
            </div>
        <% } %>
        
        <p><strong>🔍 ¿Qué es el patrón Memento?</strong><br>
        - <strong>Originator</strong> (Votacion): El objeto cuyo estado queremos guardar.<br>
        - <strong>Memento</strong>: Objeto que almacena el estado (resultados, timestamp, descripción).<br>
        - <strong>Caretaker</strong> (Historico): Administra los mementos, permite deshacer/rehacer.<br>
        <strong>💡 Cada vez que votas o simulas, se guarda un Memento. Puedes deshacer/rehacer acciones!</strong>
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>