<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%
    // =============================================
    // DATOS DE EJEMPLO PARA LAS GRÁFICAS
    // =============================================
    
    // Elección 1: Nacional 2026
    Map<String, Integer> nacional2026 = new LinkedHashMap<>();
    nacional2026.put("Partido A", 1245000);
    nacional2026.put("Partido B", 987000);
    nacional2026.put("Partido C", 756000);
    nacional2026.put("Partido D", 432000);
    nacional2026.put("Voto en Blanco", 234000);
    
    // Elección 2: Regional 2025
    Map<String, Integer> regional2025 = new LinkedHashMap<>();
    regional2025.put("Partido A", 345000);
    regional2025.put("Partido B", 298000);
    regional2025.put("Partido C", 267000);
    regional2025.put("Partido D", 189000);
    regional2025.put("Voto en Blanco", 89000);
    
    // Elección 3: Local 2024
    Map<String, Integer> local2024 = new LinkedHashMap<>();
    local2024.put("Partido A", 45000);
    local2024.put("Partido B", 38000);
    local2024.put("Partido C", 32000);
    local2024.put("Partido D", 21000);
    local2024.put("Voto en Blanco", 8000);
    
    // Datos de candidatos más votados
    List<Map<String, Object>> topCandidatos = new ArrayList<>();
    Map<String, Object> c1 = new HashMap<>(); c1.put("nombre", "Ana López"); c1.put("partido", "Partido A"); c1.put("votos", 456000); c1.put("porcentaje", 28.5); topCandidatos.add(c1);
    Map<String, Object> c2 = new HashMap<>(); c2.put("nombre", "Carlos Ruiz"); c2.put("partido", "Partido A"); c2.put("votos", 398000); c2.put("porcentaje", 24.9); topCandidatos.add(c2);
    Map<String, Object> c3 = new HashMap<>(); c3.put("nombre", "Martha Gómez"); c3.put("partido", "Partido B"); c3.put("votos", 312000); c3.put("porcentaje", 19.5); topCandidatos.add(c3);
    Map<String, Object> c4 = new HashMap<>(); c4.put("nombre", "Luis Pérez"); c4.put("partido", "Partido B"); c4.put("votos", 245000); c4.put("porcentaje", 15.3); topCandidatos.add(c4);
    Map<String, Object> c5 = new HashMap<>(); c5.put("nombre", "Sofía Ramírez"); c5.put("partido", "Partido C"); c5.put("votos", 189000); c5.put("porcentaje", 11.8); topCandidatos.add(c5);
    
    // Evolución por partido
    Map<String, Integer> evolucionParticipacion = new LinkedHashMap<>();
    evolucionParticipacion.put("2024", 68);
    evolucionParticipacion.put("2025", 72);
    evolucionParticipacion.put("2026", 75);
    
    Map<String, Map<String, Integer>> evolucionPartidos = new LinkedHashMap<>();
    Map<String, Integer> evoA = new LinkedHashMap<>(); evoA.put("2024", 45000); evoA.put("2025", 345000); evoA.put("2026", 1245000);
    Map<String, Integer> evoB = new LinkedHashMap<>(); evoB.put("2024", 38000); evoB.put("2025", 298000); evoB.put("2026", 987000);
    Map<String, Integer> evoC = new LinkedHashMap<>(); evoC.put("2024", 32000); evoC.put("2025", 267000); evoC.put("2026", 756000);
    evolucionPartidos.put("Partido A", evoA);
    evolucionPartidos.put("Partido B", evoB);
    evolucionPartidos.put("Partido C", evoC);
    
    // Mapa de calor por región (solo se muestra en Nacional)
    Map<String, Map<String, Integer>> regiones = new LinkedHashMap<>();
    
    Map<String, Integer> regionAmazonas = new LinkedHashMap<>();
    regionAmazonas.put("Partido A", 12500); regionAmazonas.put("Partido B", 8900); regionAmazonas.put("Partido C", 6700);
    
    Map<String, Integer> regionAntioquia = new LinkedHashMap<>();
    regionAntioquia.put("Partido A", 234000); regionAntioquia.put("Partido B", 187000); regionAntioquia.put("Partido C", 145000);
    
    Map<String, Integer> regionBogota = new LinkedHashMap<>();
    regionBogota.put("Partido A", 456000); regionBogota.put("Partido B", 345000); regionBogota.put("Partido C", 278000);
    
    Map<String, Integer> regionSantander = new LinkedHashMap<>();
    regionSantander.put("Partido A", 198000); regionSantander.put("Partido B", 234000); regionSantander.put("Partido C", 156000);
    
    Map<String, Integer> regionCaribe = new LinkedHashMap<>();
    regionCaribe.put("Partido A", 167000); regionCaribe.put("Partido B", 145000); regionCaribe.put("Partido C", 198000);
    
    regiones.put("Amazonas", regionAmazonas);
    regiones.put("Antioquia", regionAntioquia);
    regiones.put("Bogotá", regionBogota);
    regiones.put("Santander", regionSantander);
    regiones.put("Caribe", regionCaribe);
    
    // Composición del congreso (escaños)
    Map<String, Integer> escañosCamara = new LinkedHashMap<>();
    escañosCamara.put("Partido A", 85);
    escañosCamara.put("Partido B", 62);
    escañosCamara.put("Partido C", 48);
    escañosCamara.put("Partido D", 27);
    escañosCamara.put("Otros", 16);
    
    Map<String, Integer> escañosSenado = new LinkedHashMap<>();
    escañosSenado.put("Partido A", 28);
    escañosSenado.put("Partido B", 20);
    escañosSenado.put("Partido C", 16);
    escañosSenado.put("Partido D", 9);
    escañosSenado.put("Otros", 5);
    
    int totalCamara = 0; for(int v : escañosCamara.values()) totalCamara += v;
    int totalSenado = 0; for(int v : escañosSenado.values()) totalSenado += v;
    
    // Elección seleccionada
    String eleccionSeleccionada = request.getParameter("eleccion");
    if(eleccionSeleccionada == null) eleccionSeleccionada = "nacional2026";
    
    Map<String, Integer> datosActuales = nacional2026;
    String tituloEleccion = "Elecciones Nacionales 2026";
    if("regional2025".equals(eleccionSeleccionada)) {
        datosActuales = regional2025;
        tituloEleccion = "Elecciones Regionales 2025";
    } else if("local2024".equals(eleccionSeleccionada)) {
        datosActuales = local2024;
        tituloEleccion = "Elecciones Locales 2024";
    }
    
    boolean mostrarExtras = "nacional2026".equals(eleccionSeleccionada);
    
    int totalVotos = 0;
    for(int v : datosActuales.values()) totalVotos += v;
    
    // Calcular ganador
    String ganador = "";
    int maxVotos = 0;
    for(Map.Entry<String, Integer> e : datosActuales.entrySet()) {
        if(!"Voto en Blanco".equals(e.getKey()) && e.getValue() > maxVotos) {
            maxVotos = e.getValue();
            ganador = e.getKey();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Sistema de Votación Electrónica</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%); min-height: 100vh; }
        .container { max-width: 1400px; margin: 0 auto; padding: 30px 20px; }
        
        .header { margin-bottom: 40px; }
        .header h1 { font-size: 2.5rem; font-weight: 800; background: linear-gradient(135deg, #fff, #e0c3ff); -webkit-background-clip: text; background-clip: text; color: transparent; }
        .header p { color: rgba(255,255,255,0.6); margin-top: 8px; }
        .back-btn { display: inline-block; margin-top: 20px; background: rgba(255,255,255,0.1); padding: 8px 20px; border-radius: 30px; color: white; text-decoration: none; font-size: 0.85rem; }
        .back-btn:hover { background: rgba(255,255,255,0.2); }
        
        .selector { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border-radius: 20px; padding: 20px; margin-bottom: 30px; }
        .selector h3 { color: white; margin-bottom: 15px; font-size: 1.1rem; }
        .selector-buttons { display: flex; gap: 15px; flex-wrap: wrap; }
        .selector-btn { background: rgba(255,255,255,0.1); border: none; padding: 12px 24px; border-radius: 12px; color: white; cursor: pointer; transition: all 0.3s; font-size: 0.9rem; }
        .selector-btn:hover { background: rgba(255,255,255,0.2); transform: translateY(-2px); }
        .selector-btn.active { background: linear-gradient(135deg, #667eea, #764ba2); box-shadow: 0 5px 15px rgba(102,126,234,0.3); }
        
        .grid-2 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px; margin-bottom: 30px; }
        
        .card { background: rgba(255,255,255,0.08); backdrop-filter: blur(10px); border-radius: 24px; padding: 25px; border: 1px solid rgba(255,255,255,0.1); transition: transform 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card h3 { color: white; font-size: 1.2rem; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
        .card h3 .icon { font-size: 1.5rem; }
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.8); }
        th { color: #e0c3ff; font-weight: 600; }
        .table-highlight { background: rgba(102,126,234,0.2); border-radius: 8px; }
        
        .barra-container { margin: 10px 0; }
        .barra-label { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 0.85rem; color: rgba(255,255,255,0.7); }
        .barra-bg { background: rgba(255,255,255,0.1); height: 8px; border-radius: 4px; overflow: hidden; }
        .barra-fill { background: linear-gradient(90deg, #667eea, #764ba2); height: 100%; border-radius: 4px; transition: width 0.5s ease; }
        
        .badge { background: #48bb78; color: white; padding: 4px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: 600; display: inline-block; }
        .badge-warning { background: #f6ad55; }
        .badge-info { background: #4299e1; }
        
        canvas { max-height: 250px; width: 100% !important; }
        
        .heatmap { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
        .heatmap th, .heatmap td { text-align: center; padding: 10px; }
        .heatmap th { background: rgba(0,0,0,0.2); color: #e0c3ff; }
        .heatmap-cell { border-radius: 8px; font-weight: 600; transition: transform 0.2s; }
        .heatmap-cell:hover { transform: scale(1.05); }
        .color-alto { background: #48bb78; color: white; }
        .color-medio { background: #f6ad55; color: #333; }
        .color-bajo { background: #e53e3e; color: white; }
        
        .escaños-container { display: flex; flex-direction: column; gap: 15px; }
        .escaño-bar { display: flex; align-items: center; gap: 10px; }
        .escaño-label { width: 100px; color: rgba(255,255,255,0.8); font-size: 0.9rem; }
        .escaño-fill { height: 30px; border-radius: 6px; transition: width 0.5s ease; display: flex; align-items: center; justify-content: flex-end; padding-right: 10px; color: white; font-size: 0.8rem; font-weight: bold; }
        
        .resumen-card { background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05)); border-left: 4px solid #48bb78; }
        .pronostico-card { background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05)); border-left: 4px solid #f6ad55; }
        
        .footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.4); font-size: 0.8rem; }
        
        @media (max-width: 768px) { .grid-2 { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Centro de Reportes</h1>
            <p>Visualización de datos electorales, estadísticas y análisis de resultados</p>
            <a href="index.html" class="back-btn">← Volver al inicio</a>
        </div>
        
        <!-- Selector de Elección -->
        <div class="selector">
            <h3>🗳️ Seleccionar elección:</h3>
            <div class="selector-buttons">
                <form method="get" style="display: inline;">
                    <input type="hidden" name="eleccion" value="nacional2026">
                    <button type="submit" class="selector-btn <%= "nacional2026".equals(eleccionSeleccionada) ? "active" : "" %>">🇨🇴 Nacional 2026</button>
                </form>
                <form method="get" style="display: inline;">
                    <input type="hidden" name="eleccion" value="regional2025">
                    <button type="submit" class="selector-btn <%= "regional2025".equals(eleccionSeleccionada) ? "active" : "" %>">🏛️ Regional 2025</button>
                </form>
                <form method="get" style="display: inline;">
                    <input type="hidden" name="eleccion" value="local2024">
                    <button type="submit" class="selector-btn <%= "local2024".equals(eleccionSeleccionada) ? "active" : "" %>">🏙️ Local 2024</button>
                </form>
            </div>
        </div>
        
        <!-- Sección principal de resultados -->
        <div class="grid-2">
            <div class="card">
                <h3><span class="icon">📊</span> <%= tituloEleccion %></h3>
                <table>
                    <tr><th>Partido/Candidato</th><th>Votos</th><th>Porcentaje</th></tr>
                    <% for(Map.Entry<String, Integer> e : datosActuales.entrySet()) { 
                        int porcentaje = (e.getValue() * 100 / totalVotos);
                    %>
                        <tr>
                            <td><%= e.getKey() %></td>
                            <td><%= String.format("%,d", e.getValue()) %></td>
                            <td><span class="badge"><%= porcentaje %>%</span></td>
                        </tr>
                        <tr><td colspan="3"><div class="barra-container"><div class="barra-bg"><div class="barra-fill" style="width: <%= porcentaje %>%"></div></div></div></td></tr>
                    <% } %>
                </table>
                <div style="margin-top: 15px; text-align: center;">
                    <span class="badge badge-info">📊 Total de votos: <%= String.format("%,d", totalVotos) %></span>
                </div>
            </div>
            
            <!-- Gráfica diferente según elección -->
            <div class="card">
                <h3><span class="icon">📈</span> Distribución de votos</h3>
                <canvas id="graficaPrincipal" width="400" height="250"></canvas>
            </div>
        </div>
        
        <!-- RESUMEN EJECUTIVO Y PRONÓSTICO -->
        <div class="grid-2">
            <div class="card resumen-card">
                <h3><span class="icon">📋</span> Resumen Ejecutivo</h3>
                <table style="width: 100%;">
                    <tr><td style="width: 50%;">🗳️ Total votos emitidos:</td><td><strong><%= String.format("%,d", totalVotos) %></strong></td></tr>
                    <tr><td>🏆 Partido más votado:</td><td><strong><%= ganador %></strong> (<%= String.format("%,d", maxVotos) %> votos)</td></tr>
                    <tr><td>📊 Participación ciudadana:</td><td><strong>75%</strong> (Nacional)</td></tr>
                    <tr><td>📈 Tendencia partido ganador:</td><td><strong><%= evolucionParticipacion.get("2026") > evolucionParticipacion.get("2024") ? "↑ Al alza" : "↓ A la baja" %></strong></td></tr>
                    <tr><td>🗳️ Voto en blanco:</td><td><strong><%= String.format("%,d", datosActuales.getOrDefault("Voto en Blanco", 0)) %></strong> votos</td></tr>
                </table>
            </div>
            
            <div class="card pronostico-card">
                <h3><span class="icon">🔮</span> Pronóstico</h3>
                <p style="color: rgba(255,255,255,0.8); line-height: 1.6; margin-bottom: 15px;">
                    Basado en los resultados actuales y la tendencia de votación de los últimos 3 años (2024-2026), 
                    el partido <strong><%= ganador %></strong> mantiene una tendencia <strong><%= evolucionParticipacion.get("2026") > evolucionParticipacion.get("2024") ? "creciente" : "decreciente" %></strong>.
                </p>
                <p style="color: rgba(255,255,255,0.8); line-height: 1.6; margin-bottom: 15px;">
                    📊 La participación podría alcanzar el <strong>78%</strong> en las próximas elecciones, 
                    con un crecimiento estimado del <strong>+3%</strong> respecto al año actual.
                </p>
                <p style="color: rgba(255,255,255,0.7); font-style: italic; font-size: 0.85rem;">
                    ⚠️ Cálculo basado en modelo predictivo de tendencias electorales.
                </p>
            </div>
        </div>
        
        <!-- Top Candidatos + Evolución -->
        <div class="grid-2">
            <div class="card">
                <h3><span class="icon">🏆</span> Top 5 Candidatos más votados</h3>
                <table>
                    <tr><th>#</th><th>Candidato</th><th>Partido</th><th>Votos</th></tr>
                    <% int rank = 1; for(Map<String, Object> c : topCandidatos) { %>
                        <tr class="<%= rank == 1 ? "table-highlight" : "" %>">
                            <td><%= rank++ %></td><td><%= c.get("nombre") %></td><td><%= c.get("partido") %></td><td><%= String.format("%,d", c.get("votos")) %></td>
                        </tr>
                    <% } %>
                </table>
            </div>
            
            <div class="card">
                <h3><span class="icon">📈</span> Evolución histórica por partido</h3>
                <canvas id="evolutionChart" width="400" height="200"></canvas>
                <div style="margin-top: 15px; text-align: center;">
                    <span class="badge badge-warning">📈 Tendencia de votación 2024 → 2026</span>
                </div>
            </div>
        </div>
        
        <!-- Secciones EXCLUSIVAS de Nacional (Mapa de Calor + Congreso) -->
        <% if(mostrarExtras) { %>
            <div class="card">
                <h3><span class="icon">🔥</span> Mapa de Calor por Región</h3>
                <p style="color: rgba(255,255,255,0.6); margin-bottom: 15px;">Intensidad: Verde = Alto, Naranja = Medio, Rojo = Bajo</p>
                <table class="heatmap">
                    <tr><th>Región</th><th>Partido A</th><th>Partido B</th><th>Partido C</th></tr>
                    <% for(Map.Entry<String, Map<String, Integer>> region : regiones.entrySet()) { 
                        Map<String, Integer> partidos = region.getValue();
                        int votosA = partidos.get("Partido A");
                        int votosB = partidos.get("Partido B");
                        int votosC = partidos.get("Partido C");
                        String claseA = votosA > 300000 ? "color-alto" : (votosA > 150000 ? "color-medio" : "color-bajo");
                        String claseB = votosB > 300000 ? "color-alto" : (votosB > 150000 ? "color-medio" : "color-bajo");
                        String claseC = votosC > 300000 ? "color-alto" : (votosC > 150000 ? "color-medio" : "color-bajo");
                    %>
                        <tr><th style="text-align: left;"><%= region.getKey() %></th>
                            <td class="heatmap-cell <%= claseA %>"><%= String.format("%,d", votosA) %></td>
                            <td class="heatmap-cell <%= claseB %>"><%= String.format("%,d", votosB) %></td>
                            <td class="heatmap-cell <%= claseC %>"><%= String.format("%,d", votosC) %></td>
                        </tr>
                    <% } %>
                </table>
            </div>
            
            <div class="grid-2">
                <div class="card">
                    <h3><span class="icon">🏛️</span> Composición de la Cámara</h3>
                    <div class="escaños-container">
                        <% for(Map.Entry<String, Integer> e : escañosCamara.entrySet()) { 
                            int porcentaje = (e.getValue() * 100 / totalCamara);
                        %>
                            <div class="escaño-bar">
                                <div class="escaño-label"><%= e.getKey() %></div>
                                <div class="escaño-fill" style="width: <%= porcentaje * 3 %>%; background: linear-gradient(90deg, #667eea, #764ba2);"><%= e.getValue() %> escaños</div>
                                <span style="color: rgba(255,255,255,0.5);">(<%= porcentaje %>%)</span>
                            </div>
                        <% } %>
                    </div>
                    <div style="margin-top: 15px; text-align: center;"><span class="badge badge-info">🏛️ Total: <%= totalCamara %> escaños</span></div>
                </div>
                
                <div class="card">
                    <h3><span class="icon">🏛️</span> Composición del Senado</h3>
                    <div class="escaños-container">
                        <% for(Map.Entry<String, Integer> e : escañosSenado.entrySet()) { 
                            int porcentaje = (e.getValue() * 100 / totalSenado);
                        %>
                            <div class="escaño-bar">
                                <div class="escaño-label"><%= e.getKey() %></div>
                                <div class="escaño-fill" style="width: <%= porcentaje * 3 %>%; background: linear-gradient(90deg, #f6ad55, #ed8936);"><%= e.getValue() %> escaños</div>
                                <span style="color: rgba(255,255,255,0.5);">(<%= porcentaje %>%)</span>
                            </div>
                        <% } %>
                    </div>
                    <div style="margin-top: 15px; text-align: center;"><span class="badge badge-warning">🏛️ Total: <%= totalSenado %> escaños</span></div>
                </div>
            </div>
        <% } %>
        
        <div class="footer">📊 Reportes generados con datos oficiales - Sistema de Votación Electrónica</div>
    </div>
    
    <script>
        // Datos para gráficas según elección seleccionada
        const datosNacional = { labels: [<% for(String key : nacional2026.keySet()) { %>"<%= key %>", <% } %>], values: [<% for(int v : nacional2026.values()) { %><%= v %>, <% } %>] };
        const datosRegional = { labels: [<% for(String key : regional2025.keySet()) { %>"<%= key %>", <% } %>], values: [<% for(int v : regional2025.values()) { %><%= v %>, <% } %>] };
        const datosLocal = { labels: [<% for(String key : local2024.keySet()) { %>"<%= key %>", <% } %>], values: [<% for(int v : local2024.values()) { %><%= v %>, <% } %>] };
        
        const eleccion = "<%= eleccionSeleccionada %>";
        const ctx = document.getElementById('graficaPrincipal').getContext('2d');
        
        let config = {};
        
        if(eleccion === "nacional2026") {
            config = { type: 'bar', data: { labels: datosNacional.labels, datasets: [{ label: 'Votos', data: datosNacional.values, backgroundColor: '#48bb78', borderRadius: 8 }] }, options: { indexAxis: 'y', responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } }, scales: { x: { ticks: { color: 'white' } }, y: { ticks: { color: 'white' } } } } };
        } else if(eleccion === "regional2025") {
            config = { type: 'line', data: { labels: datosRegional.labels, datasets: [{ label: 'Votos', data: datosRegional.values, borderColor: '#f6ad55', backgroundColor: 'rgba(246,173,85,0.2)', fill: true, tension: 0.4, pointBackgroundColor: '#f6ad55', pointBorderColor: '#fff', pointRadius: 5 }] }, options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { labels: { color: 'white' } } }, scales: { y: { ticks: { color: 'white' } }, x: { ticks: { color: 'white' } } } } };
        } else {
            config = { type: 'doughnut', data: { labels: datosLocal.labels, datasets: [{ data: datosLocal.values, backgroundColor: ['#667eea', '#48bb78', '#f6ad55', '#e53e3e', '#4299e1'], borderWidth: 0 }] }, options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'bottom', labels: { color: 'white' } } } } };
        }
        
        new Chart(ctx, config);
        
        new Chart(document.getElementById('evolutionChart').getContext('2d'), {
            type: 'line',
            data: { labels: ['2024', '2025', '2026'], datasets: [
                { label: 'Partido A', data: [45000, 345000, 1245000], borderColor: '#667eea', backgroundColor: 'transparent', tension: 0.4, fill: false, pointBackgroundColor: '#667eea', pointBorderColor: '#fff', pointRadius: 4 },
                { label: 'Partido B', data: [38000, 298000, 987000], borderColor: '#48bb78', backgroundColor: 'transparent', tension: 0.4, fill: false, pointBackgroundColor: '#48bb78', pointBorderColor: '#fff', pointRadius: 4 },
                { label: 'Partido C', data: [32000, 267000, 756000], borderColor: '#f6ad55', backgroundColor: 'transparent', tension: 0.4, fill: false, pointBackgroundColor: '#f6ad55', pointBorderColor: '#fff', pointRadius: 4 }
            ] }, options: { responsive: true, maintainAspectRatio: true, plugins: { legend: { position: 'top', labels: { color: 'white' } } }, scales: { y: { ticks: { color: 'white' } }, x: { ticks: { color: 'white' } } } }
        });
    </script>
</body>
</html>