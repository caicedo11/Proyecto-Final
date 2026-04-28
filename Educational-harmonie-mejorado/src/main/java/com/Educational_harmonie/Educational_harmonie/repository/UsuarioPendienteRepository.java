package com.Educational_harmonie.Educational_harmonie.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Educational_harmonie.Educational_harmonie.model.EstadoRevision;
import com.Educational_harmonie.Educational_harmonie.model.UsuarioPendiente;

@Repository
public interface UsuarioPendienteRepository extends JpaRepository<UsuarioPendiente, Long> {
    
    List<UsuarioPendiente> findByEstado(EstadoRevision estado);
    
    Optional<UsuarioPendiente> findByUsuario(String usuario);
    
    Optional<UsuarioPendiente> findByInvitacionId(Long invitacionId);
}