package com.Educational_harmonie.Educational_harmonie.dto;

import com.Educational_harmonie.Educational_harmonie.model.Estudiante;


public class EstudianteDTO {
    private final Long id;
    private final String nombre;
    private final String apellido;
    private final String grado;
    private final String correo;
    private final String telefono;

    public EstudianteDTO(Long id, String nombre, String apellido, String grado, String correo, String telefono) {
        this.id = id;
        this.nombre = nombre;
        this.apellido = apellido;
        this.grado = grado;
        this.correo = correo;
        this.telefono = telefono;
    }

    public Long getId() { return id; }
    public String getNombre() { return nombre; }
    public String getApellido() { return apellido; }
    public String getGrado() { return grado; }
    public String getCorreo() { return correo; }
    public String getTelefono() { return telefono; }

    public static EstudianteDTO from(Estudiante e) {
        return new EstudianteDTO(
            e.getId(),
            e.getNombre(),
            e.getApellido(),
            e.getGrado(),
            e.getCorreo(),
            e.getTelefono()
        );
    }
}
