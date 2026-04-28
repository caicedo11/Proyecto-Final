package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Reporte;
import com.Educational_harmonie.Educational_harmonie.service.Reporteservice;

import java.util.List;

@Controller
@RequestMapping("/reportes")
public class Reportecontroller {

    @Autowired
    private Reporteservice reporteservice;


    @GetMapping
    public String listarReportes(Model model) {
        List<Reporte> reportes = reporteservice.listarReportes();
        model.addAttribute("reportes", reportes);
        return "reportes/lista";  
    }

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("reporte", new Reporte());
        return "reportes/formulario"; 
    }

  
    @PostMapping("/guardar")
    public String guardarReporte(@ModelAttribute("reporte") Reporte reporte) {
        reporteservice.guardarReporte(reporte);
        return "redirect:/reportes";
    }

 
    @GetMapping("/eliminar/{id}")
    public String eliminarReporte(@PathVariable("id") Long id) {
        reporteservice.eliminarReporte(id);
        return "redirect:/reportes";
    }
}




