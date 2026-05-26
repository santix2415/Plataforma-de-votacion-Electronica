<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ ESTRATEGIA
    // =============================================
    interface EstrategiaGanador {
        String determinarGanador(java.util.Map<String, Integer> resultados);
        String getNombre();
    }
    
    // =============================================
    // ESTRATEGIA 1: Mayoría Simple
    // =============================================
    class MayoriaSimpleStrategy implements EstrategiaGanador {
        public String determinarGanador(java.util.Map<String, Integer> resultados) {
            String ganador = "Empate";
            int maxVotos = -1;
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                if(e.getValue() > maxVotos) {
                    maxVotos = e.getValue();
                    ganador = e.getKey();
                } else if(e.getValue() == maxVotos) {
                    ganador = "Empate entre " + ganador + " y " + e.getKey();
                }
            }
            return ganador + " con " + maxVotos + " votos";
        }
        public String getNombre() { return "Mayoría Simple (gana el que tiene más votos)"; }
    }
    
    // =============================================
    // ESTRATEGIA 2: Mayoría Absoluta (más del 50%)
    // =============================================
    class MayoriaAbsolutaStrategy implements EstrategiaGanador {
        public String determinarGanador(java.util.Map<String, Integer> resultados) {
            int total = 0;
            for(int v : resultados.values()) total += v;
            
            int mitad = total / 2;
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                if(e.getValue() > mitad) {
                    return e.getKey() + " con " + e.getValue() + " votos (" + (e.getValue() * 100 / total) + "%)";
                }
            }
            return "Segunda vuelta necesaria (nadie superó el 50%)";
        }
        public String getNombre() { return "Mayoría Absoluta (más del 50% de los votos)"; }
    }
    
    // =============================================
    // ESTRATEGIA 3: Votos Ponderados por Región
    // =============================================
    class VotosPonderadosStrategy implements EstrategiaGanador {
        private java.util.Map<String, Double> ponderaciones;
        
        public VotosPonderadosStrategy() {
            ponderaciones = new java.util.HashMap<>();
            ponderaciones.put("Urbana", 1.0);
            ponderaciones.put("Rural", 1.5);
        }
        
        public String determinarGanador(java.util.Map<String, Integer> resultados) {
            // Simular ponderación: los votos rurales valen más
            int votosUrbanos = resultados.getOrDefault("Candidato A", 0);
            int votosRurales = resultados.getOrDefault("Candidato B", 0);
            
            double totalA = votosUrbanos * ponderaciones.get("Urbana");
            double totalB = votosRurales * ponderaciones.get("Rural");
            
            if(totalA > totalB) return "Candidato A gana con " + totalA + " puntos ponderados";
            if(totalB > totalA) return "Candidato B gana con " + totalB + " puntos ponderados";
            return "Empate ponderado";
        }
        public String getNombre() { return "Votos Ponderados (votos rurales valen 1.5 veces más)"; }
    }
    
    // =============================================
    // CONTEXTO (usa la estrategia)
    // =============================================
    class CalculadorGanador {
        private EstrategiaGanador estrategia;
        
        public void setEstrategia(EstrategiaGanador e) {
            this.estrategia = e;
        }
        
        public String calcularGanador(java.util.Map<String, Integer> resultados) {
            if(estrategia == null) return "No hay estrategia seleccionada";
            return estrategia.determinarGanador(resultados);
        }
        
        public String getEstrategiaActual() {
            return estrategia != null ? estrategia.getNombre() : "Ninguna";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Strategy</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; }
        .resultado { background: #e8f8f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-weight: bold; text-align: center; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🧠 Demostración del Patrón Strategy</h1>
        <p>Define una familia de algoritmos intercambiables y permite cambiar la estrategia en tiempo de ejecución.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Cálculo del ganador electoral</h3>
        
        <%
            // Datos de ejemplo (resultados por candidato)
            java.util.Map<String, Integer> resultados = new java.util.LinkedHashMap<>();
            resultados.put("Candidato A", 450);
            resultados.put("Candidato B", 300);
            resultados.put("Candidato C", 200);
            resultados.put("Voto en Blanco", 50);
            
            String estrategiaSeleccionada = request.getParameter("estrategia");
            CalculadorGanador calculador = new CalculadorGanador();
            String resultado = "";
            
            if("simple".equals(estrategiaSeleccionada)) {
                calculador.setEstrategia(new MayoriaSimpleStrategy());
                resultado = calculador.calcularGanador(resultados);
            } else if("absoluta".equals(estrategiaSeleccionada)) {
                calculador.setEstrategia(new MayoriaAbsolutaStrategy());
                resultado = calculador.calcularGanador(resultados);
            } else if("ponderada".equals(estrategiaSeleccionada)) {
                calculador.setEstrategia(new VotosPonderadosStrategy());
                resultado = calculador.calcularGanador(resultados);
            }
        %>
        
        <table>
            <tr><th>Candidato</th><th>Votos</th></tr>
            <% for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) { %>
                <tr><td><%= e.getKey() %></td><td><%= e.getValue() %></td></tr>
            <% } %>
        </table>
        
        <form method="get">
            <button type="submit" name="estrategia" value="simple" class="btn">📊 Mayoría Simple</button>
            <button type="submit" name="estrategia" value="absoluta" class="btn">🎯 Mayoría Absoluta (>50%)</button>
            <button type="submit" name="estrategia" value="ponderada" class="btn">⚖️ Votos Ponderados</button>
        </form>
        
        <% if(resultado != null && !resultado.isEmpty()) { %>
            <div class="resultado">
                🏆 <strong>Resultado usando la estrategia actual:</strong><br>
                <%= resultado %>
            </div>
            <div class="pre">
                <strong>📚 Estrategia actual:</strong> <%= calculador.getEstrategiaActual() %>
            </div>
        <% } %>
        
        <p><strong>🔍 ¿Qué es el patrón Strategy?</strong><br>
        Cambiar la estrategia de cálculo (botones arriba) cambia el resultado final, sin modificar el código que procesa los datos. Cada estrategia está encapsulada en su propia clase.</p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>