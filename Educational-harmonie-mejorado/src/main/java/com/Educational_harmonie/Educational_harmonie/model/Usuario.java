package com.Educational_harmonie.Educational_harmonie.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellidop")
    private String apellidop;

    @Column(name = "apellidom")
    private String apellidom;

    @Column(name = "usuario")
    private String usuario;

    @Column(name = "correo")
    private String correo;

    @Column(name = "contrasena")
    private String contrasena;

    @Column(name = "curso")
    private String curso;

    // ✅ IMPORTANTE: este es el que viene del formulario
    @Column(name = "idcargo")
    private Integer idCargo;

    @Column(name = "aprobado")
    private Boolean aprobado;

    // Constructor vacío
    public Usuario() {}

    // Getters y Setters

    public Long getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellidop() {
        return apellidop;
    }

    public String getApellidom() {
        return apellidom;
    }

    public String getUsuario() {
        return usuario;
    }

    public String getCorreo() {
        return correo;
    }

    public String getContrasena() {
        return contrasena;
    }

    public String getCurso() {
        return curso;
    }

    public Integer getIdCargo() {
        return idCargo;
    }

    public Boolean getAprobado() {
        return aprobado;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setApellidop(String apellidop) {
        this.apellidop = apellidop;
    }

    public void setApellidom(String apellidom) {
        this.apellidom = apellidom;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public void setCurso(String curso) {
        this.curso = curso;
    }

    public void setIdCargo(Integer idCargo) {
        this.idCargo = idCargo;
    }

    public void setAprobado(Boolean aprobado) {
        this.aprobado = aprobado;
    }
}