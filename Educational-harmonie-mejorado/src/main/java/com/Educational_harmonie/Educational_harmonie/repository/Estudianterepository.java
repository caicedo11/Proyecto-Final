package com.Educational_harmonie.Educational_harmonie.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Educational_harmonie.Educational_harmonie.model.Estudiante;



public interface Estudianterepository extends JpaRepository<Estudiante, Long> {
    Optional<Estudiante> findByCorreo(String correo);
}