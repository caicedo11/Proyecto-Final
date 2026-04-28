package com.Educational_harmonie.Educational_harmonie.api;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/home") // Ruta para la App Móvil
@CrossOrigin(origins = "*")      // Permite que Flutter se conecte
public class HomeAPI {

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getInitialData() {
        Map<String, Object> data = new HashMap<>();
        
        // Esta información la usará Flutter para saber que conectó bien
        data.put("mensaje", "Bienvenido a Educational Harmonie Mobile");
        data.put("sistema", "Online");
        data.put("version", "1.0.0");
        
        // Aquí podrías añadir datos generales para la pantalla principal del celular
        // Ejemplo: data.put("totalReportesHoy", reporteService.contarHoy());

        return ResponseEntity.ok(data);
    }
}