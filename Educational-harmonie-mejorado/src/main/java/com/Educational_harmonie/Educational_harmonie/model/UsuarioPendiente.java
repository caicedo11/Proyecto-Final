package com.Educational_harmonie.Educational_harmonie.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "usuarios_pendientes")
public class UsuarioPendiente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "invitacion_id")
    private Invitacion invitacion;

    // ========== CAMPOS ==========
    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private String apellidop;

    private String apellidom;

    @Column(nullable = false, unique = true)
    private String usuario;

    @Column(nullable = false, unique = true)
    private String correo;

    @Column(nullable = false)
    private String contrasena;

    private String curso;

    // ✅ NUEVO CAMPO (CLAVE)
    @Column(name = "idcargo")
    private Integer idCargo;

    @Enumerated(EnumType.STRING)
    private EstadoRevision estado;

    private String errores;

    private LocalDateTime fechaCompletado;

    // Constructor
    public UsuarioPendiente() {
        this.fechaCompletado = LocalDateTime.now();
        this.estado = EstadoRevision.PENDIENTE_REVISION;
    }

    // ========== GETTERS Y SETTERS ==========

    public Long getId() {
        return id;
    }

    public Invitacion getInvitacion() {
        return invitacion;
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

    public EstadoRevision getEstado() {
        return estado;
    }

    public String getErrores() {
        return errores;
    }

    public LocalDateTime getFechaCompletado() {
        return fechaCompletado;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setInvitacion(Invitacion invitacion) {
        this.invitacion = invitacion;
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

    public void setEstado(EstadoRevision estado) {
        this.estado = estado;
    }

    public void setErrores(String errores) {
        this.errores = errores;
    }

    public void setFechaCompletado(LocalDateTime fechaCompletado) {
        this.fechaCompletado = fechaCompletado;
    }
}