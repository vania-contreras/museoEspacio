<%-- 
    Document   : rompecabezas
    Created on : 1 abr. 2026, 20:12:16
    Author     : vania y Oscar

    Descripción:
    Sala de juegos interactiva del Museo del Espacio.
    El jugador arma un rompecabezas deslizante (estilo 15-puzzle)
    con imágenes del cosmos.

    Servicios reutilizados en esta página:
      1. JakartaEE11Resource (/resources/jakartaee11)
         → Servlet REST propio (Jakarta EE) que verifica la conexión
           al servidor. Se llama al iniciar la página para mostrar
           el estado del backend.
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Rompecabezas Espacial | Museo del Espacio</title>
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
            --ok-bg: rgba(16,185,129,0.15);
            --ok-border: rgba(16,185,129,0.4);
            --warn-bg: rgba(245,158,11,0.15);
            --warn-border: rgba(245,158,11,0.4);
            --error-bg: rgba(239,68,68,0.15);
            --error-border: rgba(239,68,68,0.4);
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

        /* ── Fondo estrellado ── */
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
            opacity: 0.1;
            filter: blur(2px);
        }
        .planet-1 {
            width: 280px; height: 280px;
            background: radial-gradient(circle at 30% 30%, #8338ec, transparent 70%);
            top: -80px; right: -50px;
            animation: float 20s ease-in-out infinite;
        }
        .planet-2 {
            width: 180px; height: 180px;
            background: radial-gradient(circle at 30% 30%, #c9a84c, transparent 70%);
            bottom: 15%; left: -50px;
            animation: float 25s ease-in-out infinite reverse;
        }
        @keyframes float {
            0%, 100% { transform: translate(0,0) rotate(0deg); }
            33%       { transform: translate(20px,-20px) rotate(120deg); }
            66%       { transform: translate(-15px,15px) rotate(240deg); }
        }

        /* ── Contenedor ── */
        .container {
            width: min(950px, 100%);
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        /* ── Nav ── */
        .top-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
        }
        .nav-logo {
            font-family: 'Cinzel', serif;
            font-size: 0.85rem;
            letter-spacing: 0.25em;
            color: var(--gold);
            text-decoration: none;
            text-transform: uppercase;
        }
        .nav-back {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--soft);
            text-decoration: none;
            font-size: 0.82rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            transition: color 0.3s;
        }
        .nav-back::before { content: "←"; }
        .nav-back:hover { color: var(--gold); }

        /* ── Panel principal ── */
        .panel {
            background: linear-gradient(135deg, rgba(13,16,51,0.7), rgba(7,9,26,0.85));
            border: 1px solid var(--border);
            border-radius: 4px;
            box-shadow: 0 0 0 1px rgba(201,168,76,0.06), 0 40px 80px rgba(0,0,0,0.7);
            padding: 2.5rem 2rem;
            backdrop-filter: blur(16px);
            animation: fadeInUp 1s ease both;
            position: relative;
            overflow: hidden;
        }

        /* Línea dorada superior */
        .panel::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }

        /* Ornamento superior */
        .panel-ornament {
            text-align: center;
            font-family: 'Cinzel', serif;
            font-size: 0.65rem;
            letter-spacing: 0.5em;
            color: var(--gold-dim);
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }

        h1 {
            font-family: 'Cinzel', serif;
            font-size: clamp(1.8rem, 2vw + 1rem, 2.8rem);
            font-weight: 900;
            letter-spacing: 0.05em;
            margin-bottom: 0.6rem;
            background: linear-gradient(135deg, var(--gold-bright), var(--gold), var(--gold-dim));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            filter: drop-shadow(0 0 20px rgba(201,168,76,0.3));
            text-align: center;
        }

        .subtitle {
            color: var(--soft);
            font-size: 0.9rem;
            line-height: 1.6;
            text-align: center;
            margin-bottom: 2rem;
        }

        /* Divisor dorado */
        .divider {
            height: 1px;
            background: linear-gradient(to right, transparent, var(--gold-dim), transparent);
            margin: 1.5rem 0;
        }

        /* ── Controles ── */
        .header-controls {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            align-items: start;
        }

        .controls-group {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .control-item {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .control-item label {
            font-family: 'Cinzel', serif;
            font-size: 0.65rem;
            letter-spacing: 0.2em;
            color: var(--gold-dim);
            text-transform: uppercase;
        }

        .control-item select {
            padding: 0.55rem 0.9rem;
            border: 1px solid rgba(201,168,76,0.3);
            border-radius: 2px;
            background: rgba(201,168,76,0.06);
            color: var(--white);
            font-family: 'Raleway', sans-serif;
            font-size: 0.9rem;
            min-width: 170px;
            cursor: pointer;
            outline: none;
            transition: border-color 0.3s;
        }
        .control-item select:focus { border-color: var(--gold); }
        .control-item select option { background: var(--navy); }

        /* Tarjeta de referencia */
        .reference-card {
            background: rgba(2,3,15,0.6);
            border: 1px solid var(--gold);
            border-radius: 2px;
            padding: 0.75rem;
            text-align: center;
            min-width: 130px;
            box-shadow: var(--glow-gold);
        }

        .reference-card span {
            display: block;
            font-family: 'Cinzel', serif;
            font-size: 0.6rem;
            letter-spacing: 0.2em;
            color: var(--gold);
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }

        .reference-image {
            width: 110px;
            height: 110px;
            border-radius: 2px;
            object-fit: cover;
            border: 1px solid rgba(201,168,76,0.3);
        }

        /* ── HUD ── */
        .hud {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .chip {
            border-radius: 2px;
            padding: 0.45rem 1rem;
            font-size: 0.85rem;
            border: 1px solid rgba(201,168,76,0.2);
            background: rgba(201,168,76,0.05);
            color: var(--soft);
            letter-spacing: 0.05em;
        }

        .chip strong { color: var(--gold-bright); font-family: 'Cinzel', serif; }

        .chip.timer {
            background: rgba(201,168,76,0.08);
            border-color: rgba(201,168,76,0.35);
            font-family: "Courier New", monospace;
            color: var(--gold);
        }

        /* ── Tablero ── */
        .board-wrapper {
            display: flex;
            justify-content: center;
            margin: 1.5rem 0;
        }

        .board {
            display: grid;
            gap: 4px;
            padding: 1rem;
            background: rgba(2,3,15,0.5);
            border: 1px solid rgba(201,168,76,0.15);
            border-radius: 2px;
            box-shadow: inset 0 0 40px rgba(0,0,0,0.5);
        }

        .board.size-3 { grid-template-columns: repeat(3, 1fr); width: min(420px, 90vw); }
        .board.size-4 { grid-template-columns: repeat(4, 1fr); width: min(520px, 90vw); }
        .board.size-5 { grid-template-columns: repeat(5, 1fr); width: min(560px, 90vw); }

        .piece {
            aspect-ratio: 1/1;
            border: 1px solid rgba(201,168,76,0.3);
            border-radius: 2px;
            background-repeat: no-repeat;
            background-color: rgba(201,168,76,0.04);
            cursor: pointer;
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .piece:hover {
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 8px 20px rgba(201,168,76,0.3);
            border-color: var(--gold);
            z-index: 2;
        }

        .piece.correct {
            border-color: #2dd4bf;
            box-shadow: 0 0 0 2px rgba(45,212,191,0.2) inset;
        }

        .empty {
            aspect-ratio: 1/1;
            border: 1px dashed rgba(201,168,76,0.15);
            border-radius: 2px;
            background: rgba(201,168,76,0.02);
        }

        /* ── Acciones ── */
        .actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            border: none;
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--void);
            background: linear-gradient(135deg, var(--gold-bright), var(--gold));
            padding: 0.75rem 1.5rem;
            border-radius: 2px;
            cursor: pointer;
            transition: transform 0.2s ease, filter 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 15px rgba(201,168,76,0.3);
        }
        .btn:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
            box-shadow: 0 8px 25px rgba(201,168,76,0.5);
        }
        .btn:disabled {
            opacity: 0.35;
            cursor: not-allowed;
            transform: none;
            filter: none;
            box-shadow: none;
        }

        .btn-reset {
            border: none;
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--void);
            background: linear-gradient(135deg, #00e5ff, #0099cc);
            padding: 0.75rem 1.5rem;
            border-radius: 2px;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 15px rgba(0,229,255,0.3);
        }
        .btn-reset:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,229,255,0.5);
        }
        .btn-reset:disabled {
            opacity: 0.35;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-outline {
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--soft);
            border: 1px solid rgba(201,168,76,0.3);
            background: transparent;
            padding: 0.72rem 1.4rem;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .btn-outline:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(201,168,76,0.06);
        }
        .btn-outline:disabled {
            opacity: 0.35;
            cursor: not-allowed;
        }

        /* ── Status ── */
        .status-bar {
            margin-top: 1.2rem;
            border-radius: 2px;
            padding: 0.7rem 1rem;
            border-left: 2px solid;
            font-size: 0.85rem;
            letter-spacing: 0.03em;
        }
        .status-bar.pending {
            background: var(--warn-bg);
            border-color: var(--warn-border);
            color: #fde68a;
        }
        .status-bar.ok {
            background: var(--ok-bg);
            border-color: var(--ok-border);
            color: #99f6e4;
        }
        .status-bar.error {
            background: var(--error-bg);
            border-color: var(--error-border);
            color: #fca5a5;
        }

        .image-status {
            margin-top: 0.75rem;
            border-radius: 2px;
            padding: 0.7rem 1rem;
            border: 1px solid rgba(201,168,76,0.2);
            background: rgba(201,168,76,0.05);
            font-size: 0.85rem;
            color: var(--soft);
        }
        .image-status.ok {
            border-color: rgba(45,212,191,0.4);
            background: rgba(45,212,191,0.05);
            color: #99f6e4;
        }

        /* ── Animaciones ── */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Footer ── */
        .panel-footer {
            text-align: center;
            margin-top: 2rem;
            font-family: 'Cinzel', serif;
            font-size: 0.6rem;
            letter-spacing: 0.3em;
            color: var(--gold-dim);
            text-transform: uppercase;
        }

        /* ── Responsive ── */
        @media (max-width: 640px) {
            .header-controls { grid-template-columns: 1fr; }
            .controls-group  { justify-content: center; }
            .reference-card  { margin: 0 auto; }
        }
    </style>
</head>
<body>

    <canvas id="starfield"></canvas>
    <div class="planet planet-1"></div>
    <div class="planet planet-2"></div>

    <main class="container">

        <!-- Nav -->
        <nav class="top-nav">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-logo">Museo del Espacio</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-back">Volver al Inicio</a>
        </nav>

        <section class="panel">
            <div class="panel-ornament">✦ Sala de Juegos · Ala Cósmica ✦</div>

            <h1>Rompecabezas Espacial</h1>
            <p class="subtitle">
                Ensambla espectaculares imágenes del universo.
                <strong style="color:var(--gold);">Consejo:</strong> Usa la vista de referencia para guiarte.
            </p>

            <div class="divider"></div>

            <!-- Controles -->
            <div class="header-controls">
                <div class="controls-group">
                    <div class="control-item">
                        <label for="puzzle-select">Imagen Cósmica</label>
                        <select id="puzzle-select">
                            <option value="">Cargando imágenes...</option>
                        </select>
                    </div>
                    <div class="control-item">
                        <label for="difficulty-select">Nivel de Misión</label>
                        <select id="difficulty-select">
                            <option value="3">Fácil — 3×3</option>
                            <option value="4" selected>Normal — 4×4</option>
                            <option value="5">Difícil — 5×5</option>
                        </select>
                    </div>
                </div>

                <div class="reference-card">
                    <span>Referencia</span>
                    <img id="reference-img" class="reference-image"
                         src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect fill='%2302030f' width='100' height='100'/%3E%3Ctext x='50' y='55' text-anchor='middle' fill='%237a5f28' font-size='9' font-family='serif'%3ESin imagen%3C/text%3E%3C/svg%3E"
                         alt="Vista previa">
                </div>
            </div>

            <!-- HUD -->
            <div class="hud">
                <span class="chip">Movimientos: <strong id="moves">0</strong></span>
                <span class="chip timer">Tiempo: <strong id="timer">00:00</strong></span>
                <span class="chip">Estado: <strong id="game-state">Selecciona imagen</strong></span>
            </div>

            <!-- Tablero -->
            <div class="board-wrapper">
                <div class="board size-4" id="board"></div>
            </div>

            <!-- Acciones -->
            <div class="actions">
                <button class="btn"         id="shuffle-btn" type="button" disabled>Mezclar</button>
                <button class="btn-reset"   id="reset-btn"   type="button" disabled>Reiniciar</button>
                <button class="btn-outline" id="pause-btn"   type="button" disabled>Pausar</button>
                <a class="btn-outline" href="${pageContext.request.contextPath}/index.jsp">← Inicio</a>
            </div>

            <div class="divider" style="margin-top:1.5rem;"></div>

            <p id="service-status" class="status-bar pending">Verificando conexión al servidor...</p>
            <p id="image-status"   class="image-status">Buscando imágenes...</p>

            <div class="panel-footer">✦ Museo del Espacio · Rompecabezas Cósmico ✦</div>
        </section>
    </main>

    <script>
        /* ── Fondo estrellado (igual que index y recorrido) ── */
        (function initStars() {
            const canvas = document.getElementById("starfield");
            const ctx    = canvas.getContext("2d");
            let stars    = [];
            function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
            function createStars(n) {
                stars = [];
                for (let i = 0; i < n; i++) {
                    stars.push({
                        x: Math.random() * canvas.width,
                        y: Math.random() * canvas.height,
                        r: Math.random() * 1.4,
                        a: Math.random(),
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

        /* ── Configuración ── */
        const contextPath = "<%= request.getContextPath() %>";
        const serviceUrl  = contextPath + "/resources/jakartaee11";

        let boardSize       = 4;
        let totalTiles      = boardSize * boardSize;
        let solvedState     = [];
        let state           = [];
        let moves           = 0;
        let gameReady       = false;
        let gameStarted     = false;
        let gamePaused      = false;
        let timerInterval   = null;
        let secondsElapsed  = 0;
        let resolvedImagePath = null;
        let availableImages = [];

        const boardEl         = document.getElementById("board");
        const movesEl         = document.getElementById("moves");
        const timerEl         = document.getElementById("timer");
        const gameStateEl     = document.getElementById("game-state");
        const shuffleBtn      = document.getElementById("shuffle-btn");
        const resetBtn        = document.getElementById("reset-btn");
        const pauseBtn        = document.getElementById("pause-btn");
        const puzzleSelect    = document.getElementById("puzzle-select");
        const difficultySelect= document.getElementById("difficulty-select");
        const referenceImg    = document.getElementById("reference-img");
        const serviceStatusEl = document.getElementById("service-status");
        const imageStatusEl   = document.getElementById("image-status");

        function uniqueValues(values) { return Array.from(new Set(values)); }

        function formatTime(s) {
            return String(Math.floor(s/60)).padStart(2,"0") + ":" + String(s%60).padStart(2,"0");
        }

        function startTimer() {
            if (timerInterval) clearInterval(timerInterval);
            gameStarted = true; gamePaused = false;
            pauseBtn.textContent = "Pausar";
            timerInterval = setInterval(() => {
                if (!gamePaused && gameStarted) { secondsElapsed++; timerEl.textContent = formatTime(secondsElapsed); }
            }, 1000);
        }

        function stopTimer() {
            if (timerInterval) clearInterval(timerInterval);
            timerInterval = null; gameStarted = false; gamePaused = false;
        }

        function resetTimer() { stopTimer(); secondsElapsed = 0; timerEl.textContent = "00:00"; }

        function generateSolvedState(size) {
            const arr = [];
            for (let i = 1; i < size*size; i++) arr.push(i);
            arr.push(0);
            return arr;
        }

        /**
         * Carga las imágenes locales disponibles en /imagen/espacio/
         * verificando que cada archivo exista y sea una imagen válida.
         */
        async function fetchAvailableImages() {
            const predefined = [
                { name: "Luna",     file: "luna.png",     category: "Satélite"      },
                { name: "Saturno",  file: "saturno.png",  category: "Planeta"       },
                { name: "Tierra",   file: "tierra.png",   category: "Planeta"       },
                { name: "Sol",      file: "sol.png",       category: "Estrella"     },
                { name: "Nebulosa", file: "nebulosa.jpg", category: "Nebulosa"      },
                { name: "Galaxia",  file: "galaxia.png",  category: "Galaxia"       },
                { name: "Satélite", file: "satelite.png", category: "Tecnología"    },
                { name: "Cohete",   file: "cohete.png",   category: "Exploración"   },
                { name: "Cometa",   file: "cometa.jpg",   category: "C. Celeste"    },
                { name: "Estrella", file: "estrella.jpg", category: "Estrella"      }
            ];

            const available = [];
            const ts = Date.now();

            for (const img of predefined) {
                const candidates = uniqueValues([
                    contextPath + "/imagen/espacio/" + img.file + "?v=" + ts,
                    contextPath + "/imagen/espacio/" + img.file.toLowerCase() + "?v=" + ts
                ]);
                for (const candidate of candidates) {
                    try {
                        const res = await fetch(candidate, { method: "GET", cache: "no-cache" });
                        if (res.ok) {
                            const ct = res.headers.get("content-type");
                            if (ct && ct.startsWith("image/")) {
                                available.push({ ...img, path: candidate.split("?")[0] });
                                break;
                            }
                        }
                    } catch(e) { /* imagen no disponible */ }
                }
            }
            return available;
        }

        function populateImageSelector(images) {
            puzzleSelect.innerHTML = "";
            const def = document.createElement("option");
            def.value = ""; def.textContent = "— Selecciona una imagen —";
            puzzleSelect.appendChild(def);

            images.forEach(img => {
                const opt = document.createElement("option");
                opt.value = img.path;
                opt.textContent = img.name + " · " + img.category;
                puzzleSelect.appendChild(opt);
            });

            if (images.length === 0) {
                imageStatusEl.textContent = "No se encontraron imágenes en /imagen/espacio/";
                imageStatusEl.className = "image-status";
            } else {
                imageStatusEl.textContent = "✦ " + images.length + " imágenes cargadas correctamente";
                imageStatusEl.className = "image-status ok";
            }
        }

        function updateBoardConfig(newSize) {
            stopTimer(); resetTimer();
            gameReady = false; gameStarted = false;
            boardSize  = parseInt(newSize);
            totalTiles = boardSize * boardSize;
            solvedState = generateSolvedState(boardSize);
            state = solvedState.slice();
            moves = 0; movesEl.textContent = "0";
            boardEl.className = "board size-" + boardSize;
            gameStateEl.textContent = resolvedImagePath ? "Listo para despegar" : "Selecciona imagen";
            gameStateEl.style.color = "var(--gold)";
            shuffleBtn.disabled = !resolvedImagePath;
            resetBtn.disabled   = !resolvedImagePath;
            pauseBtn.disabled   = true;
            pauseBtn.textContent = "Pausar";
            renderBoard();
        }

        function preloadImage(src, timeout) {
            return new Promise((resolve, reject) => {
                const img = new Image();
                let timedOut = false;
                const timer = setTimeout(() => { timedOut = true; reject(new Error("Timeout")); }, timeout || 5000);
                img.onload  = () => { if (!timedOut) { clearTimeout(timer); resolve(img); } };
                img.onerror = () => { if (!timedOut) { clearTimeout(timer); reject(new Error("Error cargando")); } };
                img.crossOrigin = "anonymous";
                img.src = src;
            });
        }

        async function changePuzzle(imagePath) {
            if (!imagePath) {
                gameReady = false;
                shuffleBtn.disabled = resetBtn.disabled = pauseBtn.disabled = true;
                gameStateEl.textContent = "Selecciona una imagen";
                referenceImg.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect fill='%2302030f' width='100' height='100'/%3E%3Ctext x='50' y='55' text-anchor='middle' fill='%237a5f28' font-size='9' font-family='serif'%3ESin imagen%3C/text%3E%3C/svg%3E";
                renderBoard(); return;
            }
            try {
                await preloadImage(imagePath + "?v=" + Date.now(), 5000);
                resolvedImagePath = imagePath;
                referenceImg.src  = imagePath;
                referenceImg.alt  = puzzleSelect.options[puzzleSelect.selectedIndex].text;
                state = solvedState.slice(); moves = 0; movesEl.textContent = "0";
                resetTimer();
                gameStateEl.textContent = "Listo para despegar";
                gameStateEl.style.color = "var(--gold)";
                renderBoard();
                gameReady = true;
                shuffleBtn.disabled = resetBtn.disabled = false;
                pauseBtn.disabled = true;
                imageStatusEl.textContent = "✦ " + puzzleSelect.options[puzzleSelect.selectedIndex].text + " cargada";
                imageStatusEl.className = "image-status ok";
            } catch(err) {
                resolvedImagePath = null;
                imageStatusEl.textContent = "Error al cargar la imagen. Intenta de nuevo.";
                imageStatusEl.className = "image-status";
            }
        }

        function tileToPosition(value) {
            const index = value - 1;
            return { row: Math.floor(index / boardSize), col: index % boardSize };
        }

        function renderBoard() {
            boardEl.innerHTML = "";
            state.forEach((value, tileIndex) => {
                if (value === 0) {
                    const empty = document.createElement("div");
                    empty.className = "empty";
                    boardEl.appendChild(empty);
                    return;
                }
                const pos  = tileToPosition(value);
                const tile = document.createElement("button");
                tile.type  = "button";
                tile.className = "piece";
                tile.setAttribute("aria-label", "Mover pieza " + value);

                if (resolvedImagePath) {
                    const bgX  = (pos.col / (boardSize - 1)) * 100;
                    const bgY  = (pos.row / (boardSize - 1)) * 100;
                    const bgSz = boardSize * 100;
                    tile.style.backgroundImage    = "url('" + resolvedImagePath + "?v=" + Date.now() + "')";
                    tile.style.backgroundSize     = bgSz + "% " + bgSz + "%";
                    tile.style.backgroundPosition = bgX + "% " + bgY + "%";
                    if (state[tileIndex] === solvedState[tileIndex]) tile.classList.add("correct");
                } else {
                    tile.textContent = String(value);
                    tile.style.color = "var(--gold)";
                    tile.style.fontFamily = "Cinzel, serif";
                    tile.style.fontSize   = "1.1rem";
                    tile.style.display    = "flex";
                    tile.style.alignItems = "center";
                    tile.style.justifyContent = "center";
                }

                tile.addEventListener("click", () => moveTile(tileIndex));
                boardEl.appendChild(tile);
            });
        }

        function canMove(from, empty) {
            const fr = Math.floor(from/boardSize),  fc = from%boardSize;
            const er = Math.floor(empty/boardSize), ec = empty%boardSize;
            return Math.abs(fr-er) + Math.abs(fc-ec) === 1;
        }

        function moveTile(tileIndex) {
            if (!gameReady || gamePaused) return;
            if (!gameStarted) startTimer();
            const emptyIndex = state.indexOf(0);
            if (!canMove(tileIndex, emptyIndex)) return;
            [state[tileIndex], state[emptyIndex]] = [state[emptyIndex], state[tileIndex]];
            moves++; movesEl.textContent = String(moves);
            renderBoard();
            if (isSolved()) onGameComplete();
        }

        function isSolved() {
            return state.every((v, i) => v === solvedState[i]);
        }

        function onGameComplete() {
            stopTimer();
            gameStateEl.textContent = "¡Misión Cumplida!";
            gameStateEl.style.color = "#2dd4bf";
            setTimeout(() => {
                alert("✦ ¡Felicidades!\n\nTiempo: " + formatTime(secondsElapsed) +
                      "\nMovimientos: " + moves +
                      "\nDificultad: " + boardSize + "×" + boardSize);
            }, 600);
        }

        function shuffleBoard() {
            state = solvedState.slice();
            let emptyIndex = state.indexOf(0);
            const steps = boardSize === 3 ? 100 : boardSize === 4 ? 200 : 350;
            for (let i = 0; i < steps; i++) {
                const candidates = state.map((_,idx) => idx).filter(idx => canMove(idx, emptyIndex));
                if (!candidates.length) break;
                const chosen = candidates[Math.floor(Math.random() * candidates.length)];
                [state[chosen], state[emptyIndex]] = [state[emptyIndex], state[chosen]];
                emptyIndex = chosen;
            }
            moves = 0; movesEl.textContent = "0";
            resetTimer();
            gameStateEl.textContent = "Jugando";
            gameStateEl.style.color = "var(--gold)";
            gameReady = true;
            pauseBtn.disabled = false;
            renderBoard();
        }

        function resetGame() {
            if (!resolvedImagePath) return;
            state = solvedState.slice(); moves = 0; movesEl.textContent = "0";
            resetTimer();
            gameStateEl.textContent = "Listo para despegar";
            gameStateEl.style.color = "var(--gold)";
            gamePaused = false; pauseBtn.textContent = "Pausar"; pauseBtn.disabled = true;
            renderBoard();
        }

        function togglePause() {
            if (!gameReady || !gameStarted) return;
            if (gamePaused) {
                gamePaused = false; pauseBtn.textContent = "Pausar";
                gameStateEl.textContent = "Jugando";
            } else {
                gamePaused = true; pauseBtn.textContent = "Continuar";
                gameStateEl.textContent = "En pausa";
            }
        }

        /**
         * Servicio 1: JakartaEE11Resource
         * Verifica que el servidor Jakarta EE esté activo.
         */
        async function verifyService() {
            const candidates = uniqueValues([serviceUrl, window.location.origin + serviceUrl]);
            for (const url of candidates) {
                try {
                    const res = await fetch(url, { method: "GET", credentials: "same-origin" });
                    if (res.ok) {
                        serviceStatusEl.className = "status-bar ok";
                        serviceStatusEl.textContent = "✦ Conexión establecida con el servidor";
                        return;
                    }
                } catch(e) { /* intentar siguiente */ }
            }
            serviceStatusEl.className = "status-bar pending";
            serviceStatusEl.textContent = "Modo offline — Funcionalidad local activa";
        }

        /* ── Eventos ── */
        puzzleSelect.addEventListener("change",    e => changePuzzle(e.target.value));
        shuffleBtn.addEventListener("click",       shuffleBoard);
        resetBtn.addEventListener("click",         resetGame);
        pauseBtn.addEventListener("click",         togglePause);
        difficultySelect.addEventListener("change", e => {
            if (gameStarted && moves > 0) {
                if (!confirm("Cambiar la dificultad reiniciará tu progreso.\n\n¿Continuar?")) {
                    difficultySelect.value = boardSize; return;
                }
            }
            updateBoardConfig(e.target.value);
        });

        /* ── Inicialización ── */
        (async function init() {
            availableImages = await fetchAvailableImages();
            populateImageSelector(availableImages);
            updateBoardConfig(difficultySelect.value);
            await verifyService();
        })();
    </script>
</body>
</html>
