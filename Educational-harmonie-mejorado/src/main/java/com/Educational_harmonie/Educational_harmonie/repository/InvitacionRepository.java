package com.Educational_harmonie.Educational_harmonie.repository;


import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Educational_harmonie.Educational_harmonie.model.EstadoInvitacion;
import com.Educational_harmonie.Educational_harmonie.model.Invitacion;




public interface InvitacionRepository extends JpaRepository<Invitacion, Long> {
    Optional<Invitacion> findByCodigo(String codigo);
    List<Invitacion> findByEstado(EstadoInvitacion estado);
    List<Invitacion> findByAdministradorId(Long adminId);
    List<Invitacion> findByCorreoInvitado(String correo);
}