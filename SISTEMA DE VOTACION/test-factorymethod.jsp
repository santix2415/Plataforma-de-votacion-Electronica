<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // CLASES DECLARADAS FUERA (en declaración JSP)
    // =============================================
    interface Exportador {
        String exportar(String datos);
    }
    
    class ExportadorHTML implements Exportador {
        public String exportar(String datos) {
            return "<div class='pre'>📄 <strong>HTML:</strong><br>" + datos + "</div>";
        }
    }
    
    class ExportadorTexto implements Exportador {
        public String exportar(String datos) {
            return "<div class='pre'>📝 <strong>TEXTO:</strong><br>" + datos + "</div>";
        }
    }
    
    class ExportadorJSON implements Exportador {
        public String exportar(String datos) {
            return "<div class='pre'>🔧 <strong>JSON:</strong><br>{\"datos\": \"" + datos.replace("\n", "\\n") + "\"}</div>";
        }
    }
    
    abstract class ExportadorService {
        public abstract Exportador crearExportador();
        public String exportar(String datos) {
            return crearExportador().exportar(datos);
        }
    }
    
    class ExportadorHTMLService extends ExportadorService {
        public Exportador crearExportador() {
            return new ExportadorHTML();
        }
    }
    
    class ExportadorTextoService extends ExportadorService {
        public Exportador crearExportador() {
            return new ExportadorTexto();
        }
    }
    
    class ExportadorJSONService extends ExportadorService {
        public Exportador crearExportador() {
            return new ExportadorJSON();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Factory Method</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; font-family: monospace; margin: 15px 0; white-space: pre-wrap; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🏭 Demostración del Patrón Factory Method</h1>
        <p>Define una interfaz para crear objetos, pero permite que las subclases decidan qué clase instanciar.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Exportadores de resultados</h3>
        <%
            String formato = request.getParameter("formato");
            String datos = "Candidato A: 450 votos\nCandidato B: 300 votos\nCandidato C: 200 votos";
            String resultado = "";
            
            if("HTML".equals(formato)) {
                ExportadorService service = new ExportadorHTMLService();
                resultado = service.exportar(datos);
            } else if("TEXTO".equals(formato)) {
                ExportadorService service = new ExportadorTextoService();
                resultado = service.exportar(datos);
            } else if("JSON".equals(formato)) {
                ExportadorService service = new ExportadorJSONService();
                resultado = service.exportar(datos);
            }
        %>
        <form method="get">
            <button type="submit" name="formato" value="HTML" class="btn">🌐 Exportar a HTML</button>
            <button type="submit" name="formato" value="TEXTO" class="btn">📝 Exportar a Texto</button>
            <button type="submit" name="formato" value="JSON" class="btn">🔧 Exportar a JSON</button>
        </form>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <%= resultado %>
        <% } %>
        
        <p><strong>ℹ️ Nota:</strong> Cada botón usa una fábrica diferente (HTMLService, TextoService, JSONService).</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>