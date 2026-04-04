<%-- 
    Document   : recorrido
    Created on : 2 abr. 2026
    Author     : Oscar y Vania
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sala de Exhibición | Museo del Espacio</title>
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
            --glow-cyan: 0 0 30px rgba(0,229,255,0.3);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }

        body {
            font-family: 'Raleway', sans-serif;
            background: var(--void);
            color: var(--white);
            min-height: 100vh;
            overflow-x: hidden;
        }

        #starfield {
            position: fixed; inset: 0;
            z-index: 0;
            pointer-events: none;
        }

        nav {
            position: fixed; top: 0; left: 0; right: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.2rem 3rem;
            background: linear-gradient(to bottom, rgba(2,3,15,0.95), transparent);
            backdrop-filter: blur(4px);
        }

        .nav-logo {
            font-family: 'Cinzel', serif;
            font-size: 1rem;
            letter-spacing: 0.25em;
            color: var(--gold);
            text-transform: uppercase;
            text-decoration: none;
        }

        .nav-back {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--soft);
            text-decoration: none;
            font-size: 0.85rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            transition: color 0.3s;
        }
        .nav-back:hover { color: var(--gold); }
        .nav-back::before { content: "←"; font-size: 1.1rem; }

        .hall-entry {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .hall-perspective {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom,
                transparent 0%,
                rgba(201,168,76,0.03) 40%,
                rgba(201,168,76,0.06) 60%,
                rgba(2,3,15,0.9) 100%);
        }

        .hall-floor {
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 45%;
            background: linear-gradient(to bottom, transparent, rgba(7,9,26,0.8));
            overflow: hidden;
        }
        .hall-floor::before {
            content: "";
            position: absolute; inset: 0;
            background:
                repeating-linear-gradient(to bottom, transparent, transparent 39px, rgba(201,168,76,0.08) 40px),
                repeating-linear-gradient(90deg, transparent, transparent 79px, rgba(201,168,76,0.06) 80px);
            transform: perspective(400px) rotateX(35deg);
            transform-origin: bottom center;
        }

        .hall-columns { position: absolute; inset: 0; pointer-events: none; }
        .hall-columns::before,
        .hall-columns::after {
            content: "";
            position: absolute;
            top: 8vh; bottom: 0;
            width: 3px;
            background: linear-gradient(to bottom, transparent, var(--gold-dim) 20%, var(--gold) 50%, var(--gold-dim) 80%, transparent);
            box-shadow: 0 0 20px rgba(201,168,76,0.4);
        }
        .hall-columns::before { left: 12%; }
        .hall-columns::after  { right: 12%; }

        .hall-arch {
            position: absolute;
            top: 0; left: 50%;
            transform: translateX(-50%);
            width: 70%;
            height: 60px;
            border: 1px solid rgba(201,168,76,0.3);
            border-top: none;
            border-radius: 0 0 40% 40%;
            box-shadow: 0 0 40px rgba(201,168,76,0.1);
        }

        .hero-content {
            position: relative;
            z-index: 10;
            text-align: center;
            padding: 0 2rem;
        }

        .hero-eyebrow {
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            letter-spacing: 0.4em;
            color: var(--gold);
            text-transform: uppercase;
            margin-bottom: 1.5rem;
            opacity: 0;
            animation: fadeUp 1s 0.3s ease forwards;
        }

        .hero-title {
            font-family: 'Cinzel', serif;
            font-size: clamp(3rem, 8vw, 7rem);
            font-weight: 900;
            line-height: 1;
            letter-spacing: 0.05em;
            background: linear-gradient(135deg, var(--gold-bright), var(--gold), var(--gold-dim));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
            opacity: 0;
            animation: fadeUp 1s 0.5s ease forwards;
            filter: drop-shadow(0 0 40px rgba(201,168,76,0.5));
        }

        .hero-subtitle {
            font-size: 1rem;
            color: var(--soft);
            letter-spacing: 0.15em;
            text-transform: uppercase;
            margin-bottom: 3rem;
            opacity: 0;
            animation: fadeUp 1s 0.7s ease forwards;
        }

        .enter-btn {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 2.5rem;
            border: 1px solid var(--gold);
            color: var(--gold);
            font-family: 'Cinzel', serif;
            font-size: 0.85rem;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            cursor: pointer;
            background: transparent;
            transition: all 0.4s ease;
            opacity: 0;
            animation: fadeUp 1s 0.9s ease forwards;
            position: relative;
            overflow: hidden;
        }
        .enter-btn::before {
            content: "";
            position: absolute; inset: 0;
            background: var(--gold);
            transform: translateX(-100%);
            transition: transform 0.4s ease;
            z-index: -1;
        }
        .enter-btn:hover { color: var(--void); box-shadow: var(--glow-gold); }
        .enter-btn:hover::before { transform: translateX(0); }

        .scroll-hint {
            position: absolute;
            bottom: 2rem; left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            color: var(--soft);
            font-size: 0.7rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            opacity: 0;
            animation: fadeUp 1s 1.2s ease forwards;
        }
        .scroll-hint::after {
            content: "";
            width: 1px;
            height: 40px;
            background: linear-gradient(to bottom, var(--gold), transparent);
            animation: scrollLine 2s ease-in-out infinite;
        }
        @keyframes scrollLine {
            0%, 100% { opacity: 0.3; transform: scaleY(1); }
            50% { opacity: 1; transform: scaleY(1.3); }
        }

        .main-content {
            position: relative;
            z-index: 10;
            padding: 0 2rem 4rem;
            max-width: 1300px;
            margin: 0 auto;
        }

        .section-label {
            font-family: 'Cinzel', serif;
            font-size: 0.7rem;
            letter-spacing: 0.5em;
            color: var(--gold);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .section-label::before,
        .section-label::after {
            content: "";
            flex: 1;
            height: 1px;
            background: linear-gradient(to right, transparent, var(--gold-dim));
        }
        .section-label::after {
            background: linear-gradient(to left, transparent, var(--gold-dim));
        }

        .obra-frame {
            position: relative;
            background: var(--deep);
            border: 1px solid var(--border);
            margin-bottom: 4rem;
            box-shadow: 0 0 0 8px rgba(7,9,26,0.8), 0 0 0 9px rgba(201,168,76,0.15), 0 40px 80px rgba(0,0,0,0.8);
        }
        .obra-frame::before {
            content: "✦";
            position: absolute;
            color: var(--gold);
            font-size: 1.2rem;
            z-index: 5;
            top: -0.7rem; left: 50%; transform: translateX(-50%);
        }

        .obra-img-area {
            position: relative;
            width: 100%;
            height: 60vh;
            min-height: 400px;
            overflow: hidden;
            background: radial-gradient(ellipse at center, #0d1033, #02030f);
            cursor: grab;
        }
        .obra-img-area:active { cursor: grabbing; }

        .obra-vignette {
            position: absolute; inset: 0;
            background: radial-gradient(ellipse at center, transparent 50%, rgba(2,3,15,0.7) 100%);
            pointer-events: none;
            z-index: 2;
        }

        .obra-source-badge {
            position: absolute;
            top: 1.5rem; right: 1.5rem;
            background: rgba(2,3,15,0.85);
            border: 1px solid var(--gold);
            color: var(--gold);
            font-family: 'Cinzel', serif;
            font-size: 0.65rem;
            letter-spacing: 0.2em;
            padding: 0.4rem 0.9rem;
            z-index: 3;
            backdrop-filter: blur(8px);
        }

        .obra-caption {
            padding: 2rem 2.5rem;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 1.5rem;
            align-items: start;
            border-top: 1px solid var(--border);
        }

        .obra-caption h2 {
            font-family: 'Cinzel', serif;
            font-size: clamp(1.2rem, 2vw, 1.8rem);
            color: var(--gold-bright);
            margin-bottom: 0.6rem;
            line-height: 1.3;
        }

        .obra-caption p {
            color: var(--soft);
            font-size: 0.92rem;
            line-height: 1.75;
            max-width: 75ch;
        }

        .obra-meta-right { text-align: right; flex-shrink: 0; }
        .obra-date {
            font-family: 'Cinzel', serif;
            font-size: 1.4rem;
            color: var(--gold);
            display: block;
            margin-bottom: 0.3rem;
        }
        .obra-credit { font-size: 0.78rem; color: var(--soft); letter-spacing: 0.05em; }

        .sala-selector {
            display: flex;
            gap: 0.6rem;
            flex-wrap: wrap;
            justify-content: center;
            margin-bottom: 3rem;
        }

        .sala-btn {
            border: 1px solid rgba(201,168,76,0.3);
            background: transparent;
            color: var(--soft);
            font-family: 'Raleway', sans-serif;
            font-size: 0.8rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            padding: 0.6rem 1.3rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .sala-btn:hover { border-color: var(--gold); color: var(--gold); box-shadow: var(--glow-gold); }
        .sala-btn.active { background: var(--gold); border-color: var(--gold); color: var(--void); font-weight: 600; }

        .gallery-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .gallery-title { font-family: 'Cinzel', serif; font-size: 1.3rem; color: var(--gold-bright); }
        .gallery-status { font-size: 0.8rem; color: var(--soft); letter-spacing: 0.1em; }

        .museum-wall {
            background: linear-gradient(to bottom, #0b0d20, #07091a);
            border: 1px solid rgba(201,168,76,0.1);
            padding: 3rem 2rem 2rem;
            position: relative;
            margin-bottom: 4rem;
        }
        .museum-wall::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(to right, transparent, var(--gold-dim), var(--gold), var(--gold-dim), transparent);
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 2rem;
            position: relative;
            z-index: 2;
        }

        .gallery-item {
            cursor: pointer;
            position: relative;
            animation: fadeUp 0.6s ease both;
        }

        .gallery-frame {
            position: relative;
            background: var(--void);
            border: 2px solid var(--gold-dim);
            box-shadow: inset 0 0 0 1px rgba(201,168,76,0.1), 0 20px 40px rgba(0,0,0,0.6);
            transition: all 0.4s ease;
            overflow: hidden;
        }
        .gallery-frame::before {
            content: "";
            position: absolute; inset: 4px;
            border: 1px solid rgba(201,168,76,0.15);
            z-index: 3;
            pointer-events: none;
            transition: border-color 0.4s;
        }
        .gallery-item:hover .gallery-frame {
            border-color: var(--gold);
            box-shadow: inset 0 0 0 1px rgba(201,168,76,0.3), 0 30px 60px rgba(0,0,0,0.7), 0 0 30px rgba(201,168,76,0.2);
            transform: translateY(-6px);
        }
        .gallery-item:hover .gallery-frame::before { border-color: rgba(201,168,76,0.4); }

        .gallery-frame img {
            width: 100%;
            aspect-ratio: 4/3;
            object-fit: cover;
            display: block;
            opacity: 1;
            transition: transform 0.6s ease;
            filter: brightness(0.85) saturate(1.1);
        }
        .gallery-item:hover .gallery-frame img {
            transform: scale(1.06);
            filter: brightness(1) saturate(1.2);
        }

        .gallery-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(2,3,15,0.95) 0%, rgba(2,3,15,0.5) 40%, transparent 70%);
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 1rem;
            opacity: 0;
            transition: opacity 0.4s ease;
            z-index: 4;
        }
        .gallery-item:hover .gallery-overlay { opacity: 1; }

        .gallery-overlay-title {
            font-family: 'Cinzel', serif;
            font-size: 0.8rem;
            color: var(--gold-bright);
            line-height: 1.3;
            margin-bottom: 0.3rem;
        }
        .gallery-overlay-meta { font-size: 0.7rem; color: var(--soft); letter-spacing: 0.05em; }

        .gallery-plaque {
            background: linear-gradient(135deg, #0d1033, #07091a);
            border: 1px solid rgba(201,168,76,0.2);
            border-top: none;
            padding: 0.75rem 1rem;
        }
        .gallery-plaque-title {
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            color: var(--gold);
            margin-bottom: 0.2rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .gallery-plaque-year { font-size: 0.7rem; color: var(--soft); }

        .gallery-skeleton { animation: fadeUp 0.4s ease both; }
        .gallery-skeleton .gallery-frame { border-color: rgba(201,168,76,0.1); }
        .skeleton-img {
            width: 100%;
            aspect-ratio: 4/3;
            background: linear-gradient(90deg, rgba(201,168,76,0.03) 0%, rgba(201,168,76,0.08) 50%, rgba(201,168,76,0.03) 100%);
            background-size: 200% 100%;
            animation: shimmer 1.8s infinite;
        }
        .skeleton-plaque { height: 52px; background: rgba(201,168,76,0.04); }

        @keyframes shimmer {
            0%   { background-position: -200% 0; }
            100% { background-position:  200% 0; }
        }

        .info-panel {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 2rem;
            margin-bottom: 4rem;
            align-items: start;
        }

        .wiki-card {
            background: linear-gradient(135deg, rgba(13,16,51,0.8), rgba(7,9,26,0.9));
            border: 1px solid var(--border);
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }
        .wiki-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(to right, transparent, var(--gold), transparent);
        }

        .wiki-card-header { display: flex; align-items: flex-start; gap: 1rem; margin-bottom: 1.5rem; }

        .wiki-icon-big {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, var(--gold-dim), var(--gold));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }

        .wiki-card h3 { font-family: 'Cinzel', serif; font-size: 1.1rem; color: var(--gold-bright); margin-bottom: 0.3rem; }
        .wiki-card .wiki-source-tag { font-size: 0.7rem; color: var(--soft); letter-spacing: 0.1em; text-transform: uppercase; }
        .wiki-text { color: var(--soft); font-size: 0.9rem; line-height: 1.85; margin-bottom: 1.5rem; }

        .wiki-read-more {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gold);
            text-decoration: none;
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            border-bottom: 1px solid rgba(201,168,76,0.3);
            padding-bottom: 0.2rem;
            transition: border-color 0.3s, color 0.3s;
        }
        .wiki-read-more:hover { color: var(--gold-bright); border-color: var(--gold); }

        .object-stats { background: rgba(2,3,15,0.6); border: 1px solid var(--border); padding: 2rem; }

        .stats-title {
            font-family: 'Cinzel', serif;
            font-size: 0.75rem;
            letter-spacing: 0.3em;
            color: var(--gold);
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }

        .stat-row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            padding: 0.8rem 0;
            border-bottom: 1px solid rgba(201,168,76,0.08);
        }
        .stat-row:last-child { border-bottom: none; }
        .stat-key { font-size: 0.78rem; color: var(--soft); letter-spacing: 0.05em; }
        .stat-val { font-family: 'Cinzel', serif; font-size: 0.85rem; color: var(--gold-bright); text-align: right; }

        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(2,3,15,0.96);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.4s ease;
            backdrop-filter: blur(10px);
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }

        .modal-box {
            max-width: 900px; width: 100%;
            background: var(--deep);
            border: 1px solid var(--gold);
            box-shadow: 0 0 80px rgba(201,168,76,0.2);
            transform: scale(0.95);
            transition: transform 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .modal-overlay.open .modal-box { transform: scale(1); }

        .modal-img {
            width: 100%;
            max-height: 62vh;
            object-fit: contain;
            background: #02030f;
            display: block;
        }

        .modal-info { padding: 1.5rem 2rem; border-top: 1px solid var(--border); }
        .modal-info h3 { font-family: 'Cinzel', serif; color: var(--gold-bright); font-size: 1.1rem; margin-bottom: 0.5rem; }
        .modal-info p { color: var(--soft); font-size: 0.88rem; line-height: 1.7; }

        .modal-close {
            position: absolute; top: 1rem; right: 1rem;
            background: rgba(2,3,15,0.8);
            border: 1px solid var(--gold);
            color: var(--gold);
            width: 36px; height: 36px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 1.1rem;
            transition: all 0.3s; z-index: 10;
        }
        .modal-close:hover { background: var(--gold); color: var(--void); }

        .status-bar {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.7rem 1.2rem; font-size: 0.82rem;
            letter-spacing: 0.05em; border-left: 2px solid;
            margin-bottom: 1rem; border-radius: 0;
        }
        .status-loading { border-color: var(--gold-dim); color: var(--soft); background: rgba(201,168,76,0.05); }
        .status-ok      { border-color: #2dd4bf; color: #99f6e4; background: rgba(45,212,191,0.05); }
        .status-error   { border-color: #f87171; color: #fca5a5; background: rgba(248,113,113,0.05); }

        .spinner {
            width: 16px; height: 16px;
            border: 2px solid rgba(201,168,76,0.2);
            border-top-color: var(--gold);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            flex-shrink: 0;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .site-footer {
            position: relative; z-index: 10;
            text-align: center; padding: 3rem 2rem;
            border-top: 1px solid rgba(201,168,76,0.15);
            margin-top: 2rem;
        }
        .site-footer p {
            font-family: 'Cinzel', serif;
            font-size: 0.7rem; letter-spacing: 0.3em;
            color: var(--gold-dim); text-transform: uppercase;
        }

        @media (max-width: 900px) {
            nav { padding: 1rem 1.5rem; }
            .hall-columns::before { left: 5%; }
            .hall-columns::after  { right: 5%; }
            .info-panel { grid-template-columns: 1fr; }
            .gallery-grid { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 1.2rem; }
            .obra-caption { grid-template-columns: 1fr; }
            .obra-meta-right { text-align: left; }
            .museum-wall { padding: 2rem 1rem 1rem; }
        }
        @media (max-width: 600px) {
            .sala-selector { gap: 0.4rem; }
            .sala-btn { font-size: 0.72rem; padding: 0.5rem 0.9rem; }
            .hero-title { font-size: 2.8rem; }
        }
    </style>
</head>
<body>

    <canvas id="starfield"></canvas>

    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-logo">Museo del Espacio</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-back">Volver al Inicio</a>
    </nav>

    <section class="hall-entry">
        <div class="hall-perspective"></div>
        <div class="hall-floor"></div>
        <div class="hall-columns"></div>
        <div class="hall-arch"></div>
        <div class="hero-content">
            <p class="hero-eyebrow">Sala de Exhibición · Ala Cósmica</p>
            <h1 class="hero-title">Recorrido<br>Cósmico</h1>
            <p class="hero-subtitle">Imágenes de la NASA · Datos Reales · Cosmos Infinito</p>
            <button class="enter-btn" onclick="document.getElementById('exhibicion').scrollIntoView({behavior:'smooth'})">
                Entrar a la Sala <span>✦</span>
            </button>
        </div>
        <div class="scroll-hint">Desplaza</div>
    </section>

    <main class="main-content" id="exhibicion">

        <div class="section-label">Obra Estelar · Cosmos Interactivo</div>

        <article class="obra-frame" id="obra-principal">
            <div class="obra-img-area" id="cosmos-canvas-wrap">
                <canvas id="cosmos-canvas" style="width:100%;height:100%;display:block;"></canvas>
                <div class="obra-vignette"></div>
                <span class="obra-source-badge">Three.js · Tiempo Real</span>
                <div id="cosmos-hint" style="
                    position:absolute;bottom:1.5rem;left:50%;transform:translateX(-50%);
                    color:rgba(201,168,76,0.6);font-size:0.72rem;letter-spacing:0.2em;
                    text-transform:uppercase;pointer-events:none;transition:opacity 1s;
                    white-space:nowrap;">
                    Arrastra para rotar · Scroll para zoom
                </div>
            </div>
            <div class="obra-caption">
                <div>
                    <h2 id="apod-titulo">Cosmos Interactivo — Simulación en Tiempo Real</h2>
                    <p id="apod-desc" style="margin-top:0.6rem">
                        Más de 8,000 partículas estelares generadas proceduralmente.
                        Nebulosas de colores, campo estelar dinámico y núcleo galáctico.
                        Arrastra para orbitar, scroll para acercar.
                    </p>
                </div>
                <div class="obra-meta-right">
                    <span class="obra-date" id="apod-fecha" style="font-size:1rem;">Three.js r128</span>
                    <span class="obra-credit" id="apod-credito">Generativo · Sin API key</span>
                </div>
            </div>
        </article>

        <div class="section-label">Elige una Sala</div>

        <div class="sala-selector">
            <button class="sala-btn active" data-tema="galaxy"     data-wiki="Galaxia">🌌 Galaxias</button>
            <button class="sala-btn"        data-tema="nebula"     data-wiki="Nebulosa">🌫️ Nebulosas</button>
            <button class="sala-btn"        data-tema="saturn"     data-wiki="Saturno">🪐 Saturno</button>
            <button class="sala-btn"        data-tema="moon"       data-wiki="Luna">🌕 Luna</button>
            <button class="sala-btn"        data-tema="mars"       data-wiki="Marte">🔴 Marte</button>
            <button class="sala-btn"        data-tema="black hole" data-wiki="Agujero_negro">🕳️ Agujeros Negros</button>
            <button class="sala-btn"        data-tema="supernova"  data-wiki="Supernova">💥 Supernovas</button>
            <button class="sala-btn"        data-tema="aurora"     data-wiki="Aurora_polar">🌈 Auroras</button>
        </div>

        <div class="gallery-header">
            <h2 class="gallery-title" id="gallery-title">Sala: Galaxias</h2>
            <span class="gallery-status" id="gallery-status">Cargando obras...</span>
        </div>

        <div id="apod-gallery-status"></div>

        <div class="museum-wall">
            <div class="gallery-grid" id="gallery-grid">
                <div class="gallery-skeleton"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.1s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.2s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.3s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.4s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.5s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.6s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
                <div class="gallery-skeleton" style="animation-delay:.7s"><div class="gallery-frame"><div class="skeleton-img"></div></div><div class="skeleton-plaque gallery-plaque"></div></div>
            </div>
        </div>

        <div class="section-label">Información Enciclopédica</div>

        <div class="info-panel">
            <div class="wiki-card">
                <div class="wiki-card-header">
                    <div class="wiki-icon-big" id="wiki-emoji">🌌</div>
                    <div>
                        <h3 id="wiki-titulo">Galaxia</h3>
                        <span class="wiki-source-tag">Wikipedia (es) · WikipediaServlet</span>
                    </div>
                </div>
                <p class="wiki-text" id="wiki-texto">Cargando información enciclopédica...</p>
                <a id="wiki-link" class="wiki-read-more" href="#" target="_blank" style="display:none;">
                    Leer artículo completo →
                </a>
                <div id="wiki-status" style="display:none;margin-top:1rem;"></div>
            </div>

            <div class="object-stats">
                <div class="stats-title">Datos del Objeto</div>
                <div class="stat-row"><span class="stat-key">Tipo</span><span class="stat-val" id="stat-tipo">—</span></div>
                <div class="stat-row"><span class="stat-key">Distancia</span><span class="stat-val" id="stat-dist">—</span></div>
                <div class="stat-row"><span class="stat-key">Categoría</span><span class="stat-val" id="stat-cat">—</span></div>
                <div class="stat-row"><span class="stat-key">Fuente</span><span class="stat-val">NASA · Wikipedia</span></div>
                <div class="stat-row"><span class="stat-key">Imágenes</span><span class="stat-val" id="stat-imgs">—</span></div>
            </div>
        </div>

    </main>

    <div class="modal-overlay" id="modal" role="dialog" aria-modal="true">
        <div class="modal-box">
            <button class="modal-close" id="modal-close" aria-label="Cerrar">✕</button>
            <img class="modal-img" id="modal-img" src="" alt="">
            <div class="modal-info">
                <h3 id="modal-titulo"></h3>
                <p id="modal-desc"></p>
            </div>
        </div>
    </div>

    <footer class="site-footer">
        <p>✦ Museo del Espacio · Imágenes NASA · Wikipedia · Three.js ✦</p>
    </footer>

    <script>
    /* ═══════════════════════════════════
       FONDO ESTRELLADO
    ═══════════════════════════════════ */
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

    /* ═══════════════════════════════════
       CONFIG
    ═══════════════════════════════════ */
    const CTX             = "<%= request.getContextPath() %>";
    const NASA_IMAGES_URL = "https://images-api.nasa.gov/search";
    const WIKI_SERVLET    = CTX + "/resources/wikipedia";

    const OBJECT_STATS = {
        "galaxy":     { tipo: "Galaxia",          dist: "Millones de A.L.",  cat: "Estructura Cósmica" },
        "nebula":     { tipo: "Nebulosa",          dist: "Cientos de A.L.",   cat: "Nube Interestelar"  },
        "saturn":     { tipo: "Planeta",           dist: "1,433 M km",        cat: "Sistema Solar"      },
        "moon":       { tipo: "Satélite",          dist: "384,400 km",        cat: "Sistema Solar"      },
        "mars":       { tipo: "Planeta",           dist: "225 M km (media)",  cat: "Sistema Solar"      },
        "black hole": { tipo: "Agujero Negro",     dist: "Variable",          cat: "Objeto Compacto"    },
        "supernova":  { tipo: "Explosión Estelar", dist: "Variable",          cat: "Fenómeno Estelar"   },
        "aurora":     { tipo: "Fenómeno",          dist: "100 – 300 km",      cat: "Atmósfera"          }
    };

    const EMOJIS = {
        "galaxy": "🌌", "nebula": "🌫️", "saturn": "🪐", "moon": "🌕",
        "mars": "🔴", "black hole": "🕳️", "supernova": "💥", "aurora": "🌈"
    };

    /* ═══════════════════════════════════
       REFS DOM
    ═══════════════════════════════════ */
    const galleryGrid   = document.getElementById("gallery-grid");
    const galleryTitle  = document.getElementById("gallery-title");
    const galleryStatus = document.getElementById("gallery-status");
    const galStatusBar  = document.getElementById("apod-gallery-status");
    const wikiTitulo    = document.getElementById("wiki-titulo");
    const wikiTexto     = document.getElementById("wiki-texto");
    const wikiLink      = document.getElementById("wiki-link");
    const wikiStatus    = document.getElementById("wiki-status");
    const wikiEmoji     = document.getElementById("wiki-emoji");
    const modal         = document.getElementById("modal");
    const modalImg      = document.getElementById("modal-img");
    const modalTitulo   = document.getElementById("modal-titulo");
    const modalDesc     = document.getElementById("modal-desc");
    const modalClose    = document.getElementById("modal-close");

    /* ═══════════════════════════════════
       COSMOS 3D — Three.js
    ═══════════════════════════════════ */
    (function initCosmos() {
        const script  = document.createElement("script");
        script.src    = "https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js";
        script.onload = buildCosmos;
        document.head.appendChild(script);
    })();

    function buildCosmos() {
        const wrap   = document.getElementById("cosmos-canvas-wrap");
        const canvas = document.getElementById("cosmos-canvas");
        const hint   = document.getElementById("cosmos-hint");

        const renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.setClearColor(0x02030f, 1);

        const scene  = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(60, wrap.clientWidth / wrap.clientHeight, 0.1, 2000);
        camera.position.set(0, 0, 320);

        function resize() {
            const w = wrap.clientWidth, h = wrap.clientHeight;
            renderer.setSize(w, h, false);
            camera.aspect = w / h;
            camera.updateProjectionMatrix();
        }
        resize();
        window.addEventListener("resize", resize);

        const starGeo = new THREE.BufferGeometry();
        const starPos = new Float32Array(6000 * 3);
        for (let i = 0; i < starPos.length; i++) starPos[i] = (Math.random() - 0.5) * 1800;
        starGeo.setAttribute("position", new THREE.BufferAttribute(starPos, 3));
        scene.add(new THREE.Points(starGeo, new THREE.PointsMaterial({ color: 0xf0f4ff, size: 0.7 })));

        const core = new THREE.Mesh(
            new THREE.SphereGeometry(8, 32, 32),
            new THREE.MeshBasicMaterial({ color: 0xf0d080 })
        );
        scene.add(core);
        scene.add(new THREE.Mesh(
            new THREE.SphereGeometry(18, 24, 24),
            new THREE.MeshBasicMaterial({ color: 0xc9a84c, transparent: true, opacity: 0.08 })
        ));

        function crearBrazo(n, angOffset, color, spread) {
            const geo = new THREE.BufferGeometry();
            const pos = new Float32Array(n * 3);
            for (let i = 0; i < n; i++) {
                const t   = i / n;
                const r   = 20 + t * 180;
                const ang = angOffset + t * Math.PI * 4;
                const d   = (Math.random() - 0.5) * spread * (1 + t);
                pos[i*3]   = Math.cos(ang) * r + d;
                pos[i*3+1] = (Math.random() - 0.5) * 10 * t;
                pos[i*3+2] = Math.sin(ang) * r + d;
            }
            geo.setAttribute("position", new THREE.BufferAttribute(pos, 3));
            return new THREE.Points(geo, new THREE.PointsMaterial({ color, size: 1.2, transparent: true, opacity: 0.85 }));
        }

        const galaxy = new THREE.Group();
        galaxy.add(crearBrazo(2000, 0,           0xffeebb, 18));
        galaxy.add(crearBrazo(2000, Math.PI,     0xffe0aa, 18));
        galaxy.add(crearBrazo(1000, Math.PI/2,   0xddccff, 22));
        galaxy.add(crearBrazo(1000, Math.PI*1.5, 0xccddff, 22));
        scene.add(galaxy);

        function crearNebulosa(cx, cy, cz, color, n, radio) {
            const geo = new THREE.BufferGeometry();
            const pos = new Float32Array(n * 3);
            for (let i = 0; i < n; i++) {
                const theta = Math.random() * Math.PI * 2;
                const phi   = Math.acos(2 * Math.random() - 1);
                const r     = Math.random() * radio;
                pos[i*3]   = cx + r * Math.sin(phi) * Math.cos(theta);
                pos[i*3+1] = cy + r * Math.sin(phi) * Math.sin(theta) * 0.4;
                pos[i*3+2] = cz + r * Math.cos(phi);
            }
            geo.setAttribute("position", new THREE.BufferAttribute(pos, 3));
            return new THREE.Points(geo, new THREE.PointsMaterial({ color, size: 1.8, transparent: true, opacity: 0.5 }));
        }

        scene.add(crearNebulosa( 120,  30, -60, 0x4488ff, 600, 40));
        scene.add(crearNebulosa(-100, -20,  80, 0xff6644, 500, 35));
        scene.add(crearNebulosa(  60,  60,  90, 0xaa44ff, 500, 30));
        scene.add(crearNebulosa(-140,  10, -40, 0x44ffcc, 400, 28));

        let isDown = false, lastX = 0, lastY = 0;
        let rotX = 0.3, rotY = 0, velX = 0, velY = 0.0008, zoom = 320;

        wrap.addEventListener("mousedown",  e => { isDown=true; lastX=e.clientX; lastY=e.clientY; hint.style.opacity="0"; });
        wrap.addEventListener("mousemove",  e => { if(!isDown) return; velY=(e.clientX-lastX)*0.003; velX=(e.clientY-lastY)*0.003; lastX=e.clientX; lastY=e.clientY; });
        wrap.addEventListener("mouseup",    () => isDown=false);
        wrap.addEventListener("mouseleave", () => isDown=false);
        wrap.addEventListener("touchstart", e => { isDown=true; lastX=e.touches[0].clientX; lastY=e.touches[0].clientY; hint.style.opacity="0"; }, {passive:true});
        wrap.addEventListener("touchmove",  e => { if(!isDown) return; velY=(e.touches[0].clientX-lastX)*0.003; velX=(e.touches[0].clientY-lastY)*0.003; lastX=e.touches[0].clientX; lastY=e.touches[0].clientY; }, {passive:true});
        wrap.addEventListener("touchend",   () => isDown=false);
        wrap.addEventListener("wheel",      e => { zoom=Math.max(80, Math.min(600, zoom+e.deltaY*0.5)); }, {passive:true});

        let t = 0;
        function animate() {
            requestAnimationFrame(animate);
            t += 0.005;
            if (!isDown) { velX*=0.95; velY*=0.95; velY+=0.0004; }
            rotY += velY;
            rotX += velX;
            rotX  = Math.max(-Math.PI/3, Math.min(Math.PI/3, rotX));
            galaxy.rotation.y = rotY;
            galaxy.rotation.x = rotX;
            core.rotation.y   = t * 0.5;
            core.scale.setScalar(1 + 0.06 * Math.sin(t * 2));
            camera.position.z += (zoom - camera.position.z) * 0.06;
            renderer.render(scene, camera);
        }
        animate();
    }

    /* ═══════════════════════════════════
       GALERÍA NASA IMAGES
    ═══════════════════════════════════ */
    async function cargarGaleriaNASA(tema) {
        galStatusBar.innerHTML = `
            <div class="status-bar status-loading">
                <div class="spinner"></div>
                <span>Buscando imágenes en NASA Images Library...</span>
            </div>`;
        galleryStatus.textContent = "Cargando obras...";

        galleryGrid.innerHTML = Array(8).fill(0).map((_, i) =>
            `<div class="gallery-skeleton" style="animation-delay:${i*0.08}s">
                <div class="gallery-frame"><div class="skeleton-img"></div></div>
                <div class="skeleton-plaque gallery-plaque"></div>
            </div>`
        ).join("");

        try {
            const url  = NASA_IMAGES_URL + "?q=" + encodeURIComponent(tema) + "&media_type=image&page_size=20";
            const res  = await fetch(url);
            if (!res.ok) throw new Error("HTTP " + res.status);

            const data  = await res.json();
            const items = (data.collection?.items || []).filter(item => {
                const link = item.links?.[0]?.href;
                return link && link.startsWith("https://");
            });

            if (items.length === 0) throw new Error("Sin resultados con imágenes válidas");

            galleryGrid.innerHTML = "";
            let count = 0;

            for (const item of items) {
                if (count >= 8) break;

                const meta   = item.data?.[0];
                const imgUrl = item.links?.[0]?.href;
                if (!meta || !imgUrl) continue;

                const titulo = meta.title || "Sin título";
                const year   = meta.date_created ? meta.date_created.substring(0, 4) : "—";
                const desc   = meta.description || meta.description_508 || "Imagen de la NASA.";

                const card = document.createElement("div");
                card.className = "gallery-item";
                card.style.animationDelay = (count * 0.07) + "s";

                const img = document.createElement("img");
                img.alt        = titulo;
                img.style.cssText = "width:100%;aspect-ratio:4/3;object-fit:cover;display:block;opacity:1;transition:transform 0.6s ease;filter:brightness(0.85) saturate(1.1);";
                img.onerror    = () => { card.style.display = "none"; };
                img.src        = imgUrl;

                const frame = document.createElement("div");
                frame.className = "gallery-frame";
                frame.appendChild(img);

                const overlay = document.createElement("div");
                overlay.className = "gallery-overlay";
                overlay.innerHTML = `
                    <div class="gallery-overlay-title">${titulo}</div>
                    <div class="gallery-overlay-meta">NASA · ${year}</div>`;
                frame.appendChild(overlay);

                const plaque = document.createElement("div");
                plaque.className = "gallery-plaque";
                plaque.innerHTML = `
                    <div class="gallery-plaque-title">${titulo}</div>
                    <div class="gallery-plaque-year">NASA · ${year}</div>`;

                card.appendChild(frame);
                card.appendChild(plaque);
                card.addEventListener("click", () => abrirModal(imgUrl, titulo, desc));
                galleryGrid.appendChild(card);
                count++;
            }

            galleryStatus.textContent = count + " obras cargadas";
            document.getElementById("stat-imgs").textContent = count;
            galStatusBar.innerHTML = `<div class="status-bar status-ok">✦ ${count} imágenes cargadas correctamente</div>`;

        } catch (err) {
            console.error("NASA Images error:", err);
            galleryGrid.innerHTML = `
                <p style="color:var(--soft);grid-column:1/-1;text-align:center;padding:2rem;">
                    No se pudieron cargar las imágenes: ${err.message}
                </p>`;
            galleryStatus.textContent = "Error";
            galStatusBar.innerHTML = `<div class="status-bar status-error">❌ ${err.message}</div>`;
        }
    }

    /* ═══════════════════════════════════
       WIKIPEDIA SERVLET
    ═══════════════════════════════════ */
    async function cargarWikipedia(tema) {
        wikiStatus.style.display = "block";
        wikiStatus.innerHTML = `<div class="status-bar status-loading"><div class="spinner"></div><span>Consultando WikipediaServlet...</span></div>`;
        wikiTexto.textContent  = "";
        wikiLink.style.display = "none";
        wikiTitulo.textContent = tema.replace(/_/g, " ");

        try {
            const res  = await fetch(WIKI_SERVLET + "?tema=" + encodeURIComponent(tema));
            if (!res.ok) throw new Error("HTTP " + res.status);
            const data = await res.json();
            if (data.error) throw new Error(data.error);

            wikiTitulo.textContent = data.title || tema.replace(/_/g, " ");
            wikiTexto.textContent  = data.extract || "Sin extracto disponible.";

            const pageUrl          = data.content_urls?.desktop?.page || "https://es.wikipedia.org/wiki/" + tema;
            wikiLink.href          = pageUrl;
            wikiLink.style.display = "inline-flex";
            wikiStatus.innerHTML   = `<div class="status-bar status-ok">✦ Información obtenida vía WikipediaServlet</div>`;

        } catch (err) {
            wikiTexto.textContent = "No se pudo obtener la información enciclopédica.";
            wikiStatus.innerHTML  = `<div class="status-bar status-error">❌ WikipediaServlet: ${err.message}</div>`;
        }
    }

    /* ═══════════════════════════════════
       MODAL
    ═══════════════════════════════════ */
    function abrirModal(imgUrl, titulo, desc) {
        modalImg.src            = imgUrl;
        modalImg.alt            = titulo;
        modalTitulo.textContent = titulo;
        modalDesc.textContent   = desc.substring(0, 300) + (desc.length > 300 ? "…" : "");
        modal.classList.add("open");
        document.body.style.overflow = "hidden";
    }

    function cerrarModal() {
        modal.classList.remove("open");
        document.body.style.overflow = "";
    }

    modalClose.addEventListener("click", cerrarModal);
    modal.addEventListener("click", e => { if (e.target === modal) cerrarModal(); });
    document.addEventListener("keydown", e => { if (e.key === "Escape") cerrarModal(); });

    /* ═══════════════════════════════════
       SELECTOR DE SALA
    ═══════════════════════════════════ */
    document.querySelectorAll(".sala-btn").forEach(btn => {
        btn.addEventListener("click", function() {
            document.querySelectorAll(".sala-btn").forEach(b => b.classList.remove("active"));
            this.classList.add("active");

            const tema   = this.dataset.tema;
            const wiki   = this.dataset.wiki;
            const nombre = this.textContent.replace(/[^\w\sáéíóúüñÁÉÍÓÚÜÑ]/g, "").trim();

            galleryTitle.textContent = "Sala: " + nombre;
            wikiEmoji.textContent    = EMOJIS[tema] || "🌌";

            const stats = OBJECT_STATS[tema] || {};
            document.getElementById("stat-tipo").textContent = stats.tipo || "—";
            document.getElementById("stat-dist").textContent = stats.dist || "—";
            document.getElementById("stat-cat").textContent  = stats.cat  || "—";

            cargarGaleriaNASA(tema);
            cargarWikipedia(wiki);
        });
    });

    /* ═══════════════════════════════════
       INIT
    ═══════════════════════════════════ */
    (function init() {
        const s = OBJECT_STATS["galaxy"];
        document.getElementById("stat-tipo").textContent = s.tipo;
        document.getElementById("stat-dist").textContent = s.dist;
        document.getElementById("stat-cat").textContent  = s.cat;
        cargarGaleriaNASA("galaxy");
        cargarWikipedia("Galaxia");
    })();
    </script>
</body>
</html>