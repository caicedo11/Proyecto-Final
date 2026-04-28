package com.Educational_harmonie.Educational_harmonie.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Educational_harmonie.Educational_harmonie.model.Acudiente;
import com.Educational_harmonie.Educational_harmonie.repository.Acudienterepository;



@Service
public class Acudienteservice {
    private final Acudienterepository repository;

    public Acudienteservice(Acudienterepository repository) {
        this.repository = repository;
    }

    public List<Acudiente> listar() {
        return repository.findAll();
    }

    public Acudiente guardar(Acudiente acudiente) {
        return repository.save(acudiente);
    }

    public void eliminar(Long id) {
        repository.deleteById(id);
    }
}