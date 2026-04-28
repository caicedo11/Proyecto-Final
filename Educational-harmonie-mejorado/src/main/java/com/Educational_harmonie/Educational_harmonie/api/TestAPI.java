package com.Educational_harmonie.Educational_harmonie.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/test") // Ruta estandarizada para el móvil
@CrossOrigin(origins = "*")     // Permite que Flutter haga la prueba de conexión
public class TestAPI {

    @GetMapping("/connection")
    public ResponseEntity<Map<String, Object>> testConnection() {
        Map<String, Object> response = new HashMap<>();
        
        response.put("status", "OK");
        response.put("mensaje", "✅ Conexión exitosa con el Backend de Educational Harmonie");
        response.put("timestamp", System.currentTimeMillis());
        
        // Devolvemos un objeto JSON, que es lo que Flutter entiende mejor
        return ResponseEntity.ok(response);
    }
}
