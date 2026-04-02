package com.mycompany.museodelespacio.resources;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.core.Response;

public class JakartaEE11FallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JakartaEE11Resource resource = new JakartaEE11Resource();
        Response serviceResponse = resource.ping();

        Object entity = serviceResponse.getEntity();
        String body = entity != null ? entity.toString() : "ping Jakarta EE";

        resp.setStatus(serviceResponse.getStatus());
        resp.setContentType("text/plain;charset=UTF-8");
        resp.getWriter().write(body);
    }
}
