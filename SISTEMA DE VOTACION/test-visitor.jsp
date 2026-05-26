<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ VISITABLE
    // =============================================
    interface ElementoVotacion {
        void aceptar(VisitanteVotacion visitante);
    }
    
    // =============================================
    // INTERFAZ VISITANTE
    // =============================================
    interface VisitanteVotacion {
        void visitar(CandidatoElemento candidato);
        void visitar(PartidoElemento partido);
        String getResultado();
    }
    
    // =============================================
    // ELEMENTOS CONCRETOS (Candidato)
    // =============================================
    class CandidatoElemento implements ElementoVotacion {
        private String nombre;
        private String partido;
        private int votos;
        
        public CandidatoElemento(String nombre, String partido, int votos) {
            this.nombre = nombre;
            this.partido = partido;
            this.votos = votos;
        }
        
        public void aceptar(VisitanteVotacion visitante) {
            visitante.visitar(this);
        }
        
        public String getNombre() { return nombre; }
        public String getPartido() { return partido; }
        public int getVotos() { return votos; }
    }
    
    // =============================================
    // ELEMENTOS CONCRETOS (Partido)
    // =============================================
    class PartidoElemento implements ElementoVotacion {
        private String nombre;
        private java.util.List<CandidatoElemento> candidatos = new java.util.ArrayList<>();
        
        public PartidoElemento(String nombre) {
            this.nombre = nombre;
        }
        
        public void agregarCandidato(CandidatoElemento c) {
            candidatos.add(c);
        }
        
        public void aceptar(VisitanteVotacion visitante) {
            visitante.visitar(this);
            for(CandidatoElemento c : candidatos) {
                c.aceptar(visitante);
            }
        }
        
        public String getNombre() { return nombre; }
        public java.util.List<CandidatoElemento> getCandidatos() { return candidatos; }
        public int getTotalVotos() {
            int total = 0;
            for(CandidatoElemento c : candidatos) total += c.getVotos();
            return total;
        }
    }
    
    // =============================================
    // VISITANTE 1: Calculador de votos totales
    // =============================================
    class CalculadorVotosVisitor implements VisitanteVotacion {
        private int totalVotos = 0;
        private StringBuilder resultado = new StringBuilder();
        
        public void visitar(CandidatoElemento candidato) {
            totalVotos += candidato.getVotos();
            resultado.append("  • ").append(candidato.getNombre())
                     .append(": ").append(candidato.getVotos()).append(" votos\n");
        }
        
        public void visitar(PartidoElemento partido) {
            resultado.append("📊 Partido: ").append(partido.getNombre())
                     .append(" (Total: ").append(partido.getTotalVotos()).append(" votos)\n");
        }
        
        public String getResultado() {
            return "TOTAL GENERAL DE VOTOS: " + totalVotos + "\n\n" + resultado.toString();
        }
    }
    
    // =============================================
    // VISITANTE 2: Exportador a HTML
    // =============================================
    class ExportadorHTMLVisitor implements VisitanteVotacion {
        private StringBuilder html = new StringBuilder();
        
        public void visitar(CandidatoElemento candidato) {
            html.append("<tr>");
            html.append("<td>").append(candidato.getNombre()).append("</td>");
            html.append("<td>").append(candidato.getPartido()).append("</td>");
            html.append("<td>").append(candidato.getVotos()).append("</td>");
            html.append("</tr>");
        }
        
        public void visitar(PartidoElemento partido) {
            html.append("<tr style='background:#e0e0e0; font-weight:bold;'>");
            html.append("<td colspan='2'>🏛️ ").append(partido.getNombre()).append(" (Total)</td>");
            html.append("<td>").append(partido.getTotalVotos()).append("</td>");
            html.append("</tr>");
        }
        
        public String getResultado() {
            return "<table style='width:100%; border-collapse:collapse;'>" +
                   "<tr style='background:#667eea; color:white;'><th>Candidato</th><th>Partido</th><th>Votos</th></tr>" +
                   html.toString() +
                   "</table>";
        }
    }
    
    // =============================================
    // VISITANTE 3: Filtrador de candidatos (votos > umbral)
    // =============================================
    class FiltradorVisitor implements VisitanteVotacion {
        private int umbral;
        private StringBuilder resultado = new StringBuilder();
        
        public FiltradorVisitor(int umbral) {
            this.umbral = umbral;
        }
        
        public void visitar(CandidatoElemento candidato) {
            if(candidato.getVotos() > umbral) {
                resultado.append("  • ").append(candidato.getNombre())
                         .append(" (").append(candidato.getPartido()).append("): ")
                         .append(candidato.getVotos()).append(" votos\n");
            }
        }
        
        public void visitar(PartidoElemento partido) {
            resultado.append("📊 Partido: ").append(partido.getNombre()).append("\n");
        }
        
        public String getResultado() {
            if(resultado.toString().trim().isEmpty()) {
                return "No hay candidatos con más de " + umbral + " votos";
            }
            return "Candidatos con más de " + umbral + " votos:\n" + resultado.toString();
        }
    }
    
    // =============================================
    // VISITANTE 4: Generador de reporte simple
    // =============================================
    class GeneradorReporteVisitor implements VisitanteVotacion {
        private StringBuilder reporte = new StringBuilder();
        
        public void visitar(CandidatoElemento candidato) {
            // No hacer nada aquí, los candidatos se procesan dentro del partido
        }
        
        public void visitar(PartidoElemento partido) {
            reporte.append("🏛️ ").append(partido.getNombre()).append(": ").append(partido.getTotalVotos()).append(" votos\n");
            for(CandidatoElemento c : partido.getCandidatos()) {
                reporte.append("   └─ ").append(c.getNombre()).append(": ").append(c.getVotos()).append(" votos\n");
            }
        }
        
        public String getResultado() {
            return "=== REPORTE ELECTORAL ===\n\n" + reporte.toString();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Visitor</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 1000px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 13px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-card { background: #f8f9fa; border-radius: 16px; padding: 15px; margin: 10px 0; border-left: 4px solid #667eea; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🧳 Demostración del Patrón Visitor</h1>
        <p>Permite separar algoritmos de los objetos sobre los que operan, agregando nuevas operaciones sin modificar las clases existentes.</p>
    </div>
    
    <%
        // Crear estructura electoral
        PartidoElemento partidoA = (PartidoElemento) session.getAttribute("partidoAVisitor");
        if(partidoA == null) {
            partidoA = new PartidoElemento("Partido A");
            partidoA.agregarCandidato(new CandidatoElemento("Ana López", "Partido A", 450));
            partidoA.agregarCandidato(new CandidatoElemento("Carlos Ruiz", "Partido A", 300));
            partidoA.agregarCandidato(new CandidatoElemento("Martha Gómez", "Partido A", 200));
            session.setAttribute("partidoAVisitor", partidoA);
        }
        
        PartidoElemento partidoB = (PartidoElemento) session.getAttribute("partidoBVisitor");
        if(partidoB == null) {
            partidoB = new PartidoElemento("Partido B");
            partidoB.agregarCandidato(new CandidatoElemento("Luis Pérez", "Partido B", 150));
            partidoB.agregarCandidato(new CandidatoElemento("Sofía Ramírez", "Partido B", 100));
            session.setAttribute("partidoBVisitor", partidoB);
        }
        
        String accion = request.getParameter("accion");
        String resultado = "";
        
        if("calcularVotos".equals(accion)) {
            CalculadorVotosVisitor visitor = new CalculadorVotosVisitor();
            partidoA.aceptar(visitor);
            partidoB.aceptar(visitor);
            resultado = visitor.getResultado();
        } else if("exportarHTML".equals(accion)) {
            ExportadorHTMLVisitor visitor = new ExportadorHTMLVisitor();
            partidoA.aceptar(visitor);
            partidoB.aceptar(visitor);
            resultado = visitor.getResultado();
        } else if("filtrar".equals(accion)) {
            int umbral = 250;
            String umbralParam = request.getParameter("umbral");
            if(umbralParam != null) umbral = Integer.parseInt(umbralParam);
            FiltradorVisitor visitor = new FiltradorVisitor(umbral);
            partidoA.aceptar(visitor);
            partidoB.aceptar(visitor);
            resultado = visitor.getResultado();
        } else if("reporte".equals(accion)) {
            GeneradorReporteVisitor visitor = new GeneradorReporteVisitor();
            partidoA.aceptar(visitor);
            partidoB.aceptar(visitor);
            resultado = visitor.getResultado();
        }
    %>
    
    <div class="grid-2">
        <!-- Panel de estructura -->
        <div class="info-card">
            <h3>🏛️ Estructura Electoral</h3>
            <table>
                <tr><th>Partido</th><th>Candidato</th><th>Votos</th></tr>
                <% for(CandidatoElemento c : partidoA.getCandidatos()) { %>
                <tr><td><%= partidoA.getNombre() %></td><td><%= c.getNombre() %></td><td><%= c.getVotos() %></td></tr>
                <% } %>
                <% for(CandidatoElemento c : partidoB.getCandidatos()) { %>
                <tr><td><%= partidoB.getNombre() %></td><td><%= c.getNombre() %></td><td><%= c.getVotos() %></td></tr>
                <% } %>
            </table>
        </div>
        
        <!-- Panel de visitantes -->
        <div class="info-card">
            <h3>🧳 Visitantes (Operaciones)</h3>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="calcularVotos">
                <button type="submit" class="btn">📊 Calcular total de votos</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="exportarHTML">
                <button type="submit" class="btn">🌐 Exportar a HTML</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="reporte">
                <button type="submit" class="btn">📋 Generar reporte</button>
            </form>
            <form method="get" style="margin-top: 10px;">
                <input type="hidden" name="accion" value="filtrar">
                <input type="number" name="umbral" placeholder="Umbral de votos" style="width: 120px; padding: 5px;">
                <button type="submit" class="btn">🔍 Filtrar candidatos</button>
            </form>
        </div>
    </div>
    
    <% if(resultado != null && !resultado.isEmpty()) { %>
        <div class="pre">
            <strong>📌 Resultado de la operación:</strong><br>
            <%= resultado %>
        </div>
    <% } %>
    
    <div class="info-card">
        <strong>🔍 ¿Qué es el patrón Visitor?</strong><br><br>
        El <strong>Visitor</strong> permite agregar nuevas operaciones sin modificar las clases existentes:<br><br>
        📌 <strong>Estructura (Elementos):</strong><br>
        - <strong>PartidoElemento</strong> (contiene candidatos)<br>
        - <strong>CandidatoElemento</strong> (hoja)<br><br>
        📌 <strong>Visitantes (Operaciones):</strong><br>
        - <strong>CalculadorVotosVisitor</strong> → Calcula total de votos<br>
        - <strong>ExportadorHTMLVisitor</strong> → Exporta a formato HTML<br>
        - <strong>FiltradorVisitor</strong> → Filtra candidatos por umbral<br>
        - <strong>GeneradorReporteVisitor</strong> → Genera reporte jerárquico<br><br>
        <strong>💡 Para agregar una nueva operación (ej. ExportadorJSON), solo creas un nuevo Visitor. ¡No tocas las clases Partido ni Candidato!</strong>
    </div>
    
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>