<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro | Votación Colombia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .register-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 500px;
            width: 100%;
            overflow: hidden;
            animation: fadeInUp 0.8s;
        }
        .register-header {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .register-header h2 {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .register-body {
            padding: 40px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
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
            border-color: #48bb78;
            outline: none;
        }
        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(72, 187, 120, 0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 25px;
        }
        .login-link a {
            color: #48bb78;
            text-decoration: none;
            font-weight: 600;
        }
        .back-home {
            display: block;
            text-align: center;
            margin-top: 15px;
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
    <div class="register-container">
        <div class="register-card">
            <div class="register-header">
                <div style="font-size: 3rem; margin-bottom: 15px;">📝</div>
                <h2>Registro de Votante</h2>
                <p>Completa tus datos para votar</p>
            </div>
            
            <div class="register-body">
                <%
                    // PROCESAR REGISTRO
                    if(request.getMethod().equals("POST")) {
                        String cedula = request.getParameter("cedula");
                        String nombre = request.getParameter("nombre");
                        String email = request.getParameter("email");
                        String password = request.getParameter("password");
                        
                        // Crear lista de usuarios en el contexto de la aplicación
                        java.util.List<java.util.Map<String, String>> usuarios = 
                            (java.util.List<java.util.Map<String, String>>) application.getAttribute("usuarios");
                        
                        if(usuarios == null) {
                            usuarios = new java.util.ArrayList<>();
                        }
                        
                        // Verificar si la cédula ya existe
                        boolean existe = false;
                        for(java.util.Map<String, String> u : usuarios) {
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
                        java.util.Map<String, String> nuevoUsuario = new java.util.HashMap<>();
                        nuevoUsuario.put("cedula", cedula);
                        nuevoUsuario.put("nombre", nombre);
                        nuevoUsuario.put("email", email);
                        nuevoUsuario.put("password", password);
                        nuevoUsuario.put("rol", "votante");
                        
                        usuarios.add(nuevoUsuario);
                        application.setAttribute("usuarios", usuarios);
                        
                        response.sendRedirect("login.jsp?mensaje=Registro exitoso. Ya puedes iniciar sesión");
                        return;
                    }
                %>
                
                <% if(request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>
                
                <form method="post" onsubmit="return validarFormulario()">
                    <div class="form-group">
                        <label>📇 Cédula</label>
                        <input type="text" name="cedula" id="cedula" placeholder="Número de identificación" required>
                    </div>
                    
                    <div class="form-group">
                        <label>👤 Nombre Completo</label>
                        <input type="text" name="nombre" id="nombre" placeholder="Como aparece en tu cédula" required>
                    </div>
                    
                    <div class="form-group">
                        <label>📧 Correo Electrónico</label>
                        <input type="email" name="email" id="email" placeholder="tucorreo@ejemplo.com" required>
                    </div>
                    
                    <div class="form-group">
                        <label>🔑 Contraseña</label>
                        <input type="password" name="password" id="password" placeholder="Mínimo 6 caracteres" required>
                    </div>
                    
                    <div class="form-group">
                        <label>🔒 Confirmar Contraseña</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Repite tu contraseña" required>
                    </div>
                    
                    <button type="submit" class="btn-register">
                        Registrarse como Votante
                    </button>
                </form>
                
                <div class="login-link">
                    ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
                </div>
                
                <a href="index.html" class="back-home">← Volver al inicio</a>
            </div>
        </div>
    </div>
    
    <script>
        function validarFormulario() {
            let password = document.getElementById("password").value;
            let confirmPassword = document.getElementById("confirmPassword").value;
            
            if(password.length < 6) {
                alert("La contraseña debe tener al menos 6 caracteres");
                return false;
            }
            
            if(password != confirmPassword) {
                alert("Las contraseñas no coinciden");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>