package com.Educational_harmonie.Educational_harmonie.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Educational_harmonie.Educational_harmonie.model.Notificacion;
import com.Educational_harmonie.Educational_harmonie.model.Usuario;



@Repository
public interface Notificacionrepository extends JpaRepository<Notificacion, Long> {
    List<Notificacion> findByDocente(Usuario docente);
}