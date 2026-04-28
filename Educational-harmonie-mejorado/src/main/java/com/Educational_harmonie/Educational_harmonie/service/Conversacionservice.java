package com.Educational_harmonie.Educational_harmonie.service;

import com.Educational_harmonie.Educational_harmonie.model.Conversacion;
import com.Educational_harmonie.Educational_harmonie.repository.Conversacionrepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class Conversacionservice {

    private final Conversacionrepository conversacionrepository;

  
    public Conversacionservice(Conversacionrepository conversacionrepository) {
        this.conversacionrepository = conversacionrepository;
    }

    public void guardarConversacion(Conversacion conversacion) {
        conversacionrepository.save(conversacion);
    }

    public List<Conversacion> obtenerConversaciones(String usuario) {
        return conversacionrepository.findByUsuarioOrderByFechaHoraDesc(usuario);
    }
}
