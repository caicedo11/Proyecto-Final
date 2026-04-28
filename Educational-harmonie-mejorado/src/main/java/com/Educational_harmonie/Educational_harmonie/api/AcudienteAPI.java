package com.Educational_harmonie.Educational_harmonie.api;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Educational_harmonie.Educational_harmonie.model.Acudiente;
import com.Educational_harmonie.Educational_harmonie.service.Acudienteservice;

@RestController
@RequestMapping("/api/v1/acudientes") // Ruta estándar para la app móvil
@CrossOrigin(origins = "*")           // OBLIGATORIO: Permite que Flutter se conecte
public class AcudienteAPI {

    private final Acudienteservice service;

    public AcudienteAPI(Acudienteservice service) {
        this.service = service;
    }

    @GetMapping
    public List<Acudiente> listar() {
        return service.listar();
    }

    @PostMapping
    public ResponseEntity<Acudiente> crear(@RequestBody Acudiente acudiente) {
        // Usamos ResponseEntity para devolver un código 201 (Creado) 
        // Es mejor práctica para el desarrollo móvil
        return ResponseEntity.ok(service.guardar(acudiente));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}