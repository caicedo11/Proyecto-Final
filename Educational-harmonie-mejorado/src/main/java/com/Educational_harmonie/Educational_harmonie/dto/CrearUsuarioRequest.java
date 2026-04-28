package com.Educational_harmonie.Educational_harmonie.dto;


public class CrearUsuarioRequest {
    private final String nombre;
    private final String apellido;
    private final String correo;
    private final String contrasena;
    private final String rol;
    private final String telefono;
    private final String direccion;

    public CrearUsuarioRequest(String nombre, String apellido, String correo, String contrasena, String rol, String telefono, String direccion) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.contrasena = contrasena;
        this.rol = rol;
        this.telefono = telefono;
        this.direccion = direccion;
    }

    public String getNombre() { return nombre; }
    public String getApellido() { return apellido; }
    public String getCorreo() { return correo; }
    public String getContrasena() { return contrasena; }
    public String getRol() { return rol; }
    public String getTelefono() { return telefono; }
    public String getDireccion() { return direccion; }
}
