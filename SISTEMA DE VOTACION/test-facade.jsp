<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Facade</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 12px 24px; border-radius: 8px; border: none; cursor: pointer; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🏢 Demostración del Patrón Facade</h1>
        <p>Proporciona una interfaz simplificada y unificada para un subsistema complejo.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Proceso de Votación</h3>
        <%
            class UsuarioSubsistema { boolean registrar(String c, String n, String p){ return true; } boolean existe(String c){ return true; } }
            class VotacionSubsistema { boolean votar(String c, String cand){ return true; } }
            class ResultadosSubsistema { String obtener(){ return "Candidato A: 450 votos\nCandidato B: 300 votos"; } }
            class ExportadorSubsistema { String exportar(String datos){ return "📄 Exportado:\n" + datos; } }
            
            class VotacionFacade {
                private UsuarioSubsistema usuario = new UsuarioSubsistema();
                private VotacionSubsistema votacion = new VotacionSubsistema();
                private ResultadosSubsistema resultados = new ResultadosSubsistema();
                private ExportadorSubsistema exportador = new ExportadorSubsistema();
                public boolean registrarVotante(String c, String n, String p){ return usuario.registrar(c,n,p); }
                public boolean emitirVoto(String c, String cand){ return votacion.votar(c,cand); }
                public String verResultados(){ return resultados.obtener(); }
                public String exportarResultados(){ return exportador.exportar(resultados.obtener()); }
            }
            
            if("simular".equals(request.getParameter("action"))) {
                VotacionFacade facade = new VotacionFacade();
                out.println("<div class='pre'>");
                out.println("📋 <strong>Operaciones realizadas a través de la Facade:</strong><br><br>");
                out.println("1️⃣ Registrar votante: " + (facade.registrarVotante("12345", "Juan", "pass") ? "✅ Exitoso" : "❌ Fallo") + "<br>");
                out.println("2️⃣ Emitir voto: " + (facade.emitirVoto("12345", "Candidato A") ? "✅ Exitoso" : "❌ Fallo") + "<br>");
                out.println("3️⃣ Ver resultados: <br>" + facade.verResultados() + "<br>");
                out.println("4️⃣ Exportar resultados: <br>" + facade.exportarResultados() + "<br>");
                out.println("</div>");
            }
        %>
        <form method="get">
            <button type="submit" name="action" value="simular" class="btn">🚀 Simular proceso completo</button>
        </form>
        <p><strong>ℹ️ Nota:</strong> La Facade simplifica la interacción con los subsistemas (usuarios, votación, resultados, exportación).</p>
    </div>
    <div class="card"><a href="index.html">← Volver al inicio</a></div>
</body>
</html>