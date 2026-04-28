package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Testcontroller {

    @GetMapping("/test-connection")
    public String testConnection() {
        return "✅ Conexión a la base de datos y servidor Spring Boot exitosa";
    }
}
