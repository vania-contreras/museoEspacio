<%-- 
    Document   : index
    Created on : 1 abr. 2026, 20:08:30
    Author     : vania
--%>

<%-- 
    Document   : index
    Created on : Museo del Espacio - Experiencia Interactiva
    Author     : vania
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Museo del Espacio | Explora el Cosmos</title>
    <style>
        :root {
            --space-deep: #0a0e27;
            --space-navy: #1a1f4d;
            --space-purple: #2d1b69;
            --nebula-pink: #ff006e;
            --nebula-blue: #00f5ff;
            --nebula-purple: #8338ec;
            --star-white: #ffffff;
            --planet-gold: #fb5607;
            --surface: rgba(255, 255, 255, 0.05);
            --text-main: #e0e7ff;
            --text-soft: #a5b4fc;
            --accent: #00f5ff;
            --accent-2: #ff006e;
            --radius: 20px;
            --shadow: 0 20px 60px rgba(0, 245, 255, 0.15);
            --shadow-glow: 0 0 40px rgba(131, 56, 236, 0.3);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-main);
            background: 
                radial-gradient(ellipse at top, var(--space-purple), transparent 50%),
                radial-gradient(ellipse at bottom, var(--space-navy), transparent 50%),
                linear-gradient(180deg, var(--space-deep), var(--space-navy));
            min-height: 100vh;
            line-height: 1.6;
            padding: 2rem 1rem 3rem;
            position: relative;
            overflow-x: hidden;
        }

        /* === FONDO ESTRELLADO ANIMADO === */
        .stars, .stars2, .stars3 {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .stars {
            background-image: 
                radial-gradient(2px 2px at 20px 30px, var(--star-white), transparent),
                radial-gradient(2px 2px at 40px 70px, rgba(255,255,255,0.8), transparent),
                radial-gradient(1px 1px at 90px 40px, var(--star-white), transparent),
                radial-gradient(2px 2px at 160px 120px, var(--star-white), transparent),
                radial-gradient(1px 1px at 230px 80px, rgba(255,255,255,0.9), transparent),
                radial-gradient(2px 2px at 300px 150px, var(--star-white), transparent);
            background-repeat: repeat;
            background-size: 350px 200px;
            animation: twinkle 5s ease-in-out infinite;
            opacity: 0.6;
        }

        .stars2 {
            background-image: 
                radial-gradient(2px 2px at 50px 100px, var(--nebula-blue), transparent),
                radial-gradient(1px 1px at 120px 60px, var(--star-white), transparent),
                radial-gradient(2px 2px at 200px 180px, var(--nebula-purple), transparent);
            background-repeat: repeat;
            background-size: 400px 250px;
            animation: twinkle 7s ease-in-out infinite reverse;
            opacity: 0.4;
        }

        .stars3 {
            background-image: 
                radial-gradient(1px 1px at 80px 150px, var(--nebula-pink), transparent),
                radial-gradient(2px 2px at 180px 90px, var(--star-white), transparent);
            background-repeat: repeat;
            background-size: 300px 200px;
            animation: twinkle 6s ease-in-out infinite;
            opacity: 0.3;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0.3; transform: translateY(0); }
            50% { opacity: 0.7; transform: translateY(-10px); }
        }

        /* === PLANETAS DECORATIVOS FLOTANTES === */
        .planet {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 1;
            opacity: 0.15;
            filter: blur(1px);
        }

        .planet-1 {
            width: 300px;
            height: 300px;
            background: radial-gradient(circle at 30% 30%, var(--nebula-purple), transparent 70%);
            top: -100px;
            right: -50px;
            animation: float 20s ease-in-out infinite;
        }

        .planet-2 {
            width: 200px;
            height: 200px;
            background: radial-gradient(circle at 30% 30%, var(--nebula-blue), transparent 70%);
            bottom: 10%;
            left: -50px;
            animation: float 25s ease-in-out infinite reverse;
        }

        .planet-3 {
            width: 150px;
            height: 150px;
            background: radial-gradient(circle at 30% 30%, var(--planet-gold), transparent 70%);
            top: 40%;
            right: 5%;
            animation: float 18s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }

        /* === CONTENIDO PRINCIPAL === */
        .container {
            width: min(1200px, 100%);
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        /* === HERO SECTION === */
        .hero {
            background: var(--surface);
            border: 1px solid rgba(0, 245, 255, 0.2);
            border-radius: var(--radius);
            box-shadow: var(--shadow), var(--shadow-glow);
            padding: 3rem 2rem;
            margin-bottom: 2rem;
            backdrop-filter: blur(12px);
            animation: fadeInUp 1s ease both;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(0, 245, 255, 0.1), transparent 70%);
            animation: rotate 30s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .tag {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--space-deep);
            background: linear-gradient(135deg, var(--accent), var(--nebula-blue));
            border-radius: 999px;
            padding: 0.4rem 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 245, 255, 0.3);
        }

        .tag::before {
            content: "🚀";
        }

        .hero h1 {
            font-size: clamp(2rem, 3vw + 1rem, 3.5rem);
            line-height: 1.2;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--star-white), var(--accent), var(--nebula-purple));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 40px rgba(0, 245, 255, 0.3);
        }

        .hero p {
            max-width: 75ch;
            color: var(--text-soft);
            font-size: 1.1rem;
            margin: 0 auto;
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .stat {
            text-align: center;
            padding: 1rem;
            background: rgba(0, 245, 255, 0.1);
            border-radius: 12px;
            border: 1px solid rgba(0, 245, 255, 0.2);
            min-width: 120px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent);
            display: block;
        }

        .stat-label {
            font-size: 0.85rem;
            color: var(--text-soft);
        }

        /* === SECCIONES PRINCIPALES === */
        .sections {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 1.5rem;
        }

        .section-card {
            background: var(--surface);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
            backdrop-filter: blur(12px);
            animation: fadeInUp 1.2s ease both;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .section-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent), var(--accent-2));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .section-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 70px rgba(0, 245, 255, 0.2);
            border-color: rgba(0, 245, 255, 0.3);
        }

        .section-card:hover::before {
            transform: scaleX(1);
        }

        .section-card.recorrido {
            border-top: 3px solid var(--accent);
        }

        .section-card.rompecabezas {
            border-top: 3px solid var(--accent-2);
        }

        .section-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .section-card h2 {
            font-size: 1.8rem;
            margin-bottom: 0.8rem;
            color: var(--star-white);
        }

        .section-card p {
            color: var(--text-soft);
            margin-bottom: 1.2rem;
            line-height: 1.7;
        }

        .feature-list {
            display: flex;
            flex-wrap: wrap;
            gap: 0.6rem;
            margin-bottom: 1.5rem;
        }

        .feature {
            font-size: 0.85rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--text-main);
            border-radius: 999px;
            padding: 0.35rem 0.85rem;
            background: rgba(255, 255, 255, 0.05);
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .feature:hover {
            background: rgba(0, 245, 255, 0.15);
            transform: translateY(-2px);
        }

        .cta {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            font-weight: 700;
            color: var(--space-deep);
            background: linear-gradient(135deg, var(--accent), var(--nebula-blue));
            border-radius: 12px;
            padding: 0.85rem 1.5rem;
            transition: transform 0.2s ease, filter 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 15px rgba(0, 245, 255, 0.3);
        }

        .cta:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
            box-shadow: 0 8px 25px rgba(0, 245, 255, 0.4);
        }

        .cta.secondary {
            background: linear-gradient(135deg, var(--accent-2), var(--planet-gold));
            box-shadow: 0 4px 15px rgba(255, 0, 110, 0.3);
        }

        .cta.secondary:hover {
            box-shadow: 0 8px 25px rgba(255, 0, 110, 0.4);
        }

        .status {
            margin-top: 1.2rem;
            font-size: 0.85rem;
            color: var(--text-soft);
            background: rgba(0, 245, 255, 0.1);
            border-left: 3px solid var(--accent);
            border-radius: 8px;
            padding: 0.7rem 1rem;
        }

        .status.rompecabezas {
            border-left-color: var(--accent-2);
            background: rgba(255, 0, 110, 0.1);
        }

        /* === ANIMACIONES === */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* === RESPONSIVE === */
        @media (max-width: 780px) {
            .sections {
                grid-template-columns: 1fr;
            }

            .hero {
                padding: 2rem 1.5rem;
            }

            .hero-stats {
                gap: 1rem;
            }

            .stat {
                min-width: 100px;
                padding: 0.8rem;
            }

            .stat-number {
                font-size: 1.5rem;
            }

            .planet {
                display: none;
            }
        }

        /* === EFECTO DE BRILLO EN TEXTO === */
        .glow-text {
            animation: glow 3s ease-in-out infinite alternate;
        }

        @keyframes glow {
            from { text-shadow: 0 0 10px var(--accent), 0 0 20px var(--accent); }
            to { text-shadow: 0 0 20px var(--accent), 0 0 30px var(--accent), 0 0 40px var(--accent); }
        }
    </style>
</head>
<body>
    <!-- Fondos estrellados -->
    <div class="stars"></div>
    <div class="stars2"></div>
    <div class="stars3"></div>
    
    <!-- Planetas decorativos -->
    <div class="planet planet-1"></div>
    <div class="planet planet-2"></div>
    <div class="planet planet-3"></div>

    <main class="container">
        <!-- HERO SECTION -->
        <section class="hero">
            <div class="hero-content">
                <span class="tag">Exploración Espacial</span>
                <h1 class="glow-text">Museo del Espacio</h1>
                <p>
                    Embárcate en un viaje cósmico a través del universo. Explora galaxias lejanas, 
                    descubre la formación de sistemas planetarios, admira nebulosas espectaculares 
                    y conoce los misterios de los satélites naturales. Una experiencia interactiva 
                    que te llevará más allá de las estrellas.
                </p>
                
                <div class="hero-stats">
                    <div class="stat">
                        <span class="stat-number">8</span>
                        <span class="stat-label">Planetas</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">200+</span>
                        <span class="stat-label">Galaxias</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">∞</span>
                        <span class="stat-label">Estrellas</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">180+</span>
                        <span class="stat-label">Lunas</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- SECCIONES PRINCIPALES -->
        <section class="sections" aria-label="Secciones principales del museo">
            <!-- RECORRIDO -->
            <article class="section-card recorrido" id="recorrido">
                <span class="section-icon">🌌</span>
                <h2>Recorrido Cósmico</h2>
                <p>
                    Viaja a través del cosmos en una expedición guiada. Explora desde nuestro 
                    Sistema Solar hasta las galaxias más remotas. Descubre la formación de 
                    nebulosas, la vida de las estrellas y los secretos de los agujeros negros.
                </p>
                <div class="feature-list" aria-label="Características del recorrido">
                    <span class="feature"> Sistema Solar</span>
                    <span class="feature">✨ Nebulosas</span>
                    <span class="feature">🌟 Galaxias</span>
                    <span class="feature">🌙 Satélites</span>
                    <span class="feature">☄️ Asteroides</span>
                    <span class="feature">🔴 Agujeros Negros</span>
                </div>
                <a class="cta" href="${pageContext.request.contextPath}/recorrido.jsp" aria-label="Iniciar recorrido espacial">
                    Iniciar Expedición
                    <span>→</span>
                </a>
                <p class="status">
                    <strong> Estado:</strong> Lista de exploración. Preparado para integrar contenido multimedia del cosmos.
                </p>
            </article>

            <!-- ROMPECABEZAS -->
            <article class="section-card rompecabezas" id="rompecabezas">
                <span class="section-icon">🧩</span>
                <h2>Rompecabezas Espacial</h2>
                <p>
                    Pon a prueba tus conocimientos del universo armando espectaculares imágenes 
                    del cosmos. Desde planetas hasta nebulosas, cada pieza te acerca más a 
                    comprender la belleza del espacio exterior.
                </p>
                <div class="feature-list" aria-label="Características del rompecabezas">
                    <span class="feature">🎯 Múltiples dificultades</span>
                    <span class="feature">⏱️ Cronómetro</span>
                    <span class="feature">🏆 Sistema de récords</span>
                    <span class="feature">🖼️ Imágenes HD</span>
                    <span class="feature"> Estadísticas</span>
                </div>
                <a class="cta secondary" href="${pageContext.request.contextPath}/rompecabezas.jsp" aria-label="Jugar rompecabezas espacial">
                    Jugar Ahora
                    <span>🚀</span>
                </a>
                <p class="status rompecabezas">
                    <strong>🎮 Estado:</strong> Módulo de juegos activo. Selecciona tu imagen cósmica favorita.
                </p>
            </article>
        </section>
    </main>

    <script>
        // Animación adicional: Contador animado para las estadísticas
        document.addEventListener("DOMContentLoaded", function() {
            const stats = document.querySelectorAll(".stat-number");
            
            const animateValue = (element, start, end, duration) => {
                let startTimestamp = null;
                const step = (timestamp) => {
                    if (!startTimestamp) startTimestamp = timestamp;
                    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                    const value = Math.floor(progress * (end - start) + start);
                    element.textContent = value + (element.textContent.includes("+") ? "+" : element.textContent.includes("∞") ? "" : "");
                    if (progress < 1) {
                        window.requestAnimationFrame(step);
                    }
                };
                window.requestAnimationFrame(step);
            };

            // Animar estadísticas cuando sean visibles
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const text = entry.target.textContent;
                        const num = parseInt(text);
                        if (!isNaN(num)) {
                            animateValue(entry.target, 0, num, 2000);
                        }
                        observer.unobserve(entry.target);
                    }
                });
            });

            stats.forEach(stat => observer.observe(stat));
        });
    </script>
</body>
</html>