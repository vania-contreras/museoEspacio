package com.mycompany.museodelespacio.resources;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servicio 1: WikipediaServlet
 *
 * Descripción: Servlet que actúa como proxy hacia la API REST de Wikipedia
 * en español. Recibe el nombre de un objeto espacial como parámetro,
 * consulta el extracto del artículo correspondiente y lo devuelve en
 * formato JSON al cliente, permitiendo reutilizar el servicio desde
 * cualquier página del museo (recorrido.jsp, index.jsp, etc.).
 *
 * Ruta: /resources/wikipedia?tema=<nombre>
 * Método HTTP: GET
 * Respuesta: JSON con campos { extract, title, pageUrl }
 *
 * API externa reutilizada:
 *   https://es.wikipedia.org/api/rest_v1/page/summary/{title}
 *
 * Autora: vania
 * Fecha: 2 abr. 2026
 */
@WebServlet("/resources/wikipedia")
public class WikipediaServlet extends HttpServlet {

    // URL base de la API REST de Wikipedia en español
    private static final String WIKIPEDIA_API = "https://es.wikipedia.org/api/rest_v1/page/summary/";

    /**
     * Maneja peticiones GET.
     * Parámetro requerido: "tema" (ej. "Saturno", "Nebulosa", "Agujero_negro")
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Permitir llamadas desde el mismo origen (CORS para desarrollo local)
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Leer parámetro "tema"
        String tema = req.getParameter("tema");

        if (tema == null || tema.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Parámetro 'tema' requerido\"}");
            return;
        }

        // Codificar el tema para la URL (espacios → %20, etc.)
        String temaEncoded = URLEncoder.encode(tema.trim(), StandardCharsets.UTF_8)
                .replace("+", "_");

        String apiUrl = WIKIPEDIA_API + temaEncoded;

        try {
            // Abrir conexión HTTP hacia Wikipedia
            URI uri = URI.create(apiUrl);
            URL url = uri.toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            // User-Agent recomendado por Wikipedia para bots/aplicaciones
            conn.setRequestProperty("User-Agent", "MuseoDelEspacio/1.0 (proyecto escolar)");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(8000);

            int statusCode = conn.getResponseCode();

            if (statusCode == HttpURLConnection.HTTP_OK) {
                // Leer la respuesta de Wikipedia y reenviarla al cliente
                InputStream is = conn.getInputStream();
                String jsonBody = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write(jsonBody);
            } else if (statusCode == HttpURLConnection.HTTP_NOT_FOUND) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\":\"Artículo no encontrado para: " + tema + "\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
                resp.getWriter().write("{\"error\":\"Error al consultar Wikipedia: " + statusCode + "\"}");
            }

            conn.disconnect();

        } catch (Exception e) {
            // Error de red u otro problema inesperado
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Error interno: " + e.getMessage() + "\"}");
        }
    }
}
