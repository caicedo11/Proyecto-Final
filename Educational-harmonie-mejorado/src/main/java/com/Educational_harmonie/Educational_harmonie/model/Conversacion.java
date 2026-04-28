package com.Educational_harmonie.Educational_harmonie.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "conversaciones")
public class Conversacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String usuario;

    @Column(columnDefinition = "TEXT")
    private String mensajeUsuario;

    @Column(columnDefinition = "TEXT")
    private String respuestaIA;

    private LocalDateTime fechaHora;

    public Conversacion() {
        this.fechaHora = LocalDateTime.now();
    }

    public Conversacion(String usuario, String mensajeUsuario, String respuestaIA) {
        this.usuario = usuario;
        this.mensajeUsuario = mensajeUsuario;
        this.respuestaIA = respuestaIA;
        this.fechaHora = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getMensajeUsuario() {
        return mensajeUsuario;
    }

    public void setMensajeUsuario(String mensajeUsuario) {
        this.mensajeUsuario = mensajeUsuario;
    }

    public String getRespuestaIA() {
        return respuestaIA;
    }

    public void setRespuestaIA(String respuestaIA) {
        this.respuestaIA = respuestaIA;
    }

    public LocalDateTime getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(LocalDateTime fechaHora) {
        this.fechaHora = fechaHora;
    }
}
