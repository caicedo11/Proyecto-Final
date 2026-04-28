package com.Educational_harmonie.Educational_harmonie.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.Educational_harmonie.Educational_harmonie.model.Reporte;

@Repository
public interface Reporterepository extends JpaRepository<Reporte, Long> {
}