package com.Educational_harmonie.Educational_harmonie.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;

@Repository
public interface Usuariorepository extends JpaRepository<Usuario, Long> {
    
    // ✅ CAMBIAR de Usuario a Optional<Usuario>
    Optional<Usuario> findByUsuario(String usuario);
    
    // ✅ CAMBIAR de Usuario a Optional<Usuario>
    Optional<Usuario> findByCorreo(String correo);
}