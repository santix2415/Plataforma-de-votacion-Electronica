<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("usuario") == null) {
        response.sendRedirect("login.jsp?error=Debes iniciar sesión para votar");
        return;
    }
    
    String cedula = (String) session.getAttribute("usuario");
    
    // Verificar si ya votó
    List<Map<String, String>> votos = (List<Map<String, String>>) session.getServletContext().getAttribute("votos");
    if(votos == null) votos = new ArrayList<>();
    
    boolean yaVoto = false;
    for(Map<String, String> v : votos) {
        if(v.get("cedula").equals(cedula)) {
            yaVoto = true;
            break;
        }
    }
    
    if(request.getMethod().equals("POST")) {
        if(yaVoto) {
            response.sendRedirect("resultados.jsp?error=Ya has votado anteriormente");
            return;
        }
        
        String candidato = request.getParameter("candidato");
        Map<String, String> voto = new HashMap<>();
        voto.put("cedula", cedula);
        voto.put("candidato", candidato);
        votos.add(voto);
        session.getServletContext().setAttribute("votos", votos);
        response.sendRedirect("resultados.jsp?success=Voto registrado exitosamente");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Votación</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #4299e1 0%, #667eea 100%); min-height: 100vh; padding: 40px 20px; }
        .navbar { background: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-radius: 12px; max-width: 1200px; margin: 0 auto 30px; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .user-avatar { width: 40px; height: 40px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; }
        .logout-btn { background: #e53e3e; color: white; padding: 8px 20px; border-radius: 8px; text-decoration: none; font-size: 14px; }
        .container { max-width: 1000px; margin: 0 auto; }
        .card { background: white; border-radius: 24px; padding: 30px; text-align: center; margin-bottom: 30px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin: 30px 0; }
        .candidato { background: white; border-radius: 16px; padding: 25px; text-align: center; cursor: pointer; border: 3px solid #e0e0e0; transition: all 0.3s; }
        .candidato:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        .candidato.seleccionado { border-color: #48bb78; background: #f0fff4; }
        .candidato-avatar { font-size: 48px; margin-bottom: 10px; }
        .candidato-nombre { font-size: 20px; font-weight: 600; margin-bottom: 5px; }
        .candidato-partido { color: #666; font-size: 14px; }
        .btn-votar { background: linear-gradient(135deg, #48bb78, #38a169); color: white; border: none; padding: 14px 40px; border-radius: 40px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; margin-top: 20px; }
        .btn-votar:disabled { background: #ccc; cursor: not-allowed; }
        .btn-votar:hover:not(:disabled) { transform: scale(1.02); }
        <% if(yaVoto) { %>
        .votado { background: #fef5e7; border-left: 4px solid #ed8936; padding: 15px; border-radius: 12px; text-align: center; color: #ed8936; }
        <% } %>
    </style>
</head>
<body>
    <div class="navbar">
        <span style="font-weight: 600;">🗳️ Votación Colombia 2026</span>
        <div class="user-info">
            <div class="user-avatar"><%= session.getAttribute("nombre") != null ? session.getAttribute("nombre").toString().charAt(0) : "U" %></div>
            <span>Bienvenido, <strong><%= session.getAttribute("nombre") %></strong></span>
            <a href="Logout.jsp" class="logout-btn">Cerrar sesión</a>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <h1>🗳️ Selecciona tu candidato</h1>
            <p>Tu voto es secreto y seguro</p>
        </div>
        
        <% if(yaVoto) { %>
            <div class="votado">⚠️ Ya has ejercido tu derecho al voto. No puedes votar nuevamente.</div>
        <% } else { %>
            <form method="post" id="votoForm">
                <div class="grid">
                    <div class="candidato" onclick="seleccionar(1, this)">
                        <div class="candidato-avatar">👨‍💼</div>
                        <div class="candidato-nombre">Candidato A</div>
                        <div class="candidato-partido">Partido A</div>
                        <input type="radio" name="candidato" value="Candidato A" id="cand1" style="display:none;">
                    </div>
                    <div class="candidato" onclick="seleccionar(2, this)">
                        <div class="candidato-avatar">👩‍💼</div>
                        <div class="candidato-nombre">Candidato B</div>
                        <div class="candidato-partido">Partido B</div>
                        <input type="radio" name="candidato" value="Candidato B" id="cand2" style="display:none;">
                    </div>
                    <div class="candidato" onclick="seleccionar(3, this)">
                        <div class="candidato-avatar">👨‍⚖️</div>
                        <div class="candidato-nombre">Candidato C</div>
                        <div class="candidato-partido">Partido C</div>
                        <input type="radio" name="candidato" value="Candidato C" id="cand3" style="display:none;">
                    </div>
                    <div class="candidato" onclick="seleccionar(4, this)">
                        <div class="candidato-avatar">🤍</div>
                        <div class="candidato-nombre">Voto en Blanco</div>
                        <div class="candidato-partido">Opción democrática</div>
                        <input type="radio" name="candidato" value="Voto en Blanco" id="cand4" style="display:none;">
                    </div>
                </div>
                <div style="text-align: center;">
                    <button type="button" class="btn-votar" id="btnVotar" onclick="confirmarVoto()" disabled>Confirmar mi voto</button>
                </div>
            </form>
        <% } %>
    </div>
    
    <script>
        let seleccionado = false;
        function seleccionar(id, el) {
            document.querySelectorAll('.candidato').forEach(c => c.classList.remove('seleccionado'));
            el.classList.add('seleccionado');
            document.getElementById('cand' + id).checked = true;
            document.getElementById('btnVotar').disabled = false;
        }
        function confirmarVoto() {
            if(confirm('¿Estás seguro? Esta acción no se puede deshacer')) {
                document.getElementById('votoForm').submit();
            }
        }
    </script>
</body>
</html>