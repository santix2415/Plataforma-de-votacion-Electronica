<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // CLASES DECLARADAS FUERA (en declaración JSP)
    // =============================================
    interface Componente {
        int getVotos();
        String mostrar(String prefijo);
    }
    
    class Candidato implements Componente {
        String nombre;
        int votos;
        
        Candidato(String n, int v) {
            nombre = n;
            votos = v;
        }
        
        public int getVotos() {
            return votos;
        }
        
        public String mostrar(String prefijo) {
            return prefijo + "📌 " + nombre + ": " + votos + " votos";
        }
    }
    
    class Partido implements Componente {
        String nombre;
        java.util.List<Componente> miembros = new java.util.ArrayList<>();
        
        Partido(String n) {
            nombre = n;
        }
        
        void agregar(Componente c) {
            miembros.add(c);
        }
        
        public int getVotos() {
            int total = 0;
            for(Componente c : miembros) {
                total += c.getVotos();
            }
            return total;
        }
        
        public String mostrar(String prefijo) {
            String r = prefijo + "🏛️ " + nombre + " (Total: " + getVotos() + " votos)\n";
            for(Componente c : miembros) {
                r += c.mostrar(prefijo + "   ") + "\n";
            }
            return r;
        }
    }
    
    class Coalicion implements Componente {
        String nombre;
        java.util.List<Componente> partidos = new java.util.ArrayList<>();
        
        Coalicion(String n) {
            nombre = n;
        }
        
        void agregarPartido(Componente p) {
            partidos.add(p);
        }
        
        public int getVotos() {
            int total = 0;
            for(Componente p : partidos) {
                total += p.getVotos();
            }
            return total;
        }
        
        public String mostrar(String prefijo) {
            String r = prefijo + "🤝 COALICIÓN: " + nombre + " (Total: " + getVotos() + " votos)\n";
            for(Componente p : partidos) {
                r += p.mostrar(prefijo + "   ");
            }
            return r;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Composite</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .pre { background: #f0f0f0; padding: 20px; border-radius: 12px; font-family: monospace; white-space: pre; overflow-x: auto; font-size: 14px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🌳 Demostración del Patrón Composite</h1>
        <p>Permite tratar objetos individuales y composiciones de objetos de manera uniforme.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Estructura de Candidatos y Partidos</h3>
        <%
            // Crear candidatos individuales (Hojas)
            Candidato c1 = new Candidato("Ana López", 450);
            Candidato c2 = new Candidato("Carlos Ruiz", 300);
            Candidato c3 = new Candidato("Martha Gómez", 200);
            Candidato c4 = new Candidato("Luis Pérez", 150);
            
            // Crear Partidos (Composites)
            Partido partidoA = new Partido("Partido A");
            partidoA.agregar(c1);
            partidoA.agregar(c2);
            
            Partido partidoB = new Partido("Partido B");
            partidoB.agregar(c3);
            partidoB.agregar(c4);
            
            // Crear Coalición (Composite que agrupa partidos)
            Coalicion alianza = new Coalicion("Alianza por el Cambio");
            alianza.agregarPartido(partidoA);
            alianza.agregarPartido(partidoB);
            
            // Mostrar la estructura
            out.println("<div class='pre'>");
            out.println("=== ESTRUCTURA DE VOTACIÓN ===\n\n");
            out.println(alianza.mostrar(""));
            out.println("\n📊 Total de votos de la coalición: " + alianza.getVotos());
            out.println("</div>");
        %>
        
        <p><strong>📚 ¿Qué es el patrón Composite?</strong><br>
        Un <strong>Candidato</strong> (hoja) tiene votos individuales.<br>
        Un <strong>Partido</strong> (composite) agrupa varios candidatos y suma sus votos.<br>
        Una <strong>Coalición</strong> (composite de composites) agrupa varios partidos.<br>
        <strong>El mismo método <code>getVotos()</code> funciona para todos.</strong></p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>