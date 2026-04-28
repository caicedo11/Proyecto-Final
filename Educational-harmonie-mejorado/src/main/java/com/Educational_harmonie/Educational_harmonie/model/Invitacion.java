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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "invitaciones")
public class Invitacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String codigo;

    @Column(nullable = false)
    private String rol;

    @Column(nullable = false)
    private String correoInvitado;

    @Column(nullable = false)
    private final LocalDateTime fechaCreacion;

    @Column(nullable = false)
    private LocalDateTime fechaExpiracion;

    @Enumerated(EnumType.STRING)
    private EstadoInvitacion estado;

    @ManyToOne
    @JoinColumn(name = "admin_id")
    private Usuario administrador;


   
    public Invitacion() {
        this.codigo = generarCodigo();
        this.fechaCreacion = LocalDateTime.now();
        this.estado = EstadoInvitacion.PENDIENTE;
    }

    private String generarCodigo() {
        return java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }


    
    public boolean isExpirada() {
        return LocalDateTime.now().isAfter(fechaExpiracion);
    }


    
    public Long getId() {
        return id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getCorreoInvitado() {
        return correoInvitado;
    }

    public void setCorreoInvitado(String correoInvitado) {
        this.correoInvitado = correoInvitado;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public LocalDateTime getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(LocalDateTime fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }

    public EstadoInvitacion getEstado() {
        return estado;
    }

    public void setEstado(EstadoInvitacion estado) {
        this.estado = estado;
    }

    public Usuario getAdministrador() {
        return administrador;
    }

    public void setAdministrador(Usuario administrador) {
        this.administrador = administrador;
    }


}