package com.Educational_harmonie.Educational_harmonie;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class GenerarPassword {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "admin123";
        String encoded = encoder.encode(password);
        System.out.println("==========================================");
        System.out.println("Contraseña original: " + password);
        System.out.println("Contraseña BCrypt: " + encoded);
        System.out.println("==========================================");
    }
}