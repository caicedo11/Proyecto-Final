package com.Educational_harmonie.Educational_harmonie.api;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder; // ✅ IMPORTANTE
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.repository.Usuariorepository;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*") 
public class LoginAPI {

    @Autowired
    private Usuariorepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder; // ✅ Inyectamos el encoder de SecurityConfig

    @PostMapping("/login")
    public ResponseEntity<?> loginMovil(@RequestBody Map<String, String> credenciales) {
        String username = credenciales.get("usuario");
        String password = credenciales.get("contrasena");

        Optional<Usuario> userOpt = usuarioRepository.findByUsuario(username);

        if (userOpt.isPresent()) {
            Usuario user = userOpt.get();
            
            // ✅ FORMA CORRECTA DE COMPARAR CON BCRYPT
            if (passwordEncoder.matches(password, user.getContrasena())) {
                return ResponseEntity.ok(user);
            }
        }
        
        Map<String, String> error = new HashMap<>();
        error.put("mensaje", "Credenciales incorrectas");
        return ResponseEntity.status(401).body(error);
    }
}