package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.service.Usuarioservice;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/docente")
public class Docentecontroller {

    @Autowired
    private Usuarioservice usuarioservice;

    @GetMapping
    public String listarDocentes(Model model) {
        List<Usuario> docentes = usuarioservice.listarUsuarios().stream()
                .filter(u -> {
                    Integer idCargo = u.getIdCargo();  // CORREGIDO: getIdCargo()
                    return idCargo != null && idCargo == 2;
                })
                .collect(Collectors.toList());
        model.addAttribute("docentes", docentes);
        return "docentes/lista";
    }

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("docente", new Usuario());
        return "docentes/formulario";
    }

    @PostMapping("/guardar")
    public String guardarDocente(@ModelAttribute Usuario usuario) {
        usuario.setIdCargo(2);  // CORREGIDO: setIdCargo()
        try {
            usuarioservice.guardarUsuario(usuario);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/docente";
    }

    @GetMapping("/editar/{id}")
    public String editarDocente(@PathVariable Long id, Model model) {
        Optional<Usuario> docente = usuarioservice.buscarPorId(id);
        model.addAttribute("docente", docente.orElse(new Usuario()));
        return "docentes/formulario";
    }

    @GetMapping("/eliminar/{id}")
    public String eliminarDocente(@PathVariable Long id) {
        usuarioservice.eliminarPorId(id);
        return "redirect:/docente";
    }
}