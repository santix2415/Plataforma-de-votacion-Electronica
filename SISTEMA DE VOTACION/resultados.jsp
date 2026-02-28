<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados | Elecciones Colombia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
        .results-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        .results-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .result-item {
            margin: 25px 0;
        }
        .result-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .progress-bar-custom {
            height: 30px;
            background: #edf2f7;
            border-radius: 15px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            color: white;
            line-height: 30px;
            padding-left: 15px;
            white-space: nowrap;
        }
        .ganador {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            display: inline-block;
            margin-bottom: 20px;
        }
        .btn-back {
            background: #667eea;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            text-decoration: none;
            display: inline-block;
            margin-top: 30px;
        }
        .btn-back:hover {
            background: #5a67d8;
            color: white;
        }
    </style>
</head>
<body>
    <div class="results-container">
        <div class="results-card">
            <h1 class="text-center mb-4">📊 Resultados Electorales</h1>
            
            <%
                String success = request.getParameter("success");
                if(success != null) {
            %>
                <div class="alert alert-success text-center">
                    ✅ <%= success %>
                </div>
            <%
                }
            %>
            
            <div class="ganador">
                🏆 Candidato 1 va ganando
            </div>
            
            <div class="result-item">
                <div class="result-label">
                    <span>Candidato 1 - Partido A</span>
                    <span>45% (450 votos)</span>
                </div>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width: 45%">45%</div>
                </div>
            </div>
            
            <div class="result-item">
                <div class="result-label">
                    <span>Candidato 2 - Partido B</span>
                    <span>30% (300 votos)</span>
                </div>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width: 30%">30%</div>
                </div>
            </div>
            
            <div class="result-item">
                <div class="result-label">
                    <span>Candidato 3 - Partido C</span>
                    <span>20% (200 votos)</span>
                </div>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width: 20%">20%</div>
                </div>
            </div>
            
            <div class="result-item">
                <div class="result-label">
                    <span>Voto en Blanco</span>
                    <span>5% (50 votos)</span>
                </div>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width: 5%">5%</div>
                </div>
            </div>
            
            <div class="text-center">
                <p class="text-muted mt-4">Total de votos: 1000</p>
                <a href="index.html" class="btn-back">← Volver al Inicio</a>
            </div>
        </div>
    </div>
</body>
</html>