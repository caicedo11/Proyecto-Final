package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller corregido: devuelve nombres de vista Thymeleaf en lugar de
 * strings con expresiones th: que nunca se procesaban.
 */
@Controller
@PreAuthorize("hasRole('ADMIN')")
public class Admincontroller {

    @GetMapping("/admin")
    public String adminHome() {
        return "Admin";
    }

    /**
     * Los fragmentos Thymeleaf se renderizan correctamente devolviendo
     * el path de la vista, no una cadena de texto con @ResponseBody.
     */
    @GetMapping("/admin/registro")
    public String registro() {
        return "fragments/registro";
    }

    @GetMapping("/admin/historial")
    public String historial() {
        return "fragments/historial";
    }

    @GetMapping("/admin/asignacion")
    public String asignacion() {
        return "fragments/asignacion";
    }

    @GetMapping("/admin/notificar")
    public String notificar() {
        return "fragments/notificar";
    }

    @GetMapping("/admin/registrarUsuario")
    public String registrarUsuario() {
        return "fragments/admin_registrar_usuario";
    }

    @GetMapping("/admin/registrarEstudiante")
    public String registrarEstudiante() {
        return "fragments/admin_registrar_estudiante";
    }
}
