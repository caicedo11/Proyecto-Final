package com.Educational_harmonie.Educational_harmonie.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.service.UsuarioPendienteService;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/registro")
@CrossOrigin(origins = "*") // Permite que el celular envíe el formulario de registro
public class RegistroPublicoAPI {

    @Autowired
    private UsuarioPendienteService usuarioPendienteService;

    // En la API no necesitamos el @GetMapping para mostrar el formulario, 
    // porque el formulario ya está dibujado en Flutter (Dart).

    @PostMapping("/completar")
    public ResponseEntity<Map<String, Object>> completarRegistro(
            @RequestParam(required = false) String codigo,
            @RequestBody Usuario usuario) {

        Map<String, Object> response = new HashMap<>();

        try {
            // Llamamos al servicio que ya tienes programado
            usuarioPendienteService.registrarUsuario(usuario);
            
            response.put("success", true);
            response.put("mensaje", "¡Registro exitoso! Ya puedes iniciar sesión.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            // Devolvemos 400 para que Flutter sepa que hubo un error de validación
            return ResponseEntity.badRequest().body(response);
        }
    }
}