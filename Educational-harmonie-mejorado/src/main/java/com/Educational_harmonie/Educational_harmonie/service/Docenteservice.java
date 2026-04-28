package com.Educational_harmonie.Educational_harmonie.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.Educational_harmonie.Educational_harmonie.model.Docente;
import com.Educational_harmonie.Educational_harmonie.repository.Docenterepository;

@Service
public class Docenteservice {

    @Autowired
    private Docenterepository docenterepository;

    public List<Docente> listarDocentes() {
        return docenterepository.findAll();
    }

    public Docente guardarDocente(Docente docente) {
        return docenterepository.save(docente);
    }

    public Docente obtenerDocentePorId(Long id) { 
        return docenterepository.findById(id).orElse(null);
    }

    public void eliminarDocente(Long id) { 
        docenterepository.deleteById(id);
    }
}
