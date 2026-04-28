package com.Educational_harmonie.Educational_harmonie.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.Educational_harmonie.Educational_harmonie.model.Estudiante;
import com.Educational_harmonie.Educational_harmonie.service.Estudianteservice;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/estudiantes") // Ruta estandarizada para Flutter
@CrossOrigin(origins = "*")           // Vital para la conexión desde el celular
public class EstudianteAPI {
    
    private final Estudianteservice service;

    public EstudianteAPI(Estudianteservice service) {
        this.service = service;
    }

    @PostMapping("/crear")
    public ResponseEntity<?> crear(@RequestBody Estudiante estudiante) {
        try {
            Estudiante guardado = service.guardar(estudiante);
            return ResponseEntity.ok(guardado);
        } catch (Exception e) {
            // Manejo de errores para que Flutter sepa qué pasó
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "mensaje", "Error al registrar el estudiante: " + e.getMessage()
            ));
        }
    }

    // Agregamos este método que será muy útil para la App Móvil
    @GetMapping("/{id}")
    public ResponseEntity<Estudiante> obtenerPorId(@PathVariable Long id) {
        Estudiante estudiante = service.buscarPorId(id); // Asumiendo que existe en tu service
        if (estudiante != null) {
            return ResponseEntity.ok(estudiante);
        }
        return ResponseEntity.notFound().build();
    }
}
