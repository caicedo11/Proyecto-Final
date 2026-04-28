package com.Educational_harmonie.Educational_harmonie.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Homecontroller {

    @GetMapping({"/", "/home", "/Home.html"})
    public String mostrarHome() {
        return "Home.html"; 
    }
    
}  
