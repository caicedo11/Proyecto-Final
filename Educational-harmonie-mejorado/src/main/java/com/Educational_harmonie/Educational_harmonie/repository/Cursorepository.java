package com.Educational_harmonie.Educational_harmonie.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.Educational_harmonie.Educational_harmonie.model.Curso;

@Repository
public interface Cursorepository extends JpaRepository<Curso, Long> {
    boolean existsByNombre(String nombre);
}