package com.Educational_harmonie.Educational_harmonie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    // Correo al admin con links de aprobación/rechazo
    public void enviarCorreoRegistro(Usuario usuario) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo("admin@tuempresa.com");
        mensaje.setSubject("Nuevo registro pendiente de aprobación");
        mensaje.setText("Se ha registrado un nuevo usuario:\n\n" +
                "Nombre: " + usuario.getNombre() + "\n" +
                "Apellido Paterno: " + usuario.getApellidop() + "\n" +
                "Apellido Materno: " + usuario.getApellidom() + "\n" +
                "Usuario: " + usuario.getUsuario() + "\n" +
                "Correo: " + usuario.getCorreo() + "\n" +
                "Curso: " + usuario.getCurso() + "\n\n" +
                "Para aprobar: " + baseUrl + "/aprobar/" + usuario.getId() + "\n" +
                "Para rechazar: " + baseUrl + "/rechazar/" + usuario.getId());

        mailSender.send(mensaje);
    }

    // Notificación al usuario según decisión del admin
    public void notificarUsuario(Usuario usuario, boolean aprobado) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(usuario.getCorreo());

        if (aprobado) {
            mensaje.setSubject("Registro aprobado");
            mensaje.setText("Hola " + usuario.getNombre() + ",\n\nTu registro ha sido aprobado. ¡Bienvenido!");
        } else {
            mensaje.setSubject("Registro rechazado");
            mensaje.setText("Hola " + usuario.getNombre() + ",\n\nTu registro no ha sido aprobado. Contacta al administrador para más información.");
        }

        mailSender.send(mensaje);
    }

    // Enviar invitación a un correo con código y rol
    public void enviarInvitacion(String correo, String codigo, String rol, int horasValidez) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(correo);
        mensaje.setSubject("Invitación para registrarte en Educational Harmonie");
        mensaje.setText("Has sido invitado a registrarte en la plataforma.\n\n" +
                "Rol asignado: " + rol + "\n" +
                "Código de invitación: " + codigo + "\n" +
                "Enlace de registro: " + baseUrl + "/registro?codigo=" + codigo + "\n" +
                "Validez: " + horasValidez + " horas\n\n" +
                "Si no solicitaste esta invitación, ignora este correo.");

        mailSender.send(mensaje);
    }

    // Opcional: enviar credenciales al usuario una vez aprobado
    public void enviarCredenciales(String correo, String usuario, String password) {
        SimpleMailMessage mensaje = new SimpleMailMessage();
        mensaje.setTo(correo);
        mensaje.setSubject("Tus credenciales de acceso");
        mensaje.setText("Usuario: " + usuario + "\nContraseña: " + password + "\n\nEnlace de login: " + baseUrl + "/login");

        mailSender.send(mensaje);
    }
}
