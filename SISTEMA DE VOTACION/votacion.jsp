<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("usuario") == null) {
        response.sendRedirect("login.jsp?error=Debes iniciar sesión para votar");
        return;
    }
    
    if(request.getMethod().equals("POST")) {
        String candidato = request.getParameter("candidato");
        session.setAttribute("voto_realizado", true);
        session.setAttribute("candidato_votado", candidato);
        response.sendRedirect("resultados.jsp?success=Voto registrado exitosamente");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Votación | Elecciones Colombia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #4299e1 0%, #667eea 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .voting-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }
        .header-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        .candidatos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }
        .candidato-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 3px solid transparent;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .candidato-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }
        .candidato-card.seleccionado {
            border-color: #48bb78;
            background: #f0fff4;
        }
        .candidato-avatar {
            font-size: 4rem;
            margin-bottom: 15px;
        }
        .candidato-nombre {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
        }
        .candidato-partido {
            color: #666;
            margin: 10px 0;
        }
        .btn-votar {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 30px;
        }
        .btn-votar:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(72, 187, 120, 0.4);
        }
        .btn-votar:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">🗳️ Votación Colombia 2026</a>
            <div class="user-info">
                <span class="user-avatar">
                    <%= session.getAttribute("nombre") != null ? session.getAttribute("nombre").toString().charAt(0) : "U" %>
                </span>
                <span>Bienvenido, <strong><%= session.getAttribute("nombre") %></strong></span>
                <a href="Logout.jsp" class="btn btn-outline-danger btn-sm ms-3">Cerrar Sesión</a>
            </div>
        </div>
    </nav>
    
    <div class="voting-container">
        <div class="header-card animate__animated animate__fadeIn">
            <h1>🗳️ Selecciona tu candidato</h1>
            <p class="text-muted">Tu voto es secreto y seguro. Elige con conciencia.</p>
        </div>
        
        <form id="votoForm" method="post">
            <div class="candidatos-grid">
                <div class="candidato-card" onclick="seleccionar(1, this)">
                    <div class="candidato-avatar">👨‍💼</div>
                    <div class="candidato-nombre">Candidato 1</div>
                    <div class="candidato-partido">Partido A</div>
                    <input type="radio" name="candidato" value="1" id="cand1" style="display:none;">
                </div>
                
                <div class="candidato-card" onclick="seleccionar(2, this)">
                    <div class="candidato-avatar">👩‍💼</div>
                    <div class="candidato-nombre">Candidato 2</div>
                    <div class="candidato-partido">Partido B</div>
                    <input type="radio" name="candidato" value="2" id="cand2" style="display:none;">
                </div>
                
                <div class="candidato-card" onclick="seleccionar(3, this)">
                    <div class="candidato-avatar">👨‍⚖️</div>
                    <div class="candidato-nombre">Candidato 3</div>
                    <div class="candidato-partido">Partido C</div>
                    <input type="radio" name="candidato" value="3" id="cand3" style="display:none;">
                </div>
                
                <div class="candidato-card" onclick="seleccionar(4, this)">
                    <div class="candidato-avatar">🤍</div>
                    <div class="candidato-nombre">Voto en Blanco</div>
                    <div class="candidato-partido">Opción democrática</div>
                    <input type="radio" name="candidato" value="4" id="cand4" style="display:none;">
                </div>
            </div>
            
            <div class="text-center">
                <button type="button" class="btn-votar" id="btnVotar" onclick="confirmarVoto()" disabled>
                    Confirmar mi Voto
                </button>
            </div>
        </form>
    </div>
    
    <script>
        let candidatoSeleccionado = null;
        
        function seleccionar(id, elemento) {
            document.querySelectorAll('.candidato-card').forEach(c => {
                c.classList.remove('seleccionado');
            });
            
            elemento.classList.add('seleccionado');
            document.getElementById('cand' + id).checked = true;
            candidatoSeleccionado = id;
            document.getElementById('btnVotar').disabled = false;
        }
        
        function confirmarVoto() {
            if(confirm('¿Estás completamente seguro de tu voto? Esta acción no se puede deshacer.')) {
                document.getElementById('votoForm').submit();
            }
        }
    </script>
</body>
</html>