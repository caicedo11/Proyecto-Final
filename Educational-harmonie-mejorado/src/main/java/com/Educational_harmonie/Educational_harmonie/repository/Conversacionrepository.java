package com.Educational_harmonie.Educational_harmonie.repository;

import com.Educational_harmonie.Educational_harmonie.model.Conversacion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface Conversacionrepository extends JpaRepository<Conversacion, Long> {
    List<Conversacion> findByUsuarioOrderByFechaHoraDesc(String usuario);
}
