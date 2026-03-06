<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión | Votación Colombia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 450px;
            width: 100%;
            overflow: hidden;
            animation: fadeInUp 0.8s;
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .login-header h2 {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .login-body {
            padding: 40px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        .form-group input:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        .alert-error {
            background: #fed7d7;
            color: #c53030;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            text-align: center;
            border-left: 4px solid #c53030;
        }
        .alert-success {
            background: #f0fff4;
            color: #22543d;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            text-align: center;
            border-left: 4px solid #48bb78;
        }
        .register-link {
            text-align: center;
            margin-top: 25px;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .back-home {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #999;
            text-decoration: none;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div style="font-size: 3rem; margin-bottom: 15px;">🔐</div>
                <h2>Bienvenido de vuelta</h2>
                <p>Ingresa tus credenciales para votar</p>
            </div>
            
            <div class="login-body">
                <%
                    String error = request.getParameter("error");
                    String mensaje = request.getParameter("mensaje");
                    
                    if(error != null) {
                %>
                    <div class="alert-error">
                        <strong>⚠️ Error:</strong> <%= error %>
                    </div>
                <%
                    }
                    
                    if(mensaje != null) {
                %>
                    <div class="alert-success">
                        <strong>✅ Éxito:</strong> <%= mensaje %>
                    </div>
                <%
                    }
                    
                    // PROCESAR LOGIN
                    if(request.getMethod().equals("POST")) {
                        String cedula = request.getParameter("cedula");
                        String password = request.getParameter("password");
                        
                        // 1. Verificar admin quemado
                        if("12345".equals(cedula) && "admin123".equals(password)) {
                            session.setAttribute("usuario", cedula);
                            session.setAttribute("nombre", "Administrador");
                            session.setAttribute("rol", "admin");
                            response.sendRedirect("admin/dashboard.jsp");
                            return;
                        }
                        
                        // 2. Verificar en usuarios registrados
                        java.util.List<java.util.Map<String, String>> usuarios = 
                            (java.util.List<java.util.Map<String, String>>) application.getAttribute("usuarios");
                        
                        if(usuarios != null) {
                            for(java.util.Map<String, String> user : usuarios) {
                                if(user.get("cedula").equals(cedula) && user.get("password").equals(password)) {
                                    session.setAttribute("usuario", user.get("cedula"));
                                    session.setAttribute("nombre", user.get("nombre"));
                                    session.setAttribute("rol", user.get("rol"));
                                    session.setAttribute("email", user.get("email"));
                                    response.sendRedirect("votacion.jsp");
                                    return;
                                }
                            }
                        }
                        
                        // 3. Si no coincide con nada
                        response.sendRedirect("login.jsp?error=Cédula o contraseña incorrectos");
                        return;
                    }
                %>
                
                <form method="post">
                    <div class="form-group">
                        <label>📇 Número de Cédula</label>
                        <input type="text" name="cedula" placeholder="Ej: 12345" required>
                    </div>
                    
                    <div class="form-group">
                        <label>🔑 Contraseña</label>
                        <input type="password" name="password" placeholder="••••••••" required>
                    </div>
                    
                    <button type="submit" class="btn-login">
                        Iniciar Sesión
                    </button>
                </form>
                
                <div class="register-link">
                    ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
                </div>
                
                <a href="index.html" class="back-home">← Volver al inicio</a>
            </div>
        </div>
    </div>
</body>
</html>