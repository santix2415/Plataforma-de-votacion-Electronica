#  Plataforma de Votación Electrónica

Sistema de votación electrónica para un proyecto de la universidad

---

## Descripción
Plataforma web que permite autenticación segura de votantes, conteo automatizado de votos, auditoría del proceso y escalabilidad para elecciones nacionales.
El sistema permitirá registrar usuarios, habilitar procesos de votación, emitir votos de forma segura y obtener resultados automáticos sin necesidad de conteo manual.

---

## Usuarios del Sistema

### Administrador
- Crea y configura las votaciones.
- Gestiona las opciones disponibles.
- Consulta los resultados.

### Usuario / Votante
- Accede al sistema con su cuenta.
- Participa en las votaciones habilitadas.
- Emite su voto una sola vez por proceso.

---

##  Funcionamiento Básico

1. El administrador crea una votación.
2. Los usuarios ingresan al sistema.
3. Seleccionan su opción preferida.
4. Confirman su voto.
5. El sistema registra el voto automáticamente.
6. Los resultados pueden consultarse al finalizar.

---

##  Tecnologías Específicas

### Lenguajes Principales
- **Java** - Lógica del servidor (Servlets y JSP)
- **JavaScript** - Validaciones e interactividad en el cliente
- **HTML5** - Estructura de las páginas
- **CSS3** - Estilos y diseño visual



### Entorno de Desarrollo
- **XAMPP** - Contiene:
  - Apache (servidor web)
  - MySQL (base de datos)
  - PHPMyAdmin (administración BD)
- **Apache Tomcat** - Servidor para Java (aparte de XAMPP)
- **Visual Studio Code** - Editor de código

### Base de Datos
- **MySQL** - Administrada desde PHPMyAdmin (incluido en XAMPP)

### Control de Versiones
- **Git** - Control local
- **GitHub** - Repositorio remoto
