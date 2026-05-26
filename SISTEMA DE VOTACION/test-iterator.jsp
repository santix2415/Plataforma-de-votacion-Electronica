<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    // =============================================
    // INTERFAZ ITERADOR
    // =============================================
    interface Iterador<T> {
        boolean hasNext();
        T next();
        void reset();
    }
    
    // =============================================
    // INTERFAZ COLECCIÓN (AGREGADO)
    // =============================================
    interface Coleccion<T> {
        Iterador<T> crearIterador();
        void agregar(T elemento);
        int tamaño();
        T obtener(int index);
    }
    
    // =============================================
    // CLASE CANDIDATO (Elemento de la colección)
    // =============================================
    class CandidatoVotacion {
        private String nombre;
        private String partido;
        private int votos;
        
        public CandidatoVotacion(String nombre, String partido, int votos) {
            this.nombre = nombre;
            this.partido = partido;
            this.votos = votos;
        }
        
        public String getNombre() { return nombre; }
        public String getPartido() { return partido; }
        public int getVotos() { return votos; }
        
        public String toHTML() {
            return "<tr style='border-bottom:1px solid #ddd;'>" +
                   "<td style='padding:8px;'>" + nombre + "</td>" +
                   "<td style='padding:8px;'>" + partido + "</td>" +
                   "<td style='padding:8px;'>" + votos + "</td>" +
                   "</tr>";
        }
    }
    
    // =============================================
    // IMPLEMENTACIÓN CONCRETA DE COLECCIÓN (Lista de Candidatos)
    // =============================================
    class ListaCandidatos implements Coleccion<CandidatoVotacion> {
        private java.util.List<CandidatoVotacion> candidatos = new java.util.ArrayList<>();
        
        public void agregar(CandidatoVotacion c) {
            candidatos.add(c);
        }
        
        public int tamaño() {
            return candidatos.size();
        }
        
        public CandidatoVotacion obtener(int index) {
            return candidatos.get(index);
        }
        
        public Iterador<CandidatoVotacion> crearIterador() {
            return new IteradorCandidatos(this);
        }
        
        // Iterador interno (clase anidada)
        private class IteradorCandidatos implements Iterador<CandidatoVotacion> {
            private ListaCandidatos coleccion;
            private int posicion = 0;
            
            public IteradorCandidatos(ListaCandidatos col) {
                this.coleccion = col;
            }
            
            public boolean hasNext() {
                return posicion < coleccion.tamaño();
            }
            
            public CandidatoVotacion next() {
                if(hasNext()) {
                    return coleccion.obtener(posicion++);
                }
                return null;
            }
            
            public void reset() {
                posicion = 0;
            }
        }
    }
    
    // =============================================
    // ITERADOR INVERSO (Ejemplo de iterador diferente)
    // =============================================
    class IteradorInverso<T> implements Iterador<T> {
        private java.util.List<T> elementos;
        private int posicion;
        
        public IteradorInverso(java.util.List<T> lista) {
            this.elementos = lista;
            this.posicion = lista.size() - 1;
        }
        
        public boolean hasNext() {
            return posicion >= 0;
        }
        
        public T next() {
            if(hasNext()) {
                return elementos.get(posicion--);
            }
            return null;
        }
        
        public void reset() {
            posicion = elementos.size() - 1;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Iterator</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 800px; margin: 0 auto 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer; margin: 5px; font-size: 14px; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; white-space: pre-wrap; font-size: 13px; }
        .back-link { margin-top: 20px; display: inline-block; color: #667eea; text-decoration: none; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
        .iterador-info { background: #e8f4f8; padding: 10px; border-radius: 8px; margin: 10px 0; font-size: 13px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🔄 Demostración del Patrón Iterator</h1>
        <p>Proporciona una forma de acceder secuencialmente a los elementos de una colección sin exponer su representación interna.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Lista de Candidatos</h3>
        
        <%
            // Crear colección de candidatos
            ListaCandidatos candidatos = (ListaCandidatos) session.getAttribute("candidatosIterator");
            
            if(candidatos == null) {
                candidatos = new ListaCandidatos();
                candidatos.agregar(new CandidatoVotacion("Ana López", "Partido A", 450));
                candidatos.agregar(new CandidatoVotacion("Carlos Ruiz", "Partido A", 300));
                candidatos.agregar(new CandidatoVotacion("Martha Gómez", "Partido B", 200));
                candidatos.agregar(new CandidatoVotacion("Luis Pérez", "Partido B", 150));
                candidatos.agregar(new CandidatoVotacion("Sofía Ramírez", "Partido C", 100));
                session.setAttribute("candidatosIterator", candidatos);
            }
            
            String accion = request.getParameter("accion");
            String iteradorActual = (String) session.getAttribute("iteradorActual");
            String resultadoIterador = "";
            String elementosMostrados = "";
            
            if(iteradorActual == null) {
                iteradorActual = "normal";
                session.setAttribute("iteradorActual", iteradorActual);
            }
            
            if("cambiarNormal".equals(accion)) {
                iteradorActual = "normal";
                session.setAttribute("iteradorActual", iteradorActual);
                session.removeAttribute("posicionIterador");
                session.removeAttribute("elementosRecorridos");
                resultadoIterador = "✅ Iterador cambiado a: Recorrido Normal (de adelante hacia atrás)";
            } else if("cambiarInverso".equals(accion)) {
                iteradorActual = "inverso";
                session.setAttribute("iteradorActual", iteradorActual);
                session.removeAttribute("posicionIterador");
                session.removeAttribute("elementosRecorridos");
                resultadoIterador = "✅ Iterador cambiado a: Recorrido Inverso (de atrás hacia adelante)";
            } else if("siguiente".equals(accion)) {
                Integer posicion = (Integer) session.getAttribute("posicionIterador");
                java.util.List<String> elementos = (java.util.List<String>) session.getAttribute("elementosRecorridos");
                if(elementos == null) elementos = new java.util.ArrayList<>();
                
                if("normal".equals(iteradorActual)) {
                    Iterador<CandidatoVotacion> it = candidatos.crearIterador();
                    if(posicion != null) {
                        for(int i = 0; i <= posicion; i++) it.next();
                    }
                    if(it.hasNext()) {
                        CandidatoVotacion c = it.next();
                        elementos.add(c.getNombre() + " (" + c.getPartido() + ") - " + c.getVotos() + " votos");
                        session.setAttribute("posicionIterador", (posicion != null ? posicion + 1 : 0));
                        resultadoIterador = "📌 Elemento obtenido: " + c.getNombre();
                    } else {
                        resultadoIterador = "⚠️ No hay más elementos. Llegaste al final de la lista.";
                    }
                } else {
                    java.util.List<CandidatoVotacion> lista = new java.util.ArrayList<>();
                    for(int i = 0; i < candidatos.tamaño(); i++) lista.add(candidatos.obtener(i));
                    Iterador<CandidatoVotacion> it = new IteradorInverso<>(lista);
                    if(posicion != null) {
                        for(int i = 0; i <= posicion; i++) it.next();
                    }
                    if(it.hasNext()) {
                        CandidatoVotacion c = it.next();
                        elementos.add(c.getNombre() + " (" + c.getPartido() + ") - " + c.getVotos() + " votos");
                        session.setAttribute("posicionIterador", (posicion != null ? posicion + 1 : 0));
                        resultadoIterador = "📌 Elemento obtenido: " + c.getNombre();
                    } else {
                        resultadoIterador = "⚠️ No hay más elementos. Llegaste al inicio de la lista.";
                    }
                }
                session.setAttribute("elementosRecorridos", elementos);
            } else if("reiniciar".equals(accion)) {
                session.removeAttribute("posicionIterador");
                session.removeAttribute("elementosRecorridos");
                resultadoIterador = "🔄 Iterador reiniciado. Puedes comenzar desde el principio.";
            }
            
            java.util.List<String> elementosRecorridos = (java.util.List<String>) session.getAttribute("elementosRecorridos");
        %>
        
        <!-- Tabla de todos los candidatos -->
        <h4>📋 Lista completa de candidatos:</h4>
        <table>
            <tr><th>Nombre</th><th>Partido</th><th>Votos</th></tr>
            <% for(int i = 0; i < candidatos.tamaño(); i++) { %>
                <%= candidatos.obtener(i).toHTML() %>
            <% } %>
        </table>
        
        <!-- Controles del iterador -->
        <div style="margin: 20px 0;">
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarNormal">
                <button type="submit" class="btn">➡️ Iterador Normal (adelante)</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="cambiarInverso">
                <button type="submit" class="btn">⬅️ Iterador Inverso (atrás)</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="siguiente">
                <button type="submit" class="btn">⏩ Siguiente elemento</button>
            </form>
            <form method="get" style="display: inline;">
                <input type="hidden" name="accion" value="reiniciar">
                <button type="submit" class="btn">🔄 Reiniciar iterador</button>
            </form>
        </div>
        
        <div class="iterador-info">
            <strong>📍 Estado actual:</strong><br>
            Iterador activo: <strong><%= "normal".equals(iteradorActual) ? "Recorrido Normal (adelante →)" : "Recorrido Inverso (atrás ←)" %></strong>
        </div>
        
        <% if(resultadoIterador != null && !resultadoIterador.isEmpty()) { %>
            <div class="pre" style="background: #e8f8f0;">
                <strong>📌 Última acción:</strong><br>
                <%= resultadoIterador %>
            </div>
        <% } %>
        
        <% if(elementosRecorridos != null && !elementosRecorridos.isEmpty()) { %>
            <div class="pre">
                <strong>📜 Elementos recorridos hasta ahora:</strong><br>
                <% for(int i = 0; i < elementosRecorridos.size(); i++) { %>
                    <%= (i+1) %>. <%= elementosRecorridos.get(i) %><br>
                <% } %>
            </div>
        <% } %>
        
        <p><strong>🔍 ¿Qué es el patrón Iterator?</strong><br>
        El Iterator permite recorrer la colección de candidatos SIN necesidad de saber cómo están almacenados internamente:<br>
        - <strong>Iterador Normal:</strong> Recorre desde el primer candidato hasta el último (adelante)<br>
        - <strong>Iterador Inverso:</strong> Recorre desde el último candidato hasta el primero (atrás)<br>
        Ambos usan la misma interfaz <code>hasNext()</code> y <code>next()</code>, pero el comportamiento es diferente.
        </p>
    </div>
    <div class="card">
        <a href="index.html" class="back-link">← Volver al inicio</a>
    </div>
</body>
</html>