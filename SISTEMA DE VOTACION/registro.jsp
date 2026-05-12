<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Procesar registro
    if(request.getMethod().equals("POST")) {
        String cedula = request.getParameter("cedula");
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Obtener lista de usuarios del contexto de la aplicación
        List<Map<String, String>> usuarios = (List<Map<String, String>>) application.getAttribute("usuarios");
        
        if(usuarios == null) {
            usuarios = new ArrayList<>();
        }
        
        // Verificar si la cédula ya existe
        boolean existe = false;
        for(Map<String, String> u : usuarios) {
            if(u.get("cedula").equals(cedula)) {
                existe = true;
                break;
            }
        }
        
        if(existe) {
            response.sendRedirect("registro.jsp?error=La cédula ya está registrada");
            return;
        }
        
        // Crear nuevo usuario
        Map<String, String> nuevo = new HashMap<>();
        nuevo.put("cedula", cedula);
        nuevo.put("nombre", nombre);
        nuevo.put("email", email);
        nuevo.put("password", password);
        nuevo.put("rol", "votante");
        nuevo.put("haVotado", "false");
        
        usuarios.add(nuevo);
        application.setAttribute("usuarios", usuarios);
        
        response.sendRedirect("login.jsp?mensaje=Registro exitoso. Ya puedes iniciar sesión");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Votante</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }
        .card { background: white; border-radius: 24px; max-width: 500px; width: 100%; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .card h2 { font-size: 28px; color: #333; margin-bottom: 8px; }
        .card p.sub { color: #666; margin-bottom: 30px; font-size: 14px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 500; color: #333; margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 16px; border: 2px solid #e0e0e0; border-radius: 12px; font-size: 14px; transition: all 0.3s; }
        .form-group input:focus { outline: none; border-color: #48bb78; box-shadow: 0 0 0 3px rgba(72,187,120,0.1); }
        .btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; }
        .btn:hover { transform: translateY(-2px); }
        .error { background: #fed7d7; color: #c53030; padding: 12px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; }
        .link { text-align: center; margin-top: 20px; font-size: 14px; }
        .link a { color: #48bb78; text-decoration: none; font-weight: 500; }
        .back { text-align: center; margin-top: 15px; }
        .back a { color: #999; text-decoration: none; font-size: 13px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>📝 Crear cuenta</h2>
        <p class="sub">Regístrate como votante</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <label>📇 Cédula</label>
                <input type="text" name="cedula" placeholder="Número de identificación" required>
            </div>
            <div class="form-group">
                <label>👤 Nombre completo</label>
                <input type="text" name="nombre" placeholder="Tu nombre completo" required>
            </div>
            <div class="form-group">
                <label>📧 Correo electrónico</label>
                <input type="email" name="email" placeholder="correo@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label>🔑 Contraseña</label>
                <input type="password" name="password" id="password" placeholder="Mínimo 6 caracteres" required>
            </div>
            <div class="form-group">
                <label>🔒 Confirmar contraseña</label>
                <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Repite tu contraseña" required>
            </div>
            <button type="submit" class="btn">Registrarse</button>
        </form>
        
        <div class="link">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a></div>
        <div class="back"><a href="index.html">← Volver al inicio</a></div>
    </div>
    
    <script>
        document.querySelector("form").addEventListener("submit", function(e) {
            let pass = document.getElementById("password").value;
            let conf = document.getElementById("confirmPassword").value;
            if(pass.length < 6) {
                alert("La contraseña debe tener al menos 6 caracteres");
                e.preventDefault();
            } else if(pass !== conf) {
                alert("Las contraseñas no coinciden");
                e.preventDefault();
            }
        });
    </script>
</body>
</html>