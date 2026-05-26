<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // CLASES DECLARADAS FUERA (en declaración JSP)
    // =============================================
    interface SistemaVotacion {
        boolean autenticar(String cedula, String pass);
    }
    
    class SistemaPropio implements SistemaVotacion {
        public boolean autenticar(String cedula, String pass) {
            return "12345".equals(cedula) && "admin123".equals(pass);
        }
    }
    
    class GoogleAuth {
        public boolean login(String email, String pass) {
            return "admin@gmail.com".equals(email) && "admin123".equals(pass);
        }
    }
    
    class GoogleAdapter implements SistemaVotacion {
        private GoogleAuth google = new GoogleAuth();
        
        public boolean autenticar(String cedula, String pass) {
            return google.login(cedula + "@gmail.com", pass);
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Adapter</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 700px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .exito { background: #e8f8f0; color: #22543d; }
        .error { background: #fed7d7; color: #c53030; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔌 Demostración del Patrón Adapter</h1>
        <p>Actúa como un puente entre dos interfaces incompatibles, permitiendo que trabajen juntas.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Autenticación con diferentes sistemas</h3>
        <%
            String tipo = request.getParameter("tipo");
            String resultado = "";
            String claseResultado = "";
            
            if("propio".equals(tipo)) {
                SistemaVotacion auth = new SistemaPropio();
                boolean ok = auth.autenticar("12345", "admin123");
                resultado = ok ? "✅ Acceso concedido (Sistema Propio)" : "❌ Acceso denegado";
                claseResultado = ok ? "exito" : "error";
            } else if("google".equals(tipo)) {
                SistemaVotacion auth = new GoogleAdapter();
                boolean ok = auth.autenticar("12345", "admin123");
                resultado = ok ? "✅ Acceso concedido (Google vía Adapter)" : "❌ Acceso denegado";
                claseResultado = ok ? "exito" : "error";
            }
        %>
        <form method="get">
            <button type="submit" name="tipo" value="propio" class="btn">🔐 Autenticación con Sistema Propio</button>
            <button type="submit" name="tipo" value="google" class="btn">🌐 Autenticación con Google (vía Adapter)</button>
        </form>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <div class="pre <%= claseResultado %>">
                <strong>📋 Resultado de la autenticación:</strong><br>
                <%= resultado %>
            </div>
        <% } %>
        
        <p><strong>📚 ¿Qué es el patrón Adapter?</strong><br>
        <strong>Sistema propio</strong> usa cédula + contraseña.<br>
        <strong>Google</strong> usa email + contraseña (incompatible).<br>
        El <strong>GoogleAdapter</strong> traduce: convierte la cédula en email para que el sistema de votación pueda usar Google.</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>