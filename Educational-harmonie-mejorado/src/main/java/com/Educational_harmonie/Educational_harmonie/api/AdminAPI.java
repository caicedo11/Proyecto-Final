package com.Educational_harmonie.Educational_harmonie.api;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin") // Ruta base para el administrador en Flutter
@CrossOrigin(origins = "*")      // Permite la conexión desde el móvil
@PreAuthorize("hasRole('ADMIN')") // Mantenemos la seguridad que ya tienes
public class AdminAPI {

    @GetMapping("/dashboard-info")
    public ResponseEntity<Map<String, Object>> getAdminStats() {
        // En Flutter, en lugar de cargar una página, pediremos datos estadísticos
        Map<String, Object> stats = new HashMap<>();
        stats.put("estado", "Panel Administrativo Activo");
        stats.put("mensaje", "Bienvenido al sistema de control de Educational Harmonie");
        // Aquí podrías agregar conteos reales: 
        // stats.put("totalUsuarios", usuarioService.contar());
        
        return ResponseEntity.ok(stats);
    }

    // Nota: Los métodos de registro (estudiantes/usuarios) en la API 
    // usualmente reciben un @PostMapping con el objeto, no devuelven un fragmento.
    
    @GetMapping("/check-status")
    public ResponseEntity<String> checkStatus() {
        return ResponseEntity.ok("Conexión con el módulo administrativo exitosa");
    }
}
