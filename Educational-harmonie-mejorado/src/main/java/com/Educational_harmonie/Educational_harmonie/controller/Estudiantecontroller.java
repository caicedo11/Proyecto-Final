package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Educational_harmonie.Educational_harmonie.model.Estudiante;
import com.Educational_harmonie.Educational_harmonie.service.Estudianteservice;


@RestController
@RequestMapping("/estudiantes")
public class Estudiantecontroller {
    private final Estudianteservice service;

    public Estudiantecontroller(Estudianteservice service) {
        this.service = service;
    }

    @PostMapping
    public Estudiante crear(@RequestBody Estudiante estudiante) {
        return service.guardar(estudiante);
    }
}
