<%-- 
    Document   : index
    Created on : 1 abr. 2026, 20:08:30
    Author     : vania y Oscar
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Museo del Espacio | Explora el Cosmos</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Raleway:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --void: #02030f;
            --deep: #07091a;
            --navy: #0d1033;
            --gold: #c9a84c;
            --gold-bright: #f0d080;
            --gold-dim: #7a5f28;
            --cyan: #00e5ff;
            --white: #f0f4ff;
            --soft: #8892b0;
            --surface: rgba(255,255,255,0.04);
            --border: rgba(201,168,76,0.25);
            --glow-gold: 0 0 30px rgba(201,168,76,0.4);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }

        body {
            font-family: 'Raleway', sans-serif;
            background: var(--void);
            color: var(--white);
            min-height: 100vh;
            overflow-x: hidden;
            padding: 2rem 1rem 3rem;
            position: relative;
        }

        /* ── Fondo estrellado canvas ── */
        #starfield {
            position: fixed; inset: 0;
            z-index: 0;
            pointer-events: none;
        }

        /* ── Planetas decorativos ── */
        .planet {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 1;
            opacity: 0.12;
            filter: blur(2px);
        }
        .planet-1 {
            width: 320px; height: 320px;
            background: radial-gradient(circle at 30% 30%, #8338ec, transparent 70%);
            top: -100px; right: -60px;
            animation: float 20s ease-in-out infinite;
        }
        .planet-2 {
            width: 220px; height: 220px;
            background: radial-gradient(circle at 30% 30%, #c9a84c, transparent 70%);
            bottom: 10%; left: -60px;
            animation: float 25s ease-in-out infinite reverse;
        }
        .planet-3 {
            width: 160px; height: 160px;
            background: radial-gradient(circle at 30% 30%, #00e5ff, transparent 70%);
            top: 40%; right: 5%;
            animation: float 18s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translate(0,0) rotate(0deg); }
            33%       { transform: translate(30px,-30px) rotate(120deg); }
            66%       { transform: translate(-20px,20px) rotate(240deg); }
        }

        /* ── Contenedor ── */
        .container {
            width: min(1200px, 100%);
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        /* ── HERO ── */
        .hero {
            background: linear-gradient(135deg, rgba(13,16,51,0.7), rgba(7,9,26,0.8));
            border: 1px solid var(--border);
            border-radius: 4px;
            box-shadow: 0 0 0 1px rgba(201,168,76,0.08), 0 40px 80px rgba(0,0,0,0.7), var(--glow-gold);
            padding: 3.5rem 2rem;
            margin-bottom: 2rem;
            backdrop-filter: blur(16px);
            animation: fadeInUp 1s ease both;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        /* Línea superior dorada del hero */
        .hero::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }

        /* Destello rotatorio de fondo */
        .hero::after {
            content: "";
            position: absolute;
            top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: radial-gradient(circle, rgba(201,168,76,0.05), transparent 60%);
            animation: rotate 30s linear infinite;
            pointer-events: none;
        }
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to   { transform: rotate(360deg); }
        }

        .hero-content { position: relative; z-index: 1; }

        /* Tag / badge superior */
        .tag {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-family: 'Cinzel', serif;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            color: var(--void);
            background: linear-gradient(135deg, var(--gold-bright), var(--gold));
            border-radius: 2px;
            padding: 0.4rem 1.2rem;
            margin-bottom: 1.8rem;
            box-shadow: 0 4px 20px rgba(201,168,76,0.3);
        }
        .tag::before { content: "🚀"; }

        /* Título principal */
        .hero h1 {
            font-family: 'Cinzel', serif;
            font-size: clamp(2.2rem, 4vw + 1rem, 4.5rem);
            font-weight: 900;
            line-height: 1.1;
            letter-spacing: 0.05em;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--gold-bright), var(--gold), var(--gold-dim));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            filter: drop-shadow(0 0 40px rgba(201,168,76,0.4));
            animation: glow 3s ease-in-out infinite alternate;
        }
        @keyframes glow {
            from { filter: drop-shadow(0 0 15px rgba(201,168,76,0.4)); }
            to   { filter: drop-shadow(0 0 35px rgba(201,168,76,0.7)); }
        }

        .hero p {
            max-width: 72ch;
            color: var(--soft);
            font-size: 1rem;
            line-height: 1.8;
            margin: 0 auto;
        }

        /* Stats */
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 2.5rem;
            flex-wrap: wrap;
        }

        .stat {
            text-align: center;
            padding: 1rem 1.2rem;
            background: rgba(201,168,76,0.06);
            border: 1px solid rgba(201,168,76,0.2);
            border-radius: 2px;
            min-width: 120px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .stat:hover {
            border-color: var(--gold);
            box-shadow: var(--glow-gold);
        }

        .stat-number {
            font-family: 'Cinzel', serif;
            font-size: 2rem;
            font-weight: 700;
            color: var(--gold-bright);
            display: block;
        }

        .stat-label {
            font-size: 0.75rem;
            color: var(--soft);
            letter-spacing: 0.15em;
            text-transform: uppercase;
        }

        /* ── SECCIONES (2 cards) ── */
        .sections {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 1.5rem;
        }

        .section-card {
            background: linear-gradient(135deg, rgba(13,16,51,0.7), rgba(7,9,26,0.85));
            border: 1px solid rgba(201,168,76,0.15);
            border-radius: 4px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
            padding: 2.5rem 2rem;
            backdrop-filter: blur(12px);
            animation: fadeInUp 1.2s ease both;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        /* Línea superior de color por card */
        .section-card.recorrido {
            border-top: 2px solid var(--gold);
        }
        .section-card.rompecabezas {
            border-top: 2px solid #00e5ff;
        }

        /* Destello hover */
        .section-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 100%;
            background: radial-gradient(ellipse at top, rgba(201,168,76,0.04), transparent 70%);
            opacity: 0;
            transition: opacity 0.4s ease;
            pointer-events: none;
        }
        .section-card.rompecabezas::before {
            background: radial-gradient(ellipse at top, rgba(0,229,255,0.04), transparent 70%);
        }
        .section-card:hover::before { opacity: 1; }

        .section-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 30px 70px rgba(0,0,0,0.7), var(--glow-gold);
            border-color: rgba(201,168,76,0.4);
        }
        .section-card.rompecabezas:hover {
            box-shadow: 0 30px 70px rgba(0,0,0,0.7), 0 0 30px rgba(0,229,255,0.3);
            border-color: rgba(0,229,255,0.4);
        }

        .section-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .section-card h2 {
            font-family: 'Cinzel', serif;
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 0.8rem;
            color: var(--gold-bright);
            letter-spacing: 0.05em;
        }
        .section-card.rompecabezas h2 {
            color: #00e5ff;
        }

        .section-card p {
            color: var(--soft);
            margin-bottom: 1.2rem;
            line-height: 1.75;
            font-size: 0.95rem;
        }

        /* Feature chips */
        .feature-list {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.8rem;
        }

        .feature {
            font-size: 0.78rem;
            border: 1px solid rgba(201,168,76,0.25);
            color: var(--soft);
            border-radius: 2px;
            padding: 0.3rem 0.85rem;
            background: rgba(201,168,76,0.05);
            letter-spacing: 0.05em;
            transition: background 0.2s ease, border-color 0.2s ease, color 0.2s ease, transform 0.2s ease;
        }
        .section-card.rompecabezas .feature {
            border-color: rgba(0,229,255,0.2);
            background: rgba(0,229,255,0.04);
        }
        .feature:hover {
            background: rgba(201,168,76,0.12);
            border-color: var(--gold);
            color: var(--gold);
            transform: translateY(-2px);
        }
        .section-card.rompecabezas .feature:hover {
            background: rgba(0,229,255,0.1);
            border-color: #00e5ff;
            color: #00e5ff;
        }

        /* Botones CTA */
        .cta {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            font-family: 'Cinzel', serif;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--void);
            background: linear-gradient(135deg, var(--gold-bright), var(--gold));
            border-radius: 2px;
            padding: 0.9rem 1.8rem;
            transition: transform 0.2s ease, filter 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 20px rgba(201,168,76,0.3);
            position: relative;
            overflow: hidden;
        }
        .cta:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
            box-shadow: 0 8px 30px rgba(201,168,76,0.5);
        }

        .cta.secondary {
            background: linear-gradient(135deg, #00e5ff, #0099cc);
            box-shadow: 0 4px 20px rgba(0,229,255,0.3);
            color: var(--void);
        }
        .cta.secondary:hover {
            box-shadow: 0 8px 30px rgba(0,229,255,0.5);
        }

        /* Status */
        .status {
            margin-top: 1.5rem;
            font-size: 0.82rem;
            color: var(--soft);
            background: rgba(201,168,76,0.06);
            border-left: 2px solid var(--gold-dim);
            padding: 0.7rem 1rem;
            letter-spacing: 0.03em;
        }
        .status.rompecabezas {
            border-left-color: rgba(0,229,255,0.5);
            background: rgba(0,229,255,0.04);
        }

        /* ── Animaciones ── */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Responsive ── */
        @media (max-width: 780px) {
            .sections { grid-template-columns: 1fr; }
            .hero { padding: 2.5rem 1.5rem; }
            .hero-stats { gap: 1rem; }
            .stat { min-width: 100px; padding: 0.8rem; }
            .stat-number { font-size: 1.5rem; }
            .planet { display: none; }
        }
    </style>
</head>
<body>

    <canvas id="starfield"></canvas>

    <!-- Planetas decorativos -->
    <div class="planet planet-1"></div>
    <div class="planet planet-2"></div>
    <div class="planet planet-3"></div>

    <main class="container">

        <!-- ── HERO ── -->
        <section class="hero">
            <div class="hero-content">
                <span class="tag">Exploración Espacial</span>
                <h1>Museo del Espacio</h1>
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

        <!-- ── SECCIONES PRINCIPALES ── -->
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
                    <span class="feature">🪐 Sistema Solar</span>
                    <span class="feature">✨ Nebulosas</span>
                    <span class="feature">🌟 Galaxias</span>
                    <span class="feature">🌙 Satélites</span>
                    <span class="feature">☄️ Asteroides</span>
                    <span class="feature">🕳️ Agujeros Negros</span>
                </div>
                <a class="cta" href="${pageContext.request.contextPath}/recorrido.jsp" aria-label="Iniciar recorrido espacial">
                    Iniciar Expedición
                    <span>→</span>
                </a>
                <p class="status">
                    <strong>✦ Estado:</strong> Sala activa. Imágenes reales de la NASA y datos enciclopédicos en vivo.
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
                    <span class="feature">📊 Estadísticas</span>
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
        /* ── Fondo estrellado (mismo que recorrido.jsp) ── */
        (function initStars() {
            const canvas = document.getElementById("starfield");
            const ctx    = canvas.getContext("2d");
            let stars    = [];

            function resize() {
                canvas.width  = window.innerWidth;
                canvas.height = window.innerHeight;
            }

            function createStars(n) {
                stars = [];
                for (let i = 0; i < n; i++) {
                    stars.push({
                        x:     Math.random() * canvas.width,
                        y:     Math.random() * canvas.height,
                        r:     Math.random() * 1.4,
                        a:     Math.random(),
                        speed: 0.002 + Math.random() * 0.006,
                        phase: Math.random() * Math.PI * 2
                    });
                }
            }

            function draw(t) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                stars.forEach(s => {
                    const alpha = s.a * (0.5 + 0.5 * Math.sin(t * s.speed + s.phase));
                    ctx.beginPath();
                    ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
                    ctx.fillStyle = `rgba(240,244,255,${alpha})`;
                    ctx.fill();
                });
                requestAnimationFrame(draw);
            }

            resize();
            createStars(300);
            window.addEventListener("resize", () => { resize(); createStars(300); });
            requestAnimationFrame(draw);
        })();

        /* ── Contador animado de estadísticas ── */
        document.addEventListener("DOMContentLoaded", function() {
            const stats = document.querySelectorAll(".stat-number");

            const animateValue = (element, start, end, duration) => {
                let startTimestamp = null;
                const step = (timestamp) => {
                    if (!startTimestamp) startTimestamp = timestamp;
                    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                    const value    = Math.floor(progress * (end - start) + start);
                    const orig     = element.dataset.orig;
                    element.textContent = value + (orig.includes("+") ? "+" : "");
                    if (progress < 1) window.requestAnimationFrame(step);
                };
                window.requestAnimationFrame(step);
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const el  = entry.target;
                        const txt = el.textContent.trim();
                        const num = parseInt(txt);
                        if (!isNaN(num)) {
                            el.dataset.orig = txt;
                            animateValue(el, 0, num, 2000);
                        }
                        observer.unobserve(el);
                    }
                });
            });

            stats.forEach(stat => observer.observe(stat));
        });
    </script>
</body>
</html>
