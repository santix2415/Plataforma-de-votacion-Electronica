<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Singleton</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 24px; border-radius: 8px; border: none; cursor: pointer; margin-right: 10px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; font-family: monospace; margin: 15px 0; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🧪 Demostración del Patrón Singleton</h1>
        <p>Garantiza que una clase tenga <strong>una única instancia</strong> en toda la aplicación.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación</h3>
        
        <%
            // Usamos el scope de aplicación para simular Singleton
            // Esto funciona en cualquier versión de Tomcat
            
            String valorConfiguracion = (String) application.getAttribute("configuracion_valor");
            Integer contadorCreaciones = (Integer) application.getAttribute("configuracion_contador");
            
            if(valorConfiguracion == null) {
                valorConfiguracion = "Configuración inicial";
                contadorCreaciones = 1;
                application.setAttribute("configuracion_valor", valorConfiguracion);
                application.setAttribute("configuracion_contador", contadorCreaciones);
                out.println("<div class='pre'>🆕 Se creó la configuración por primera vez (Singleton)</div>");
            } else {
                contadorCreaciones++;
                application.setAttribute("configuracion_contador", contadorCreaciones);
            }
            
            if("cambiar".equals(request.getParameter("action"))) {
                valorConfiguracion = "Nuevo valor modificado: " + new java.util.Date();
                application.setAttribute("configuracion_valor", valorConfiguracion);
                out.println("<div class='pre'>✅ Se modificó el valor de la configuración</div>");
            }
            
            valorConfiguracion = (String) application.getAttribute("configuracion_valor");
            contadorCreaciones = (Integer) application.getAttribute("configuracion_contador");
        %>
        
        <div class="pre">
            <strong>📊 Estado actual:</strong><br>
            Valor = "<%= valorConfiguracion %>"<br>
            Número de accesos = <%= contadorCreaciones %>
        </div>
        
        <form method="get">
            <button type="submit" name="action" value="cambiar" class="btn">✏️ Cambiar valor</button>
            <a href="test-singleton.jsp"><button type="button" class="btn">🔄 Reiniciar demo</button></a>
        </form>
        
        <p><strong>📚 ¿Qué es un Singleton?</strong><br>
        En esta simulación, la "configuración" se guarda en <code>application</code> (ámbito global del servidor). 
        Así, aunque recargues la página o accedas desde otra pestaña, todos ven el <strong>mismo valor</strong>.</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>