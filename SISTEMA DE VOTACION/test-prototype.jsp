<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Demo Prototype</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; }
        .card { background: white; border-radius: 24px; max-width: 600px; margin: 0 auto 20px; padding: 30px; }
        h1 { margin-bottom: 20px; }
        .btn { background: #667eea; color: white; padding: 12px 24px; border-radius: 8px; border: none; cursor: pointer; }
        .pre { background: #f0f0f0; padding: 15px; border-radius: 12px; margin: 15px 0; font-family: monospace; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🧬 Demostración del Patrón Prototype</h1>
        <p>Permite crear nuevos objetos copiando (clonando) una instancia existente.</p>
    </div>
    <div class="card">
        <h3>🎮 Simulación: Clonación de Votos</h3>
        <%
            class VotoPrototype implements Cloneable {
                private String cedula, candidato;
                public VotoPrototype(String c, String ca){ cedula = c; candidato = ca; }
                public VotoPrototype clone() { try { return (VotoPrototype) super.clone(); } catch(Exception e){ return null; } }
                public void setCedula(String c){ cedula = c; }
                public void setCandidato(String c){ candidato = c; }
                public String getInfo(){ return "📇 " + cedula + " → 🗳️ " + candidato; }
            }
            
            if("clonar".equals(request.getParameter("action"))) {
                VotoPrototype original = new VotoPrototype("12345", "Candidato A");
                VotoPrototype clon = original.clone();
                clon.setCedula("67890");
                clon.setCandidato("Candidato B");
                out.println("<div class='pre'><strong>🧬 Resultado de la clonación:</strong><br>");
                out.println("🔹 Original: " + original.getInfo() + "<br>");
                out.println("🔸 Clon (modificado): " + clon.getInfo() + "<br>");
                out.println("✅ El clon es completamente independiente del original</div>");
            }
        %>
        <form method="get">
            <button type="submit" name="action" value="clonar" class="btn">🧬 Clonar Voto</button>
        </form>
    </div>
    <div class="card"><a href="index.html">← Volver al inicio</a></div>
</body>
</html>