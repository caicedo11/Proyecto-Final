package com.Educational_harmonie.Educational_harmonie;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class EducationalHarmonieApplication {

    public static void main(String[] args) {

        // 🔥 PRUEBA DE HASH
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String hash = "$2a$10$/LrC5FM2d9FZHkAgDHGHBeTohnYIExl1YkDb.W8o/b6sVwlnBa0M2";

        System.out.println("¿Coincide 123 con el hash?");
        System.out.println(encoder.matches("123", hash));

        SpringApplication.run(EducationalHarmonieApplication.class, args);
    }
}