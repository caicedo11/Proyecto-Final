package com.Educational_harmonie.Educational_harmonie.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Reporte;
import com.Educational_harmonie.Educational_harmonie.service.Reporteservice;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/reportes") // Ruta para la App Móvil
@CrossOrigin(origins = "*")        // Vital para conectar Flutter con el Backend
public class ReporteAPI {

    @Autowired
    private Reporteservice reporteservice;

    // Obtener todos los reportes (Para que el acudiente o admin los vea en el móvil)
    @GetMapping
    public List<Reporte> listarReportes() {
        return reporteservice.listarReportes();
    }

    // Crear un nuevo reporte desde el celular
    @PostMapping("/guardar")
    public ResponseEntity<?> guardarReporte(@RequestBody Reporte reporte) {
        try {
            Reporte guardado = reporteservice.guardarReporte(reporte);
            return ResponseEntity.ok(guardado);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", "No se pudo guardar el reporte: " + e.getMessage()
            ));
        }
    }

    // Obtener un reporte específico por ID
    @GetMapping("/{id}")
    public ResponseEntity<Reporte> obtenerReporte(@PathVariable Long id) {
        // Asumiendo que tienes un método buscarPorId en tu service
        Reporte reporte = reporteservice.listarReportes().stream()
                .filter(r -> r.getId().equals(id))
                .findFirst()
                .orElse(null);
        
        return reporte != null ? ResponseEntity.ok(reporte) : ResponseEntity.notFound().build();
    }

    // Eliminar un reporte desde el móvil
    @DeleteMapping("/eliminar/{id}")
    public ResponseEntity<?> eliminarReporte(@PathVariable Long id) {
        try {
            reporteservice.eliminarReporte(id);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Reporte eliminado"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }
}