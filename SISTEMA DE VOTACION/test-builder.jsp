<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Builder</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 600px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .input-group { margin-bottom: 15px; }
        input { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 12px; font-size: 14px; }
        .btn { background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 12px 24px; border-radius: 8px; border: none; cursor: pointer; width: 100%; font-size: 16px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .simulacion { background: #e8f4f8; padding: 15px; border-radius: 12px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🏗️ Demostración del Patrón Builder</h1>
        <p>Construye objetos complejos paso a paso, separando la construcción de su representación final.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Construcción de un Voto</h3>
        
        <div class="simulacion">
            <p><strong>🔧 ¿Cómo funciona el patrón Builder?</strong><br>
            Imagina que tienes que construir un objeto <strong>Voto</strong> con varios datos. En lugar de usar un constructor complicado, el Builder te permite <strong>encadenar métodos</strong> paso a paso:</p>
            <pre style="background:#fff;padding:10px;border-radius:8px;font-size:12px;">
Voto voto = new Voto.Builder()
    .conCedula("12345")
    .conCandidato("Candidato A")
    .generarHash()
    .build();</pre>
        </div>
        
        <%
            String cedula = request.getParameter("cedula");
            String candidato = request.getParameter("candidato");
            boolean construido = false;
            String hashGenerado = "";
            
            if(cedula != null && candidato != null && cedula.length() > 0 && candidato.length() > 0) {
                // Simular generación de hash sin usar System
                java.util.Date fecha = new java.util.Date();
                String timestamp = String.valueOf(fecha.getTime());
                hashGenerado = "HASH-" + timestamp.substring(timestamp.length() - 8);
                construido = true;
            }
        %>
        
        <form method="get">
            <div class="input-group">
                <input type="text" name="cedula" placeholder="📇 Paso 1: Ingresa tu cédula" required>
            </div>
            <div class="input-group">
                <input type="text" name="candidato" placeholder="🗳️ Paso 2: Ingresa el candidato" required>
            </div>
            <button type="submit" class="btn">🏗️ Paso 3: Construir Voto (Builder)</button>
        </form>
        
        <% if(construido) { %>
            <div class="pre">
                <strong>✅ Voto construido con Builder</strong><br><br>
                📇 Cédula: <strong><%= cedula %></strong><br>
                🗳️ Candidato: <strong><%= candidato %></strong><br>
                🔒 Hash: <code><%= hashGenerado %></code><br><br>
                <em>💡 Cada vez que construyes un voto, se genera un hash único automáticamente.</em>
            </div>
        <% } %>
        
        <p><strong>📚 Ventajas del Builder:</strong><br>
        ✅ Código más legible (sabes qué valor asignas en cada paso)<br>
        ✅ Permite valores opcionales (no necesitas pasar null)<br>
        ✅ Validación centralizada en el método build()<br>
        ✅ Objetos inmutables una vez construidos</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>