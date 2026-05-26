<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // CLASE BASE CON TEMPLATE METHOD
    // =============================================
    abstract class ProcesoVotacion {
        
        // TEMPLATE METHOD (define el esqueleto del algoritmo)
        public final String ejecutar(String cedula, String candidato) {
            StringBuilder resultado = new StringBuilder();
            
            resultado.append(autenticar(cedula)).append("\n");
            resultado.append(validarVotoUnico(cedula)).append("\n");
            resultado.append(registrarVoto(cedula, candidato)).append("\n");
            resultado.append(actualizarResultados(cedula, candidato)).append("\n");
            resultado.append(confirmarVoto(cedula, candidato)).append("\n");
            
            return resultado.toString();
        }
        
        // Métodos que las subclases pueden sobrescribir (hooks)
        protected String autenticar(String cedula) { return ""; }
        protected abstract String validarVotoUnico(String cedula);
        protected abstract String registrarVoto(String cedula, String candidato);
        protected abstract String actualizarResultados(String cedula, String candidato);
        protected String confirmarVoto(String cedula, String candidato) { 
            return "✅ Voto registrado exitosamente";
        }
        
        // Método opcional que puede ser sobrescrito
        protected boolean esVotoValido(String candidato) { return true; }
    }
    
    // =============================================
    // IMPLEMENTACIÓN 1: Votación Normal
    // =============================================
    class VotacionNormal extends ProcesoVotacion {
        private java.util.Map<String, Boolean> votantes = new java.util.HashMap<>();
        private java.util.Map<String, Integer> resultados = new java.util.HashMap<>();
        private java.util.List<String> bitacora = new java.util.ArrayList<>();
        
        public VotacionNormal() {
            resultados.put("Candidato A", 0);
            resultados.put("Candidato B", 0);
            resultados.put("Candidato C", 0);
            resultados.put("Voto en Blanco", 0);
        }
        
        protected String autenticar(String cedula) {
            return "🔐 Autenticación exitosa para cédula: " + cedula;
        }
        
        protected String validarVotoUnico(String cedula) {
            if(votantes.containsKey(cedula)) {
                return "❌ Error: El votante " + cedula + " ya ha votado anteriormente";
            }
            return "✅ Validación superada: El votante no ha votado antes";
        }
        
        protected String registrarVoto(String cedula, String candidato) {
            votantes.put(cedula, true);
            return "📝 Voto registrado: " + cedula + " → " + candidato;
        }
        
        protected String actualizarResultados(String cedula, String candidato) {
            int actual = resultados.getOrDefault(candidato, 0);
            resultados.put(candidato, actual + 1);
            bitacora.add(cedula + " votó por " + candidato);
            return "📊 Resultados actualizados: " + candidato + " ahora tiene " + (actual + 1) + " votos";
        }
        
        public String getResultados() {
            StringBuilder sb = new StringBuilder();
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                sb.append(e.getKey()).append(": ").append(e.getValue()).append(" votos\n");
            }
            return sb.toString();
        }
        
        public String getBitacora() {
            if(bitacora.isEmpty()) return "No hay registros";
            StringBuilder sb = new StringBuilder();
            for(String b : bitacora) sb.append("• ").append(b).append("\n");
            return sb.toString();
        }
    }
    
    // =============================================
    // IMPLEMENTACIÓN 2: Votación con Auditoría (extiende Template)
    // =============================================
    class VotacionConAuditoria extends VotacionNormal {
        private java.util.List<String> auditoria = new java.util.ArrayList<>();
        
        protected String autenticar(String cedula) {
            String resultado = super.autenticar(cedula);
            auditoria.add("AUTENTICACIÓN: " + cedula + " a las " + new java.util.Date());
            return "🔍 [AUDITORÍA] " + resultado;
        }
        
        protected String validarVotoUnico(String cedula) {
            String resultado = super.validarVotoUnico(cedula);
            auditoria.add("VALIDACIÓN: " + cedula + " - " + resultado);
            return "🔍 [AUDITORÍA] " + resultado;
        }
        
        protected String registrarVoto(String cedula, String candidato) {
            String resultado = super.registrarVoto(cedula, candidato);
            auditoria.add("REGISTRO: " + cedula + " votó por " + candidato);
            return "🔍 [AUDITORÍA] " + resultado;
        }
        
        protected String confirmarVoto(String cedula, String candidato) {
            auditoria.add("CONFIRMACIÓN: Voto de " + cedula + " confirmado");
            return "🔍 [AUDITORÍA] ✅ Voto confirmado y registrado en auditoría";
        }
        
        public String getAuditoria() {
            if(auditoria.isEmpty()) return "No hay registros de auditoría";
            StringBuilder sb = new StringBuilder();
            for(String a : auditoria) sb.append("• ").append(a).append("\n");
            return sb.toString();
        }
    }
    
    // =============================================
    // IMPLEMENTACIÓN 3: Votación Express (versión simplificada)
    // =============================================
    class VotacionExpress extends ProcesoVotacion {
        private java.util.Map<String, Boolean> votantes = new java.util.HashMap<>();
        private java.util.Map<String, Integer> resultados = new java.util.HashMap<>();
        
        public VotacionExpress() {
            resultados.put("Candidato A", 0);
            resultados.put("Candidato B", 0);
            resultados.put("Candidato C", 0);
            resultados.put("Voto en Blanco", 0);
        }
        
        protected String autenticar(String cedula) {
            return "⚡ Autenticación rápida: " + cedula;
        }
        
        protected String validarVotoUnico(String cedula) {
            if(votantes.containsKey(cedula)) {
                return "⚡ Error: Ya votaste antes";
            }
            return "⚡ OK - Puedes votar";
        }
        
        protected String registrarVoto(String cedula, String candidato) {
            votantes.put(cedula, true);
            int actual = resultados.getOrDefault(candidato, 0);
            resultados.put(candidato, actual + 1);
            return "⚡ Voto registrado!";
        }
        
        protected String actualizarResultados(String cedula, String candidato) {
            return "⚡ Resultados actualizados";
        }
        
        protected String confirmarVoto(String cedula, String candidato) {
            return "⚡ ¡Gracias por votar!";
        }
        
        public String getResultados() {
            StringBuilder sb = new StringBuilder();
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                sb.append(e.getKey()).append(": ").append(e.getValue()).append("\n");
            }
            return sb.toString();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Template Method</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 1000px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .btn-normal { background: #48bb78; }
        .btn-auditoria { background: #f6ad55; }
        .btn-express { background: #4299e1; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 20px 0; }
        .plantilla { background: #e8f4f8; padding: 10px; border-radius: 8px; font-family: monospace; font-size: 12px; margin: 10px 0; }
        input, select { padding: 8px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 13px; }
        .template-card { background: #f8f9fa; border-radius: 16px; padding: 15px; margin: 10px 0; border-top: 4px solid #667eea; }
    </style>
</head>
<body>
    <div class="card">
        <h1>📋 Demostración del Patrón Template Method</h1>
        <p>Define el esqueleto de un algoritmo en una operación, delegando algunos pasos a las subclases.</p>
    </div>
    
    <div class="card">
        <div class="plantilla">
            <strong>📌 TEMPLATE METHOD (Plantilla de votación):</strong><br>
            ejecutar(cedula, candidato) {<br>
            &nbsp;&nbsp;1️⃣ autenticar(cedula)<br>
            &nbsp;&nbsp;2️⃣ validarVotoUnico(cedula)<br>
            &nbsp;&nbsp;3️⃣ registrarVoto(cedula, candidato)<br>
            &nbsp;&nbsp;4️⃣ actualizarResultados(cedula, candidato)<br>
            &nbsp;&nbsp;5️⃣ confirmarVoto(cedula, candidato)<br>
            }
        </div>
    </div>
    
    <div class="grid-3">
        <!-- Tarjeta 1: Votación Normal -->
        <div class="card" style="margin:0; padding:20px;">
            <h3 style="color:#48bb78;">✅ Votación Normal</h3>
            <form method="get">
                <input type="hidden" name="tipo" value="normal">
                <input type="hidden" name="accion" value="votar">
                <input type="text" name="cedula" placeholder="Cédula" style="width:100%; margin:5px 0;" required>
                <select name="candidato" style="width:100%; margin:5px 0;">
                    <option>Candidato A</option>
                    <option>Candidato B</option>
                    <option>Candidato C</option>
                    <option>Voto en Blanco</option>
                </select>
                <button type="submit" class="btn btn-normal" style="width:100%;">🗳️ Votar</button>
            </form>
            <%
                if("normal".equals(request.getParameter("tipo")) && "votar".equals(request.getParameter("accion"))) {
                    VotacionNormal vn = (VotacionNormal) session.getAttribute("votacionNormal");
                    if(vn == null) vn = new VotacionNormal();
                    String cedula = request.getParameter("cedula");
                    String candidato = request.getParameter("candidato");
                    String resultado = vn.ejecutar(cedula, candidato);
                    session.setAttribute("votacionNormal", vn);
                    out.println("<div class='pre' style='font-size:11px; margin-top:10px;'>" + resultado.replace("\n", "<br>") + "</div>");
                    out.println("<div class='pre' style='font-size:11px;'><strong>Resultados:</strong><br>" + vn.getResultados().replace("\n", "<br>") + "</div>");
                } else {
                    VotacionNormal vn = (VotacionNormal) session.getAttribute("votacionNormal");
                    if(vn != null) {
                        out.println("<div class='pre' style='font-size:11px; margin-top:10px;'><strong>Resultados:</strong><br>" + vn.getResultados().replace("\n", "<br>") + "</div>");
                    }
                }
            %>
        </div>
        
        <!-- Tarjeta 2: Votación con Auditoría -->
        <div class="card" style="margin:0; padding:20px;">
            <h3 style="color:#f6ad55;">🔍 Votación con Auditoría</h3>
            <form method="get">
                <input type="hidden" name="tipo" value="auditoria">
                <input type="hidden" name="accion" value="votar">
                <input type="text" name="cedula" placeholder="Cédula" style="width:100%; margin:5px 0;" required>
                <select name="candidato" style="width:100%; margin:5px 0;">
                    <option>Candidato A</option>
                    <option>Candidato B</option>
                    <option>Candidato C</option>
                    <option>Voto en Blanco</option>
                </select>
                <button type="submit" class="btn btn-auditoria" style="width:100%;">🗳️ Votar con Auditoría</button>
            </form>
            <%
                if("auditoria".equals(request.getParameter("tipo")) && "votar".equals(request.getParameter("accion"))) {
                    VotacionConAuditoria va = (VotacionConAuditoria) session.getAttribute("votacionAuditoria");
                    if(va == null) va = new VotacionConAuditoria();
                    String cedula = request.getParameter("cedula");
                    String candidato = request.getParameter("candidato");
                    String resultado = va.ejecutar(cedula, candidato);
                    session.setAttribute("votacionAuditoria", va);
                    out.println("<div class='pre' style='font-size:11px; margin-top:10px;'>" + resultado.replace("\n", "<br>") + "</div>");
                    out.println("<div class='pre' style='font-size:11px;'><strong>Resultados:</strong><br>" + va.getResultados().replace("\n", "<br>") + "</div>");
                    out.println("<div class='pre' style='font-size:11px;'><strong>Auditoría:</strong><br>" + va.getAuditoria().replace("\n", "<br>") + "</div>");
                } else {
                    VotacionConAuditoria va = (VotacionConAuditoria) session.getAttribute("votacionAuditoria");
                    if(va != null) {
                        out.println("<div class='pre' style='font-size:11px; margin-top:10px;'><strong>Resultados:</strong><br>" + va.getResultados().replace("\n", "<br>") + "</div>");
                    }
                }
            %>
        </div>
        
        <!-- Tarjeta 3: Votación Express -->
        <div class="card" style="margin:0; padding:20px;">
            <h3 style="color:#4299e1;">⚡ Votación Express</h3>
            <form method="get">
                <input type="hidden" name="tipo" value="express">
                <input type="hidden" name="accion" value="votar">
                <input type="text" name="cedula" placeholder="Cédula" style="width:100%; margin:5px 0;" required>
                <select name="candidato" style="width:100%; margin:5px 0;">
                    <option>Candidato A</option>
                    <option>Candidato B</option>
                    <option>Candidato C</option>
                    <option>Voto en Blanco</option>
                </select>
                <button type="submit" class="btn btn-express" style="width:100%;">⚡ Votar Express</button>
            </form>
            <%
                if("express".equals(request.getParameter("tipo")) && "votar".equals(request.getParameter("accion"))) {
                    VotacionExpress ve = (VotacionExpress) session.getAttribute("votacionExpress");
                    if(ve == null) ve = new VotacionExpress();
                    String cedula = request.getParameter("cedula");
                    String candidato = request.getParameter("candidato");
                    String resultado = ve.ejecutar(cedula, candidato);
                    session.setAttribute("votacionExpress", ve);
                    out.println("<div class='pre' style='font-size:11px; margin-top:10px;'>" + resultado.replace("\n", "<br>") + "</div>");
                    out.println("<div class='pre' style='font-size:11px;'><strong>Resultados:</strong><br>" + ve.getResultados().replace("\n", "<br>") + "</div>");
                } else {
                    VotacionExpress ve = (VotacionExpress) session.getAttribute("votacionExpress");
                    if(ve != null) {
                        out.println("<div class='pre' style='font-size:11px; margin-top:10px;'><strong>Resultados:</strong><br>" + ve.getResultados().replace("\n", "<br>") + "</div>");
                    }
                }
            %>
        </div>
    </div>
    
    <div class="card">
        <div class="template-card">
            <strong>🔍 ¿Qué es el patrón Template Method?</strong><br><br>
            El <strong>Template Method</strong> define el esqueleto de un algoritmo en un método (ejecutar), pero permite que las subclases 
            sobrescriban ciertos pasos:<br><br>
            📌 <strong>Pasos del Template:</strong><br>
            <div class="plantilla" style="background:#f0f0f0;">
                1️⃣ autenticar()<br>
                2️⃣ validarVotoUnico()<br>
                3️⃣ registrarVoto()<br>
                4️⃣ actualizarResultados()<br>
                5️⃣ confirmarVoto()
            </div>
            <strong>💡 Cada implementación personaliza los pasos:</strong><br>
            - <span style="color:#48bb78;">Votación Normal</span>: Pasos estándar.<br>
            - <span style="color:#f6ad55;">Votación con Auditoría</span>: Agrega registros detallados en cada paso.<br>
            - <span style="color:#4299e1;">Votación Express</span>: Versión simplificada y rápida.<br>
            <strong>🎯 El esqueleto del algoritmo NO cambia, solo los detalles de cada paso.</strong>
        </div>
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
    
    <%
        // Botón para reiniciar
        if("reset".equals(request.getParameter("accionGlobal"))) {
            session.removeAttribute("votacionNormal");
            session.removeAttribute("votacionAuditoria");
            session.removeAttribute("votacionExpress");
            response.sendRedirect("test-templatemethod.jsp");
            return;
        }
    %>
    
    <div class="card" style="text-align: center;">
        <form method="get">
            <input type="hidden" name="accionGlobal" value="reset">
            <button type="submit" class="btn" style="background:#999;">🔄 Reiniciar todas las votaciones</button>
        </form>
    </div>
</body>
</html>