package com.mycompany.museodelespacio.resources;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

/**
 * Servicio 2 (backend): JakartaEE11Resource
 *
 * Descripción: Recurso REST de Jakarta EE que expone un endpoint de
 * verificación de estado (health-check) del servidor. Es reutilizado
 * por rompecabezas.jsp para confirmar que el backend está activo antes
 * de habilitar las funciones del juego.
 *
 * Ruta: /resources/jakartaee11
 * Método HTTP: GET
 * Respuesta: texto plano "ping Jakarta EE" con código 200
 *
 * Autora: vania
 * Fecha: 1 abr. 2026
 */
@Path("jakartaee11")
public class JakartaEE11Resource {

    /**
     * Endpoint de health-check.
     * Devuelve 200 OK con el mensaje "ping Jakarta EE" para
     * indicar que el servidor Jakarta EE está operativo.
     *
     * @return Response HTTP 200 con mensaje de confirmación
     */
    @GET
    public Response ping() {
        return Response
                .ok("ping Jakarta EE")
                .build();
    }
}
