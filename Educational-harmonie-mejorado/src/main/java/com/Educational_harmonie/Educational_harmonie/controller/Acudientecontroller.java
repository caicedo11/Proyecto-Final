package com.Educational_harmonie.Educational_harmonie.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Educational_harmonie.Educational_harmonie.model.Acudiente;
import com.Educational_harmonie.Educational_harmonie.service.Acudienteservice;

@RestController
@RequestMapping("/acudientes")
public class Acudientecontroller {
    private final Acudienteservice service;

    public Acudientecontroller(Acudienteservice service) {
        this.service = service;
    }

    @GetMapping
    public List<Acudiente> listar() {
        return service.listar();
    }

    @PostMapping
    public Acudiente crear(@RequestBody Acudiente acudiente) {
        return service.guardar(acudiente);
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Long id) {
        service.eliminar(id);
    }
}