package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Redireccioncontroller {

    @GetMapping("/redirect")
    public String redirectAfterLogin(Authentication auth) {
        String role = auth.getAuthorities().iterator().next().getAuthority();

        switch (role) {
            case "ROLE_ADMIN":
                return "Admin";
            case "ROLE_DOCENTE":
                return "Docente";
            case "ROLE_ACUDIENTE":
                return "Acudiente";
            default:
                return "redirect:/login?error";
        }
    }
}


