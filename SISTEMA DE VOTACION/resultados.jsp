<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Map<String, String>> votos = (List<Map<String, String>>) application.getAttribute("votos");
    Map<String, Integer> conteo = new HashMap<>();
    conteo.put("Candidato A", 0);
    conteo.put("Candidato B", 0);
    conteo.put("Candidato C", 0);
    conteo.put("Voto en Blanco", 0);
    
    if(votos != null) {
        for(Map<String, String> v : votos) {
            String cand = v.get("candidato");
            int actual = conteo.get(cand) != null ? conteo.get(cand) : 0;
            conteo.put(cand, actual + 1);
        }
    }
    
    // Calcular total de votos (forma compatible con Java 7)
    int total = 0;
    for(int valor : conteo.values()) {
        total += valor;
    }
    
    // Determinar ganador
    String ganador = "Sin votos";
    int maxVotos = 0;
    for(Map.Entry<String, Integer> e : conteo.entrySet()) {
        if(e.getValue() > maxVotos) {
            maxVotos = e.getValue();
            ganador = e.getKey();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados Electorales</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        h1 { font-size: 28px; color: #333; margin-bottom: 10px; text-align: center; }
        .ganador { background: linear-gradient(135deg, #48bb78, #38a169); color: white; padding: 12px 20px; border-radius: 40px; display: inline-block; margin-bottom: 30px; font-weight: 600; }
        .resultado { margin: 20px 0; }
        .label { display: flex; justify-content: space-between; margin-bottom: 5px; font-weight: 500; }
        .barra { background: #edf2f7; height: 32px; border-radius: 16px; overflow: hidden; }
        .fill { background: linear-gradient(90deg, #667eea, #764ba2); height: 100%; color: white; line-height: 32px; padding-left: 15px; font-size: 14px; font-weight: 500; }
        .alert-success { background: #f0fff4; color: #22543d; padding: 12px; border-radius: 12px; margin-bottom: 20px; text-align: center; }
        .alert-error { background: #fed7d7; color: #c53030; padding: 12px; border-radius: 12px; margin-bottom: 20px; text-align: center; }
        .btn { display: inline-block; background: #667eea; color: white; padding: 10px 24px; border-radius: 30px; text-decoration: none; margin-top: 30px; }
        .center { text-align: center; }
    </style>
</head>
<body>
    <div class="card">
        <h1>📊 Resultados Electorales</h1>
        <div class="center"><span class="ganador">🏆 Ganador: <%= ganador %></span></div>
        
        <% if(request.getParameter("success") != null) { %>
            <div class="alert-success">✅ <%= request.getParameter("success") %></div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
            <div class="alert-error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>
        
        <% for(Map.Entry<String, Integer> e : conteo.entrySet()) { 
            int porcentaje = total > 0 ? (e.getValue() * 100 / total) : 0;
        %>
            <div class="resultado">
                <div class="label"><span><%= e.getKey() %></span><span><%= e.getValue() %> votos (<%= porcentaje %>%)</span></div>
                <div class="barra"><div class="fill" style="width: <%= porcentaje %>%"><%= porcentaje %>%</div></div>
            </div>
        <% } %>
        
        <div class="center"><p>Total de votos: <%= total %></p></div>
        <div class="center"><a href="index.html" class="btn">← Volver al inicio</a></div>
    </div>
</body>
</html>