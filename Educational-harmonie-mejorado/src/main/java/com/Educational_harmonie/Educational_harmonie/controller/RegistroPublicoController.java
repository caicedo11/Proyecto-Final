package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.service.UsuarioPendienteService;

@Controller
@RequestMapping("/registro")
public class RegistroPublicoController {

    @Autowired
    private UsuarioPendienteService usuarioPendienteService;

    @GetMapping
    public String mostrarRegistro(@RequestParam(required = false) String codigo, Model model) {
        model.addAttribute("nuevoUsuario", new Usuario());
        model.addAttribute("codigo", codigo);
        return "Registro";
    }

    @GetMapping("/completar")
    public String mostrarRegistroCompletarGet(@RequestParam(required = false) String codigo, Model model) {
        model.addAttribute("nuevoUsuario", new Usuario());
        model.addAttribute("codigo", codigo);
        return "Registro";
    }

    @PostMapping("/completar")
    public String completarRegistro(
            @RequestParam(required = false) String codigo,
            @ModelAttribute("nuevoUsuario") Usuario usuario,
            Model model) {

        try {
            usuarioPendienteService.registrarUsuario(usuario);
            model.addAttribute("mensaje", "✅ ¡Registro exitoso! Ya puedes iniciar sesión.");
            model.addAttribute("nuevoUsuario", new Usuario());
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "❌ " + e.getMessage());
            model.addAttribute("nuevoUsuario", usuario);
        }

        model.addAttribute("codigo", codigo);
        return "Registro";
    }
}