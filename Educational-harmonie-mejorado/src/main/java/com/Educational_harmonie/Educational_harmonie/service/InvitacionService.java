package com.Educational_harmonie.Educational_harmonie.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.Educational_harmonie.Educational_harmonie.model.EstadoInvitacion;
import com.Educational_harmonie.Educational_harmonie.model.Invitacion;
import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.repository.InvitacionRepository;

@Service
public class InvitacionService {

    @Autowired
    private InvitacionRepository invitacionRepository;

    @Autowired(required = false)
    private EmailService emailService;


 
    @Transactional
    public Invitacion crearInvitacion(String correo, String rol, int horasValidez, Usuario admin) {

        if (correo == null || correo.isEmpty()) {
            throw new IllegalArgumentException("El correo es obligatorio");
        }

        if (rol == null || rol.isEmpty()) {
            throw new IllegalArgumentException("El rol es obligatorio");
        }

        if (admin == null) {
            throw new IllegalArgumentException("El administrador es obligatorio");
        }

        Invitacion invitacion = new Invitacion();
        invitacion.setCorreoInvitado(correo);
        invitacion.setRol(rol);
        invitacion.setCodigo(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        invitacion.setFechaExpiracion(LocalDateTime.now().plusHours(horasValidez));
        invitacion.setAdministrador(admin);
        invitacion.setEstado(EstadoInvitacion.PENDIENTE);

        Invitacion guardada = invitacionRepository.save(invitacion);

       if (emailService != null) {
    try {
        emailService.enviarInvitacion(correo, guardada.getCodigo(), rol, horasValidez);
    } catch (Exception e) {
        e.printStackTrace(); // 🔥 muestra el error real en consola
    }
}

        return guardada;
    }


   
    public Invitacion validarInvitacion(String codigo) {

        if (codigo == null || codigo.isEmpty()) {
            return null;
        }

        return invitacionRepository.findByCodigo(codigo)
                .filter(inv -> !inv.isExpirada())
                .filter(inv -> inv.getEstado() == EstadoInvitacion.PENDIENTE)
                .orElse(null);
    }


 
    public List<Invitacion> obtenerInvitacionesPorAdmin(Long adminId) {

        if (adminId == null) {
            throw new IllegalArgumentException("El ID de administrador es obligatorio");
        }

        return invitacionRepository.findByAdministradorId(adminId);
    }


  
    @Transactional
    public void eliminarPorId(Long id) {
        if (!invitacionRepository.existsById(id)) {
            throw new RuntimeException("No existe una invitación con ID: " + id);
        }
        invitacionRepository.deleteById(id);
    }


   
    public Invitacion obtenerPorId(Long id) {
        return invitacionRepository.findById(id).orElse(null);
    }
}