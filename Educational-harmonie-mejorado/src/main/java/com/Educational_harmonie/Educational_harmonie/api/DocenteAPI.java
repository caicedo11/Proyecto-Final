package com.Educational_harmonie.Educational_harmonie.api;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.service.Usuarioservice;

@RestController
@RequestMapping("/api/v1/docentes") // Ruta para Flutter
@CrossOrigin(origins = "*")        // Permite conexión desde el móvil
public class DocenteAPI {

    @Autowired
    private Usuarioservice usuarioservice;

    @GetMapping
    public List<Usuario> listarDocentes() {
        // Filtramos solo los que tienen idCargo 2 (Docentes)
        return usuarioservice.listarUsuarios().stream()
                .filter(u -> u.getIdCargo() != null && u.getIdCargo() == 2)
                .collect(Collectors.toList());
    }

    @PostMapping("/guardar")
    public ResponseEntity<?> guardarDocente(@RequestBody Usuario usuario) {
        usuario.setIdCargo(2); // Aseguramos que sea rol Docente
        try {
            Usuario guardado = usuarioservice.guardarUsuario(usuario);
            return ResponseEntity.ok(guardado);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Error al guardar el docente"));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> obtenerDocente(@PathVariable Long id) {
        return usuarioservice.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/eliminar/{id}")
    public ResponseEntity<?> eliminarDocente(@PathVariable Long id) {
        try {
            usuarioservice.eliminarPorId(id);
            return ResponseEntity.ok(Map.of("mensaje", "Docente eliminado correctamente"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "No se pudo eliminar el docente"));
        }
    }
}