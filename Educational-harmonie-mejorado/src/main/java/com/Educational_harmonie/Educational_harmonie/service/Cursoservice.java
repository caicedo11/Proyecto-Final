package com.Educational_harmonie.Educational_harmonie.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.Educational_harmonie.Educational_harmonie.model.Curso;
import com.Educational_harmonie.Educational_harmonie.repository.Cursorepository;

@Service
public class Cursoservice {

    @Autowired
    private Cursorepository cursorepository;

    public List<Curso> listarCursos() {
        return cursorepository.findAll();
    }

    public Curso guardarCurso(Curso curso) {
        return cursorepository.save(curso);
    }

    public Curso obtenerCursoPorId(Long id) { 
        return cursorepository.findById(id).orElse(null);
    }

    public void eliminarCurso(Long id) {
        cursorepository.deleteById(id);
    }
}
