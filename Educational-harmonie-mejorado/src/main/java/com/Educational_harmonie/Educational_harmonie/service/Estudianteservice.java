package com.Educational_harmonie.Educational_harmonie.service;

import org.springframework.stereotype.Service;
import com.Educational_harmonie.Educational_harmonie.model.Estudiante;
import com.Educational_harmonie.Educational_harmonie.repository.Estudianterepository;
import java.util.List;
import java.util.Optional;

@Service
public class Estudianteservice {
    private final Estudianterepository repository;

    public Estudianteservice(Estudianterepository repository) {
        this.repository = repository;
    }

    public Estudiante guardar(Estudiante estudiante) {
        return repository.save(estudiante);
    }

    // AGREGA ESTE MÉTODO PARA QUITAR EL ROJO EN EL API
    public Estudiante buscarPorId(Long id) {
        return repository.findById(id).orElse(null);
    }

    // Opcional: Este también te servirá mucho para Flutter después
    public List<Estudiante> listarTodos() {
        return repository.findAll();
    }
}