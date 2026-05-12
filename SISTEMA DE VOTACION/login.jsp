<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(request.getMethod().equals("POST")) {
        String cedula = request.getParameter("cedula");
        String password = request.getParameter("password");
        
        // Usuario admin fijo
        if("12345".equals(cedula) && "admin123".equals(password)) {
            session.setAttribute("usuario", cedula);
            session.setAttribute("nombre", "Administrador");
            session.setAttribute("rol", "admin");
            response.sendRedirect("votacion.jsp");
            return;
        }
        
        // Buscar en usuarios registrados
        List<Map<String, String>> usuarios = (List<Map<String, String>>) application.getAttribute("usuarios");
        if(usuarios != null) {
            for(Map<String, String> u : usuarios) {
                if(u.get("cedula").equals(cedula) && u.get("password").equals(password)) {
                    session.setAttribute("usuario", u.get("cedula"));
                    session.setAttribute("nombre", u.get("nombre"));
                    session.setAttribute("rol", u.get("rol"));
                    response.sendRedirect("votacion.jsp");
                    return;
                }
            }
        }
        response.sendRedirect("login.jsp?error=Cédula o contraseña incorrectos");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }
        .card { background: white; border-radius: 24px; max-width: 450px; width: 100%; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .card h2 { font-size: 28px; color: #333; margin-bottom: 8px; }
        .card p.sub { color: #666; margin-bottom: 30px; font-size: 14px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 500; color: #333; margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 16px; border: 2px solid #e0e0e0; border-radius: 12px; font-size: 14px; transition: all 0.3s; }
        .form-group input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; }
        .btn:hover { transform: translateY(-2px); }
        .error { background: #fed7d7; color: #c53030; padding: 12px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; }
        .success { background: #f0fff4; color: #22543d; padding: 12px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; }
        .link { text-align: center; margin-top: 20px; font-size: 14px; }
        .link a { color: #667eea; text-decoration: none; font-weight: 500; }
        .back { text-align: center; margin-top: 15px; }
        .back a { color: #999; text-decoration: none; font-size: 13px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>🔐 Bienvenido</h2>
        <p class="sub">Ingresa tus credenciales</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>
        <% if(request.getParameter("mensaje") != null) { %>
            <div class="success">✅ <%= request.getParameter("mensaje") %></div>
        <% } %>
        
        <form method="post">
            <div class="form-group">
                <label>📇 Cédula</label>
                <input type="text" name="cedula" placeholder="Ej: 12345" required>
            </div>
            <div class="form-group">
                <label>🔑 Contraseña</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn">Iniciar sesión</button>
        </form>
        
        <div class="link">¿No tienes cuenta? <a href="registro.jsp">Regístrate</a></div>
        <div class="back"><a href="index.html">← Volver al inicio</a></div>
    </div>
</body>
</html>