<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // CLASES DECLARADAS FUERA
    // =============================================
    interface Boton {
        String renderizar();
    }
    
    interface Tabla {
        String renderizar();
    }
    
    interface UIFactory {
        Boton crearBoton();
        Tabla crearTabla();
    }
    
    // ========== WEB ==========
    class BotonWeb implements Boton {
        public String renderizar() {
            return "<button onclick='alert(\"🌐 Acción desde Web\")' style='background:#667eea;color:white;padding:12px 24px;border:none;border-radius:40px;cursor:pointer;font-size:16px;'>🌐 Botón Web (haz clic)</button>";
        }
    }
    
    class TablaWeb implements Tabla {
        public String renderizar() {
            return "<table border='1' style='width:100%;border-collapse:collapse;'>" +
                   "<tr style='background:#667eea;color:white;'><th>Nombre</th><th>Votos</th></tr>" +
                   "<tr><td>Candidato A</td><td>450</td></tr>" +
                   "<tr><td>Candidato B</td><td>300</td></tr>" +
                   "</table>";
        }
    }
    
    class WebFactory implements UIFactory {
        public Boton crearBoton() { return new BotonWeb(); }
        public Tabla crearTabla() { return new TablaWeb(); }
    }
    
    // ========== MÓVIL ==========
    class BotonMovil implements Boton {
        public String renderizar() {
            return "<div onclick='alert(\"📱 Acción desde Móvil\")' style='background:#48bb78;color:white;padding:15px;text-align:center;border-radius:40px;font-size:18px;cursor:pointer;'>📱 Botón Móvil (toca aquí)</div>";
        }
    }
    
    class TablaMovil implements Tabla {
        public String renderizar() {
            return "<div style='border:1px solid #48bb78;border-radius:12px;padding:12px;margin:5px;background:#f0fff4;'>📱 Candidato A: 450 votos</div>" +
                   "<div style='border:1px solid #48bb78;border-radius:12px;padding:12px;margin:5px;background:#f0fff4;'>📱 Candidato B: 300 votos</div>";
        }
    }
    
    class MovilFactory implements UIFactory {
        public Boton crearBoton() { return new BotonMovil(); }
        public Tabla crearTabla() { return new TablaMovil(); }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Abstract Factory</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; }
        .vista { margin-top: 20px; padding: 20px; border-radius: 16px; background: #f8f9fa; text-align: center; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🏛️ Demostración del Patrón Abstract Factory</h1>
        <p>Proporciona una interfaz para crear familias de objetos relacionados (botones y tablas) según la plataforma.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Web vs Móvil</h3>
        <%
            String plataforma = request.getParameter("plataforma");
            UIFactory factory = null;
            String mensaje = "";
            
            if("web".equals(plataforma)) {
                factory = new WebFactory();
                mensaje = "🌐 Vista Web (Escritorio)";
            } else if("movil".equals(plataforma)) {
                factory = new MovilFactory();
                mensaje = "📱 Vista Móvil (Celular)";
            }
        %>
        <form method="get">
            <button type="submit" name="plataforma" value="web" class="btn">🌐 Cambiar a Web</button>
            <button type="submit" name="plataforma" value="movil" class="btn">📱 Cambiar a Móvil</button>
        </form>
        
        <% if(factory != null) { %>
            <div class="vista">
                <h4><%= mensaje %></h4>
                <p><strong>🔘 Botón:</strong></p>
                <%= factory.crearBoton().renderizar() %>
                <p style="margin-top:20px;"><strong>📊 Tabla/Resultados:</strong></p>
                <%= factory.crearTabla().renderizar() %>
            </div>
        <% } else { %>
            <div class="vista">
                <p>👆 Selecciona una plataforma arriba para ver la diferencia</p>
                <p><strong>Web</strong> = botón azul + tabla con filas</p>
                <p><strong>Móvil</strong> = botón verde grande + tarjetas</p>
            </div>
        <% } %>
        
        <p><strong>🔍 Prueba presionando el botón</strong> que aparece dentro de cada vista.</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>