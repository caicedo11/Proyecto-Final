package com.Educational_harmonie.Educational_harmonie.dto;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;

public class UsuarioDTO {
    private final Long id;
    private final String nombre;
    private final String apellidop;
    private final String correo;
    private final String rol;  // Esto se mantiene para la vista
    
    // Constructor
    public UsuarioDTO(Long id, String nombre, String apellidop, String correo, String rol) {
        this.id = id;
        this.nombre = nombre;
        this.apellidop = apellidop;
        this.correo = correo;
        this.rol = rol;
    }
    
    // Getters (cambia los nombres de los métodos para que sean estándar)
    public Long getId() { return id; }
    public String getNombre() { return nombre; }
    public String getApellidop() { return apellidop; }
    public String getCorreo() { return correo; }
    public String getRol() { return rol; }
    
    // Método factory CORREGIDO
    public static UsuarioDTO from(Usuario u) {
        // Convertir idCargo a nombre de rol
        String rolNombre = convertirIdCargoARol(u.getIdCargo());
        
        return new UsuarioDTO(
            u.getId(),
            u.getNombre(),
            u.getApellidop(),
            u.getCorreo(),
            rolNombre  // ← Ahora pasamos el nombre del rol
        );
    }
    
    // Método auxiliar para convertir idCargo a String
    private static String convertirIdCargoARol(Integer idCargo) {
        if (idCargo == null) return "USUARIO";
        
        switch (idCargo) {
            case 1: return "ADMIN";
            case 2: return "DOCENTE";
            case 3: return "ACUDIENTE";
            case 4: return "ESTUDIANTE";
            default: return "USUARIO";
        }
    }
}