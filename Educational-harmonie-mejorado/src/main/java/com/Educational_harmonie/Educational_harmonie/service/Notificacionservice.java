package com.Educational_harmonie.Educational_harmonie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.Educational_harmonie.Educational_harmonie.model.Notificacion;
import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.repository.Notificacionrepository;
import java.util.List;

@Service
public class Notificacionservice {

    @Autowired
    private Notificacionrepository notificacionrepository;

    public Notificacion guardarNotificacion(Notificacion notificacion) {
        return notificacionrepository.save(notificacion);
    }

    public List<Notificacion> obtenerNotificacionesDocente(Usuario docente) {
        return notificacionrepository.findByDocente(docente);
    }

    public void eliminarNotificacion(Long id) {
        notificacionrepository.deleteById(id);
    }
}

