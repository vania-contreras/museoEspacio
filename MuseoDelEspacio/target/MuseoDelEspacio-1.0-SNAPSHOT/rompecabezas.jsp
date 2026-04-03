<%-- 
    Document   : rompecabezas
    Created on : 1 abr. 2026, 20:12:16
    Author     : vania

    Descripción:
    Sala de juegos interactiva del Museo del Espacio.
    El jugador arma un rompecabezas deslizante (estilo 15-puzzle)
    con imágenes del cosmos.

    Servicios reutilizados en esta página:
      1. NASA APOD API (https://api.nasa.gov/planetary/apod)
         → Se consulta al pulsar "Cargar imagen NASA" para obtener
           la imagen astronómica del día y usarla como pieza del rompecabezas.
         → DEMO_KEY: 30 req/hora sin registro.

      2. JakartaEE11Resource (/resources/jakartaee11)
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
    <style>
        :root {
            --space-deep: #0a0e27;
            --space-navy: #1a1f4d;
            --space-purple: #2d1b69;
            --nebula-pink: #ff006e;
            --nebula-blue: #00f5ff;
            --nebula-purple: #8338ec;
            --star-white: #ffffff;
            --surface: rgba(255, 255, 255, 0.05);
            --text-main: #e0e7ff;
            --text-soft: #a5b4fc;
            --accent: #00f5ff;
            --accent-2: #ff006e;
            --ok-bg: rgba(16, 185, 129, 0.2);
            --ok-border: rgba(16, 185, 129, 0.55);
            --warn-bg: rgba(245, 158, 11, 0.2);
            --warn-border: rgba(245, 158, 11, 0.55);
            --error-bg: rgba(239, 68, 68, 0.2);
            --error-border: rgba(239, 68, 68, 0.55);
            --radius: 20px;
            --shadow: 0 20px 60px rgba(0, 245, 255, 0.15);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

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

        .stars, .stars2, .stars3 {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .stars {
            background-image: 
                radial-gradient(2px 2px at 20px 30px, var(--star-white), transparent),
                radial-gradient(2px 2px at 40px 70px, rgba(255,255,255,0.8), transparent);
            background-repeat: repeat;
            background-size: 350px 200px;
            animation: twinkle 5s ease-in-out infinite;
            opacity: 0.6;
        }

        .stars2 {
            background-image: 
                radial-gradient(2px 2px at 50px 100px, var(--nebula-blue), transparent),
                radial-gradient(1px 1px at 120px 60px, var(--star-white), transparent);
            background-repeat: repeat;
            background-size: 400px 250px;
            animation: twinkle 7s ease-in-out infinite reverse;
            opacity: 0.4;
        }

        .stars3 {
            background-image: 
                radial-gradient(1px 1px at 80px 150px, var(--nebula-pink), transparent);
            background-repeat: repeat;
            background-size: 300px 200px;
            animation: twinkle 6s ease-in-out infinite;
            opacity: 0.3;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0.3; transform: translateY(0); }
            50% { opacity: 0.7; transform: translateY(-10px); }
        }

        .container {
            width: min(950px, 100%);
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        .panel {
            background: var(--surface);
            border: 1px solid rgba(0, 245, 255, 0.2);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 2rem;
            backdrop-filter: blur(12px);
            animation: fadeInUp 1s ease both;
        }

        h1 {
            margin-bottom: 0.8rem;
            font-size: clamp(1.8rem, 2vw + 1rem, 2.5rem);
            background: linear-gradient(135deg, var(--star-white), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        p { color: var(--text-soft); margin-bottom: 1rem; line-height: 1.6; }

        .header-controls {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 1rem;
            margin-bottom: 1rem;
            align-items: start;
        }

        .controls-group {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .control-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .control-item label {
            font-size: 0.85rem;
            color: var(--text-soft);
            font-weight: 600;
        }

        .control-item select {
            padding: 0.5rem 0.75rem;
            border-radius: 10px;
            border: 1px solid rgba(0, 245, 255, 0.3);
            background: rgba(0, 245, 255, 0.1);
            color: var(--text-main);
            font-size: 0.95rem;
            min-width: 160px;
            cursor: pointer;
        }

        .control-item select option {
            background: var(--space-navy);
            color: var(--text-main);
        }

        .reference-card {
            background: rgba(0, 0, 0, 0.4);
            border: 2px solid var(--accent);
            border-radius: 16px;
            padding: 0.6rem;
            text-align: center;
            min-width: 130px;
        }

        .reference-card span {
            display: block;
            font-size: 0.75rem;
            color: var(--text-soft);
            margin-bottom: 0.4rem;
        }

        .reference-image {
            width: 110px;
            height: 110px;
            border-radius: 12px;
            object-fit: cover;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .hud {
            display: flex;
            gap: 0.7rem;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .chip {
            border-radius: 999px;
            padding: 0.4rem 0.85rem;
            font-weight: 700;
            font-size: 0.9rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        .chip strong { color: var(--accent); }

        .chip.timer {
            background: rgba(0, 245, 255, 0.15);
            border-color: var(--accent);
            font-family: "Courier New", monospace;
        }

        .board {
            display: grid;
            gap: 0.5rem;
            margin: 1.5rem auto;
            width: min(540px, 100%);
            padding: 1rem;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 16px;
            border: 1px solid rgba(0, 245, 255, 0.15);
        }

        .piece {
            aspect-ratio: 1 / 1;
            border-radius: 10px;
            border: 2px solid rgba(0, 245, 255, 0.3);
            background-repeat: no-repeat;
            background-color: rgba(255, 255, 255, 0.06);
            cursor: pointer;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .piece:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 10px 25px rgba(0, 245, 255, 0.3);
            border-color: var(--accent);
            z-index: 2;
        }

        .piece.correct {
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.25) inset;
        }

        .empty {
            aspect-ratio: 1 / 1;
            border-radius: 10px;
            border: 2px dashed rgba(0, 245, 255, 0.3);
            background: rgba(0, 245, 255, 0.05);
        }

        .actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 0.7rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            border: none;
            color: var(--space-deep);
            background: linear-gradient(135deg, var(--accent), var(--nebula-blue));
            font-weight: 700;
            padding: 0.75rem 1.25rem;
            border-radius: 12px;
            cursor: pointer;
            transition: transform 0.2s ease, filter 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .btn-reset {
            border: none;
            color: var(--space-deep);
            background: linear-gradient(135deg, var(--accent-2), #fb5607);
            font-weight: 700;
            padding: 0.75rem 1.25rem;
            border-radius: 12px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .btn-reset:hover {
            transform: translateY(-3px);
        }

        .btn-reset:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .btn-outline {
            color: var(--text-main);
            border: 2px solid rgba(0, 245, 255, 0.4);
            background: transparent;
            padding: 0.7rem 1.2rem;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        .btn-outline:hover {
            background: rgba(0, 245, 255, 0.15);
            border-color: var(--accent);
        }

        .service-status, .image-status {
            margin-top: 1.2rem;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            border: 1px solid transparent;
            color: var(--text-soft);
            font-size: 0.9rem;
        }

        .service-status.pending { background: var(--warn-bg); border-color: var(--warn-border); }
        .service-status.ok { background: var(--ok-bg); border-color: var(--ok-border); color: #d1fae5; }
        .image-status {
            border: 1px solid rgba(0, 245, 255, 0.25);
            background: rgba(0, 245, 255, 0.08);
        }

        .image-status.ok {
            border-color: #10b981;
            background: rgba(16, 185, 129, 0.15);
            color: #d1fae5;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 640px) {
            .header-controls {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .controls-group {
                justify-content: center;
            }
            .reference-card {
                margin: 0 auto;
            }
            .board {
                gap: 0.3rem;
                width: min(95vw, 100%);
                padding: 0.5rem;
            }
        }

        .board.size-3 { grid-template-columns: repeat(3, 1fr); }
        .board.size-4 { grid-template-columns: repeat(4, 1fr); }
        .board.size-5 { grid-template-columns: repeat(5, 1fr); }
    </style>
</head>
<body>
    <div class="stars"></div>
    <div class="stars2"></div>
    <div class="stars3"></div>

    <main class="container">
        <section class="panel">
            <h1>Rompecabezas Espacial</h1>
            <p>
                Ensambla espectaculares imagenes del universo. 
                <strong>Consejo:</strong> Usa la vista de referencia para guiarte.
            </p>

            <div class="header-controls">
                <div class="controls-group">
                    <div class="control-item">
                        <label for="puzzle-select">Imagen Cosmica:</label>
                        <select id="puzzle-select">
                            <option value="">Cargando imagenes...</option>
                        </select>
                    </div>
                    
                    <div class="control-item">
                        <label for="difficulty-select">Nivel de Mision:</label>
                        <select id="difficulty-select">
                            <option value="3">Facil (3x3)</option>
                            <option value="4" selected>Normal (4x4)</option>
                            <option value="5">Dificil (5x5)</option>
                        </select>
                    </div>
                    <!-- Botón Servicio 1: NASA APOD API -->
                    <div class="control-item">
                        <label>Imagen real NASA</label>
                        <button class="btn" id="btn-nasa-apod" type="button"
                                title="Cargar imagen astronómica del día desde la NASA APOD API"
                                style="white-space:nowrap;background:linear-gradient(135deg,#fb5607,#ff006e);">
                            🛸 Cargar NASA APOD
                        </button>
                    </div>
                </div>
                
                <div class="reference-card">
                    <span>Referencia</span>
                    <img id="reference-img" class="reference-image" 
                         src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect fill='%231a1f4d' width='100' height='100'/%3E%3Ctext x='50' y='55' text-anchor='middle' fill='%23a5b4fc' font-size='10'%3ESin imagen%3C/text%3E%3C/svg%3E" 
                         alt="Vista previa">
                </div>
            </div>

            <div class="hud">
                <span class="chip">Movimientos: <strong id="moves">0</strong></span>
                <span class="chip timer">Tiempo: <strong id="timer">00:00</strong></span>
                <span class="chip">Estado: <strong id="game-state">Selecciona imagen</strong></span>
            </div>

            <div class="board size-4" id="board"></div>

            <div class="actions">
                <button class="btn" id="shuffle-btn" type="button" disabled>Mezclar</button>
                <button class="btn-reset" id="reset-btn" type="button" disabled>Reiniciar</button>
                <button class="btn-outline" id="pause-btn" type="button" disabled>Pausar</button>
                <a class="btn-outline" href="${pageContext.request.contextPath}/index.jsp">Inicio</a>
            </div>

            <p id="service-status" class="service-status pending">Verificando conexion...</p>
            <p id="image-status" class="image-status">Buscando imagenes...</p>
            <!-- Estado Servicio 1: NASA APOD -->
            <p id="nasa-status" class="image-status" style="display:none;"></p>
        </section>
    </main>

    <script>
        const contextPath = "<%= request.getContextPath() %>";
        const serviceUrl = contextPath + "/resources/jakartaee11";
        const imagesFolder = contextPath + "/imagen/espacio/";
        
        let boardSize = 4;
        let totalTiles = boardSize * boardSize;
        let solvedState = [];
        let state = [];
        let moves = 0;
        let gameReady = false;
        let gameStarted = false;
        let gamePaused = false;
        let timerInterval = null;
        let secondsElapsed = 0;
        let resolvedImagePath = null;
        let availableImages = [];

        const boardEl = document.getElementById("board");
        const movesEl = document.getElementById("moves");
        const timerEl = document.getElementById("timer");
        const gameStateEl = document.getElementById("game-state");
        const shuffleBtn = document.getElementById("shuffle-btn");
        const resetBtn = document.getElementById("reset-btn");
        const pauseBtn = document.getElementById("pause-btn");
        const puzzleSelect = document.getElementById("puzzle-select");
        const difficultySelect = document.getElementById("difficulty-select");
        const referenceImg = document.getElementById("reference-img");
        const serviceStatusEl = document.getElementById("service-status");
        const imageStatusEl = document.getElementById("image-status");

        function uniqueValues(values) { return Array.from(new Set(values)); }

        function formatTime(totalSeconds) {
            const m = Math.floor(totalSeconds / 60).toString().padStart(2, '0');
            const s = (totalSeconds % 60).toString().padStart(2, '0');
            return m + ":" + s;
        }

        function startTimer() {
            if (timerInterval) clearInterval(timerInterval);
            gameStarted = true;
            gamePaused = false;
            pauseBtn.textContent = "Pausar";
            
            timerInterval = setInterval(() => {
                if (!gamePaused && gameStarted) {
                    secondsElapsed++;
                    timerEl.textContent = formatTime(secondsElapsed);
                }
            }, 1000);
        }

        function pauseTimer() {
            gamePaused = true;
            pauseBtn.textContent = "Continuar";
        }

        function resumeTimer() {
            gamePaused = false;
            pauseBtn.textContent = "Pausar";
        }

        function stopTimer() {
            if (timerInterval) clearInterval(timerInterval);
            timerInterval = null;
            gameStarted = false;
            gamePaused = false;
        }

        function resetTimer() {
            stopTimer();
            secondsElapsed = 0;
            timerEl.textContent = "00:00";
        }

        function generateSolvedState(size) {
            const total = size * size;
            const arr = [];
            for (let i = 1; i < total; i++) arr.push(i);
            arr.push(0);
            return arr;
        }

        async function fetchAvailableImages() {
            const predefinedImages = [
                { name: "Luna", file: "luna.png", category: "Satelite" },
                { name: "Saturno", file: "saturno.png", category: "Planeta" },
                { name: "Tierra", file: "tierra.png", category: "Planeta" },
                { name: "Sol", file: "sol.png", category: "Estrella" },
                { name: "Nebulosa", file: "nebulosa.jpg", category: "Nebulosa" },
                { name: "Galaxia", file: "galaxia.png", category: "Galaxia" },
                { name: "Satelite", file: "satelite.png", category: "Tecnologia" },
                { name: "Cohete", file: "cohete.png", category: "Exploracion" },
                { name: "Cometa", file: "cometa.jpg", category: "Cuerpo Celeste" },
                { name: "Estrella", file: "estrella.jpg", category: "Estrella" }
            ];

            const available = [];
            const timestamp = Date.now();
            
            for (const img of predefinedImages) {
                const candidates = [
                    contextPath + "/imagen/espacio/" + img.file + "?v=" + timestamp,
                    contextPath + "/imagen/espacio/" + img.file.toLowerCase() + "?v=" + timestamp,
                    "/imagen/espacio/" + img.file + "?v=" + timestamp
                ];
                
                for (const candidate of uniqueValues(candidates)) {
                    try {
                        const res = await fetch(candidate, { 
                            method: "GET",
                            cache: "no-cache"
                        });
                        
                        if (res.ok && res.status === 200) {
                            const contentType = res.headers.get('content-type');
                            if (contentType && contentType.startsWith('image/')) {
                                console.log("Imagen cargada:", img.name);
                                available.push({ 
                                    ...img, 
                                    path: candidate.split('?')[0]
                                });
                                break;
                            }
                        }
                    } catch (e) {
                        console.warn("Error cargando", img.file, ":", e.message);
                    }
                }
            }
            
            console.log("Imagenes disponibles:", available.length, "de", predefinedImages.length);
            return available;
        }

        function populateImageSelector(images) {
            puzzleSelect.innerHTML = "";
            const defaultOption = document.createElement("option");
            defaultOption.value = "";
            defaultOption.textContent = "-- Selecciona una imagen --";
            puzzleSelect.appendChild(defaultOption);
            
            images.forEach(img => {
                const option = document.createElement("option");
                option.value = img.path;
                option.textContent = img.name + " - " + img.category;
                puzzleSelect.appendChild(option);
            });
            
            if (images.length === 0) {
                const noImg = document.createElement("option");
                noImg.textContent = "No se encontraron imagenes";
                noImg.disabled = true;
                puzzleSelect.appendChild(noImg);
                imageStatusEl.textContent = "Agrega imagenes a: /imagen/espacio/";
                imageStatusEl.style.borderColor = "var(--error-border)";
            } else {
                imageStatusEl.textContent = images.length + " imagenes cargadas correctamente";
                imageStatusEl.className = "image-status ok";
            }
        }

        function updateBoardConfig(newSize) {
            stopTimer();
            resetTimer();
            gameReady = false;
            gameStarted = false;
            
            boardSize = parseInt(newSize);
            totalTiles = boardSize * boardSize;
            solvedState = generateSolvedState(boardSize);
            state = solvedState.slice();
            moves = 0;
            movesEl.textContent = "0";
            
            boardEl.className = "board size-" + boardSize;
            gameStateEl.textContent = resolvedImagePath ? "Listo para despegar" : "Selecciona imagen";
            gameStateEl.style.color = "var(--text-main)";
            
            shuffleBtn.disabled = !resolvedImagePath;
            resetBtn.disabled = !resolvedImagePath;
            pauseBtn.disabled = !resolvedImagePath || !gameStarted;
            pauseBtn.textContent = "Pausar";
            
            renderBoard();
        }

        async function changePuzzle(imagePath) {
            if (!imagePath) {
                gameReady = false;
                shuffleBtn.disabled = true;
                resetBtn.disabled = true;
                pauseBtn.disabled = true;
                gameStateEl.textContent = "Selecciona una imagen";
                referenceImg.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect fill='%231a1f4d' width='100' height='100'/%3E%3Ctext x='50' y='55' text-anchor='middle' fill='%23a5b4fc' font-size='10'%3ESin imagen%3C/text%3E%3C/svg%3E";
                renderBoard();
                return;
            }

            const timestamp = Date.now();
            const imagePathNoCache = imagePath + "?v=" + timestamp;

            try {
                const loadedImage = await preloadImage(imagePathNoCache, 5000);
                
                resolvedImagePath = imagePath;
                referenceImg.src = imagePath;
                referenceImg.alt = "Referencia: " + puzzleSelect.options[puzzleSelect.selectedIndex].text;
                
                state = solvedState.slice();
                moves = 0;
                movesEl.textContent = "0";
                resetTimer();
                
                gameStateEl.textContent = "Listo para despegar";
                renderBoard();
                
                gameReady = true;
                shuffleBtn.disabled = false;
                resetBtn.disabled = false;
                pauseBtn.disabled = true;
                
                imageStatusEl.textContent = puzzleSelect.options[puzzleSelect.selectedIndex].text + " cargada";
                imageStatusEl.className = "image-status ok";
                
                console.log("Imagen lista:", imagePath);
                
            } catch (error) {
                console.error("Error cargando imagen:", error);
                resolvedImagePath = null;
                imageStatusEl.innerHTML = "Error al cargar<br>Intenta de nuevo";
                imageStatusEl.className = "service-status error";
            }
        }

        function preloadImage(src, timeout) {
            return new Promise((resolve, reject) => {
                const img = new Image();
                let timedOut = false;
                
                const timer = setTimeout(() => {
                    timedOut = true;
                    reject(new Error('Timeout cargando imagen'));
                }, timeout || 5000);
                
                img.onload = () => {
                    if (!timedOut) {
                        clearTimeout(timer);
                        resolve(img);
                    }
                };
                
                img.onerror = () => {
                    if (!timedOut) {
                        clearTimeout(timer);
                        reject(new Error('Error cargando imagen'));
                    }
                };
                
                img.crossOrigin = "anonymous";
                img.src = src;
            });
        }

        function tileToPosition(value) {
            if (value === 0) return null;
            const index = value - 1;
            return {
                row: Math.floor(index / boardSize),
                col: index % boardSize
            };
        }

        function renderBoard() {
            boardEl.innerHTML = "";

            state.forEach((value, tileIndex) => {
                if (value === 0) {
                    const empty = document.createElement("div");
                    empty.className = "empty";
                    empty.setAttribute("aria-hidden", "true");
                    boardEl.appendChild(empty);
                    return;
                }

                const position = tileToPosition(value);
                const tile = document.createElement("button");
                tile.type = "button";
                tile.className = "piece";
                tile.title = "Mover pieza " + value;
                tile.setAttribute("aria-label", "Mover pieza " + value);

                if (resolvedImagePath) {
                    const timestamp = Date.now();
                    const bgImageSrc = resolvedImagePath + "?v=" + timestamp;
                    
                    const bgX = (position.col / (boardSize - 1)) * 100;
                    const bgY = (position.row / (boardSize - 1)) * 100;
                    const bgSize = boardSize * 100;
                    
                    tile.style.backgroundImage = "url('" + bgImageSrc + "')";
                    tile.style.backgroundSize = bgSize + "% " + bgSize + "%";
                    tile.style.backgroundPosition = bgX + "% " + bgY + "%";
                    
                    if (state[tileIndex] === solvedState[tileIndex]) {
                        tile.classList.add("correct");
                    }
                } else {
                    tile.textContent = String(value);
                }

                tile.addEventListener("click", function() { moveTile(tileIndex); });
                boardEl.appendChild(tile);
            });
        }

        function canMove(fromIndex, emptyIndex) {
            const fromRow = Math.floor(fromIndex / boardSize);
            const fromCol = fromIndex % boardSize;
            const emptyRow = Math.floor(emptyIndex / boardSize);
            const emptyCol = emptyIndex % boardSize;
            return Math.abs(fromRow - emptyRow) + Math.abs(fromCol - emptyCol) === 1;
        }

        function moveTile(tileIndex) {
            if (!gameReady || gamePaused) return;
            
            if (!gameStarted) startTimer();
            
            const emptyIndex = state.indexOf(0);
            if (!canMove(tileIndex, emptyIndex)) return;

            var temp = state[tileIndex];
            state[tileIndex] = state[emptyIndex];
            state[emptyIndex] = temp;
            
            moves++;
            movesEl.textContent = String(moves);
            renderBoard();

            if (isSolved()) {
                onGameComplete();
            }
        }

        function isSolved() {
            for (var i = 0; i < state.length; i++) {
                if (state[i] !== solvedState[i]) return false;
            }
            return true;
        }

        function onGameComplete() {
            stopTimer();
            gameStateEl.textContent = "Mision Cumplida!";
            gameStateEl.style.color = "#10b981";
            
            setTimeout(function() {
                alert("Felicidades!\n\nTiempo: " + formatTime(secondsElapsed) + 
                      "\nMovimientos: " + moves + 
                      "\nDificultad: " + boardSize + "x" + boardSize);
            }, 600);
        }

        function shuffleBoard() {
            state = solvedState.slice();
            var emptyIndex = state.indexOf(0);
            var totalSteps = boardSize === 3 ? 100 : boardSize === 4 ? 200 : 350;

            for (var i = 0; i < totalSteps; i++) {
                var candidates = [];
                for (var idx = 0; idx < totalTiles; idx++) {
                    if (canMove(idx, emptyIndex)) candidates.push(idx);
                }
                if (candidates.length === 0) break;
                
                var chosen = candidates[Math.floor(Math.random() * candidates.length)];
                var temp = state[chosen];
                state[chosen] = state[emptyIndex];
                state[emptyIndex] = temp;
                emptyIndex = chosen;
            }

            moves = 0;
            movesEl.textContent = "0";
            resetTimer();
            
            gameStateEl.textContent = "Jugando";
            gameStateEl.style.color = "var(--text-main)";
            
            gameReady = true;
            pauseBtn.disabled = false;
            
            renderBoard();
        }

        function resetGame() {
            if (!resolvedImagePath) return;
            
            state = solvedState.slice();
            moves = 0;
            movesEl.textContent = "0";
            resetTimer();
            
            gameStateEl.textContent = "Listo para despegar";
            gameStateEl.style.color = "var(--text-main)";
            gamePaused = false;
            pauseBtn.textContent = "Pausar";
            pauseBtn.disabled = true;
            
            renderBoard();
        }

        function togglePause() {
            if (!gameReady || !gameStarted) return;
            
            if (gamePaused) {
                resumeTimer();
                gameStateEl.textContent = "Jugando";
            } else {
                pauseTimer();
                gameStateEl.textContent = "En pausa";
            }
        }

        async function verifyService() {
            var candidates = [serviceUrl, window.location.origin + serviceUrl];
            candidates = uniqueValues(candidates);
            
            for (var i = 0; i < candidates.length; i++) {
                try {
                    var res = await fetch(candidates[i], { method: "GET", credentials: "same-origin" });
                    if (res.ok) {
                        serviceStatusEl.className = "service-status ok";
                        serviceStatusEl.textContent = "Conexion establecida";
                        return true;
                    }
                } catch (e) { }
            }
            
            serviceStatusEl.className = "service-status pending";
            serviceStatusEl.textContent = "Modo offline: Funcionalidad local activa";
            return false;
        }

        puzzleSelect.addEventListener("change", function(e) { changePuzzle(e.target.value); });
        
        difficultySelect.addEventListener("change", function(e) {
            if (gameStarted && moves > 0) {
                if (!confirm("Cambiar la dificultad reiniciara tu progreso.\n\nContinuar?")) {
                    difficultySelect.value = boardSize;
                    return;
                }
            }
            updateBoardConfig(e.target.value);
        });

        shuffleBtn.addEventListener("click", function() {
            if (!resolvedImagePath) return;
            shuffleBoard();
        });

        resetBtn.addEventListener("click", resetGame);
        pauseBtn.addEventListener("click", togglePause);

        (async function init() {
            availableImages = await fetchAvailableImages();
            populateImageSelector(availableImages);
            updateBoardConfig(difficultySelect.value);
            await verifyService();
        })();

        /* ──────────────────────────────────────────────────────────
         * SERVICIO 1: NASA APOD API
         * Obtiene la imagen astronómica del día y la carga como
         * imagen del rompecabezas, reutilizando la misma API que
         * usa recorrido.jsp.
         * ────────────────────────────────────────────────────────── */
        const NASA_APOD_URL = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY";
        const nasaStatusEl  = document.getElementById("nasa-status");

        /**
         * Llama a la NASA APOD API, descarga la imagen del día y
         * la establece como imagen activa del rompecabezas.
         */
        async function cargarNASAAPOD() {
            nasaStatusEl.style.display = "block";
            nasaStatusEl.className     = "image-status";
            nasaStatusEl.textContent   = "🛸 Consultando NASA APOD API...";
            document.getElementById("btn-nasa-apod").disabled = true;

            try {
                const res  = await fetch(NASA_APOD_URL);
                if (!res.ok) throw new Error("HTTP " + res.status);
                const data = await res.json();

                if (data.media_type !== "image") {
                    throw new Error("La APOD de hoy es un video. Intenta mañana.");
                }

                // Usar la imagen HD si está disponible
                const imgUrl = data.hdurl || data.url;

                // Agregar al selector como opción especial de la NASA
                const existing = document.querySelector("#puzzle-select option[data-nasa]");
                if (existing) existing.remove();

                const opt       = document.createElement("option");
                opt.value       = imgUrl;
                opt.textContent = "🛸 NASA: " + data.title + " (" + data.date + ")";
                opt.setAttribute("data-nasa", "true");
                puzzleSelect.insertBefore(opt, puzzleSelect.options[1]);
                puzzleSelect.value = imgUrl;

                // Disparar cambio para cargar la imagen en el rompecabezas
                await changePuzzle(imgUrl);

                nasaStatusEl.className = "image-status ok";
                nasaStatusEl.textContent = "✅ NASA APOD: \"" + data.title + "\" — " + data.date;

            } catch (err) {
                console.error("Error NASA APOD:", err);
                nasaStatusEl.style.borderColor = "rgba(239,68,68,0.5)";
                nasaStatusEl.style.background  = "rgba(239,68,68,0.1)";
                nasaStatusEl.textContent = "❌ Error NASA APOD: " + err.message;
            } finally {
                document.getElementById("btn-nasa-apod").disabled = false;
            }
        }

        document.getElementById("btn-nasa-apod")
                .addEventListener("click", cargarNASAAPOD);
    </script>
</body>
</html>