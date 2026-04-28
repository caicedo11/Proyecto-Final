package com.Educational_harmonie.Educational_harmonie.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.Educational_harmonie.Educational_harmonie.model.EstadoRevision;
import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.model.UsuarioPendiente;
import com.Educational_harmonie.Educational_harmonie.repository.UsuarioPendienteRepository;
import com.Educational_harmonie.Educational_harmonie.repository.Usuariorepository;

@Service
public class UsuarioPendienteService {

    @Autowired
    private UsuarioPendienteRepository usuarioPendienteRepository;

    @Autowired
    private Usuariorepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ✅ REGISTRAR USUARIO DIRECTAMENTE EN LA TABLA usuarios
    @Transactional
    public Usuario registrarUsuario(Usuario usuario) throws Exception {
        
        System.out.println(">>> [DEBUG] Iniciando registro de usuario");
        System.out.println(">>> [DEBUG] Usuario: " + usuario.getUsuario());
        System.out.println(">>> [DEBUG] Correo: " + usuario.getCorreo());
        System.out.println(">>> [DEBUG] Nombre: " + usuario.getNombre());
        
        // Validaciones
        if (usuario.getUsuario() == null || usuario.getUsuario().trim().isEmpty()) {
            throw new Exception("El nombre de usuario es obligatorio");
        }
        
        if (usuario.getCorreo() == null || usuario.getCorreo().trim().isEmpty()) {
            throw new Exception("El correo electrónico es obligatorio");
        }
        
        if (usuario.getContrasena() == null || usuario.getContrasena().trim().isEmpty()) {
            throw new Exception("La contraseña es obligatoria");
        }
        
        if (usuario.getNombre() == null || usuario.getNombre().trim().isEmpty()) {
            throw new Exception("El nombre es obligatorio");
        }
        
        if (usuario.getApellidop() == null || usuario.getApellidop().trim().isEmpty()) {
            throw new Exception("El apellido paterno es obligatorio");
        }
        
        // Validar que no exista ya el usuario
        if (usuarioRepository.findByUsuario(usuario.getUsuario()).isPresent()) {
            System.out.println(">>> [DEBUG] El usuario YA existe en BD");
            throw new Exception("El nombre de usuario '" + usuario.getUsuario() + "' ya está registrado");
        }
        
        // Validar que no exista ya el correo
        if (usuarioRepository.findByCorreo(usuario.getCorreo()).isPresent()) {
            throw new Exception("El correo electrónico '" + usuario.getCorreo() + "' ya está registrado");
        }
        
        System.out.println(">>> [DEBUG] Usuario no existe, procediendo a guardar");
        
        // Encriptar contraseña
        usuario.setContrasena(passwordEncoder.encode(usuario.getContrasena()));
        
        // Valores por defecto
        usuario.setAprobado(true);  // Aprobado automáticamente
        
        // Guardar directamente en la tabla usuarios
        Usuario guardado = usuarioRepository.save(usuario);
        
        System.out.println(">>> [DEBUG] Usuario GUARDADO con ID: " + guardado.getId());
        System.out.println("========================================");
        System.out.println("✅ NUEVO USUARIO REGISTRADO");
        System.out.println("ID: " + guardado.getId());
        System.out.println("Usuario: " + guardado.getUsuario());
        System.out.println("Nombre: " + guardado.getNombre());
        System.out.println("Correo: " + guardado.getCorreo());
        System.out.println("========================================");
        
        // NOTIFICACIÓN PARA EL ADMIN
        System.out.println("========================================");
        System.out.println("📧 NOTIFICACIÓN PARA EL ADMINISTRADOR");
        System.out.println("Nuevo usuario registrado en el sistema:");
        System.out.println("Usuario: " + guardado.getUsuario());
        System.out.println("Nombre: " + guardado.getNombre() + " " + guardado.getApellidop());
        System.out.println("Correo: " + guardado.getCorreo());
        System.out.println("Curso: " + (guardado.getCurso() != null ? guardado.getCurso() : "No especificado"));
        System.out.println("========================================");
        System.out.println("🔔 El administrador debe revisar el panel de usuarios");
        System.out.println("========================================");
        
        return guardado;
    }
    
    // ========== MÉTODOS PARA PENDIENTES ==========
    
    public List<UsuarioPendiente> obtenerPendientes() {
        return usuarioPendienteRepository.findByEstado(EstadoRevision.PENDIENTE_REVISION);
    }
    
    public UsuarioPendiente obtenerPorId(Long id) {
        return usuarioPendienteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registro pendiente no encontrado con ID: " + id));
    }
    
    @Transactional
    public void aprobarRegistro(Long id, String usuarioGenerado, String password) {
        UsuarioPendiente pendiente = obtenerPorId(id);

        if (pendiente.getEstado() != EstadoRevision.PENDIENTE_REVISION) {
            throw new RuntimeException("Este registro ya fue procesado");
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(pendiente.getNombre());
        nuevoUsuario.setApellidop(pendiente.getApellidop());
        nuevoUsuario.setApellidom(pendiente.getApellidom());
        nuevoUsuario.setUsuario(pendiente.getUsuario());
        nuevoUsuario.setCorreo(pendiente.getCorreo());
        nuevoUsuario.setContrasena(pendiente.getContrasena());
        nuevoUsuario.setCurso(pendiente.getCurso());
        nuevoUsuario.setIdCargo(pendiente.getIdCargo());
        nuevoUsuario.setAprobado(true);
        
        usuarioRepository.save(nuevoUsuario);
        pendiente.setEstado(EstadoRevision.APROBADO);
        usuarioPendienteRepository.save(pendiente);
        
        System.out.println("✅ Usuario aprobado: " + pendiente.getUsuario());
    }
    
    @Transactional
    public void rechazarRegistro(Long id) {
        UsuarioPendiente pendiente = obtenerPorId(id);

        if (pendiente.getEstado() != EstadoRevision.PENDIENTE_REVISION) {
            throw new RuntimeException("Este registro ya fue procesado");
        }

        pendiente.setEstado(EstadoRevision.RECHAZADO);
        usuarioPendienteRepository.save(pendiente);
        
        System.out.println("❌ Usuario rechazado: " + pendiente.getUsuario());
    }
    
    public Optional<Usuario> buscarPorUsuario(String username) {
        return usuarioRepository.findByUsuario(username);
    }
    
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll();
    }
}