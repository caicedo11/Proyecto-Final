package com.Educational_harmonie.Educational_harmonie.api;

import org.springframework.security.core.Authentication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
public class RedireccionAPI {

    @GetMapping("/perfil-rol")
    public ResponseEntity<Map<String, String>> obtenerRolActual(Authentication auth) {
        Map<String, String> respuesta = new HashMap<>();
        
        if (auth == null || !auth.isAuthenticated()) {
            respuesta.put("error", "Usuario no autenticado");
            return ResponseEntity.status(401).body(respuesta);
        }

        // Obtenemos el rol (ej: ROLE_ADMIN)
        String role = auth.getAuthorities().iterator().next().getAuthority();
        
        respuesta.put("rol", role);
        respuesta.put("nombre_usuario", auth.getName());

        // En Flutter, esto servirá para hacer un switch y cargar el menú correspondiente
        return ResponseEntity.ok(respuesta);
    }
}