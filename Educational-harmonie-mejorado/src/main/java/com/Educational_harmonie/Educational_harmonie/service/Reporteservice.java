package com.Educational_harmonie.Educational_harmonie.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import com.Educational_harmonie.Educational_harmonie.model.Reporte;
import com.Educational_harmonie.Educational_harmonie.repository.Reporterepository;

@Service
public class Reporteservice {

    @Autowired
    private Reporterepository reporterepository;

    public List<Reporte> listarReportes() {
        return reporterepository.findAll();
    }

    public Reporte guardarReporte(Reporte reporte) {
        return reporterepository.save(reporte);
    }

    public Reporte obtenerReporte(Long id) {
        return reporterepository.findById(id).orElse(null);
    }

    public void eliminarReporte(Long id) {
        reporterepository.deleteById(id);
    }
}

