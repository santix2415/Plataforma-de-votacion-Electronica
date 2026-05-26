<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ DE EXPRESIÓN
    // =============================================
    interface Expresion {
        String interpretar(java.util.Map<String, Integer> resultados);
    }
    
    // =============================================
    // EXPRESIONES TERMINALES (Hojas)
    // =============================================
    
    // Expresión que devuelve el total de votos
    class TotalVotosExpresion implements Expresion {
        public String interpretar(java.util.Map<String, Integer> resultados) {
            int total = 0;
            for(int v : resultados.values()) total += v;
            return "Total de votos: " + total;
        }
    }
    
    // Expresión que devuelve el ganador (mayoría simple)
    class GanadorExpresion implements Expresion {
        public String interpretar(java.util.Map<String, Integer> resultados) {
            String ganador = "Empate";
            int maxVotos = -1;
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                if(e.getValue() > maxVotos) {
                    maxVotos = e.getValue();
                    ganador = e.getKey();
                } else if(e.getValue() == maxVotos && maxVotos != -1) {
                    ganador = "Empate entre varios candidatos";
                }
            }
            return "Ganador: " + ganador + " (" + maxVotos + " votos)";
        }
    }
    
    // Expresión que devuelve el candidato con más de X votos
    class MayorQueExpresion implements Expresion {
        private int limite;
        
        public MayorQueExpresion(int limite) {
            this.limite = limite;
        }
        
        public String interpretar(java.util.Map<String, Integer> resultados) {
            java.util.List<String> candidatos = new java.util.ArrayList<>();
            for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) {
                if(e.getValue() > limite) {
                    candidatos.add(e.getKey() + " (" + e.getValue() + " votos)");
                }
            }
            if(candidatos.isEmpty()) {
                return "No hay candidatos con más de " + limite + " votos";
            }
            return "Candidatos con más de " + limite + " votos: " + String.join(", ", candidatos);
        }
    }
    
    // Expresión que verifica si hay empate
    class HayEmpateExpresion implements Expresion {
        public String interpretar(java.util.Map<String, Integer> resultados) {
            java.util.Collection<Integer> votos = resultados.values();
            int max = java.util.Collections.max(votos);
            int count = 0;
            for(int v : votos) {
                if(v == max) count++;
            }
            if(count > 1) {
                return "⚠️ Hay empate entre " + count + " candidatos con " + max + " votos cada uno";
            }
            return "✅ No hay empate. Hay un ganador claro.";
        }
    }
    
    // Expresión que muestra el porcentaje de un candidato
    class PorcentajeExpresion implements Expresion {
        private String candidato;
        
        public PorcentajeExpresion(String candidato) {
            this.candidato = candidato;
        }
        
        public String interpretar(java.util.Map<String, Integer> resultados) {
            int total = 0;
            for(int v : resultados.values()) total += v;
            int votos = resultados.getOrDefault(candidato, 0);
            int porcentaje = total > 0 ? (votos * 100 / total) : 0;
            return candidato + " tiene " + votos + " votos (" + porcentaje + "% del total)";
        }
    }
    
    // =============================================
    // EXPRESIONES NO TERMINALES (Combinaciones)
    // =============================================
    
    // Expresión AND (dos condiciones)
    class AndExpresion implements Expresion {
        private Expresion expr1;
        private Expresion expr2;
        
        public AndExpresion(Expresion e1, Expresion e2) {
            this.expr1 = e1;
            this.expr2 = e2;
        }
        
        public String interpretar(java.util.Map<String, Integer> resultados) {
            return expr1.interpretar(resultados) + " | " + expr2.interpretar(resultados);
        }
    }
    
    // Expresión OR (dos condiciones)
    class OrExpresion implements Expresion {
        private Expresion expr1;
        private Expresion expr2;
        
        public OrExpresion(Expresion e1, Expresion e2) {
            this.expr1 = e1;
            this.expr2 = e2;
        }
        
        public String interpretar(java.util.Map<String, Integer> resultados) {
            return expr1.interpretar(resultados) + " | " + expr2.interpretar(resultados);
        }
    }
    
    // =============================================
    // ANALIZADOR/PARSER SIMPLE
    // =============================================
    class InterpreteVotacion {
        public Expresion parsear(String comando) {
            if(comando == null) return null;
            
            if(comando.equalsIgnoreCase("total")) {
                return new TotalVotosExpresion();
            }
            if(comando.equalsIgnoreCase("ganador")) {
                return new GanadorExpresion();
            }
            if(comando.equalsIgnoreCase("empate")) {
                return new HayEmpateExpresion();
            }
            if(comando.startsWith("mayor que ")) {
                try {
                    int limite = Integer.parseInt(comando.substring(10).trim());
                    return new MayorQueExpresion(limite);
                } catch(Exception e) {
                    return null;
                }
            }
            if(comando.startsWith("porcentaje de ")) {
                String candidato = comando.substring(14).trim();
                return new PorcentajeExpresion(candidato);
            }
            return null;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Interpreter</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        .comando-ejemplo { background: #e8f4f8; padding: 8px 12px; border-radius: 8px; font-family: monospace; display: inline-block; margin: 5px; cursor: pointer; }
        .comando-ejemplo:hover { background: #d0e8f0; }
        input { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 12px; font-size: 14px; margin: 10px 0; font-family: monospace; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔤 Demostración del Patrón Interpreter</h1>
        <p>Define una representación para la gramática de un lenguaje y un intérprete que evalúa expresiones.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Resultados Electorales</h3>
        
        <%
            // Datos de ejemplo (resultados por candidato)
            java.util.Map<String, Integer> resultados = new java.util.LinkedHashMap<>();
            resultados.put("Candidato A", 450);
            resultados.put("Candidato B", 300);
            resultados.put("Candidato C", 200);
            resultados.put("Voto en Blanco", 50);
            
            String comando = request.getParameter("comando");
            String resultadoInterprete = "";
            
            if(comando != null && !comando.trim().isEmpty()) {
                InterpreteVotacion interprete = new InterpreteVotacion();
                Expresion expresion = interprete.parsear(comando.toLowerCase().trim());
                if(expresion != null) {
                    resultadoInterprete = expresion.interpretar(resultados);
                } else {
                    resultadoInterprete = "❌ Comando no reconocido. Prueba: total, ganador, empate, mayor que X, porcentaje de Candidato X";
                }
            }
        %>
        
        <!-- Tabla de resultados -->
        <table>
            <tr><th>Candidato</th><th>Votos</th></tr>
            <% for(java.util.Map.Entry<String, Integer> e : resultados.entrySet()) { %>
                <tr><td><%= e.getKey() %></td><td><%= e.getValue() %></td></tr>
            <% } %>
        </table>
        
        <!-- Comandos de ejemplo -->
        <div style="margin: 15px 0;">
            <strong>📋 Comandos disponibles:</strong><br>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='total'">total</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='ganador'">ganador</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='empate'">empate</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='mayor que 400'">mayor que 400</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='mayor que 250'">mayor que 250</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='porcentaje de Candidato A'">porcentaje de Candidato A</span>
            <span class="comando-ejemplo" onclick="document.getElementById('comandoInput').value='porcentaje de Voto en Blanco'">porcentaje de Voto en Blanco</span>
        </div>
        
        <!-- Entrada de comando -->
        <form method="get">
            <input type="text" name="comando" id="comandoInput" placeholder="Escribe un comando... Ej: total, ganador, mayor que 300" value="<%= comando != null ? comando : "" %>">
            <button type="submit" class="btn">🔍 Interpretar comando</button>
        </form>
        
        <% if(resultadoInterprete != null && !resultadoInterprete.isEmpty()) { %>
            <div class="pre">
                <strong>📌 Resultado:</strong><br>
                <%= resultadoInterprete %>
            </div>
        <% } %>
        
        <p><strong>🔍 ¿Qué es el patrón Interpreter?</strong><br>
        El Interpreter traduce comandos de texto en operaciones reales:<br>
        - <code>total</code> → Calcula el total de votos<br>
        - <code>ganador</code> → Encuentra el candidato con más votos<br>
        - <code>mayor que X</code> → Filtra candidatos con más de X votos<br>
        - <code>porcentaje de X</code> → Calcula el porcentaje de un candidato<br>
        Cada expresión es una clase que sabe cómo interpretarse a sí misma.
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
    
    <script>
        // Función para los ejemplos (ya está en los onclick)
    </script>
</body>
</html>