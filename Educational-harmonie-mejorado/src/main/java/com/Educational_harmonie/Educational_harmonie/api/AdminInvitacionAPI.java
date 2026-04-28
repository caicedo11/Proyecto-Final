package com.Educational_harmonie.Educational_harmonie.api;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import com.Educational_harmonie.Educational_harmonie.dto.CrearUsuarioRequest;
import com.Educational_harmonie.Educational_harmonie.dto.UsuarioDTO;
import com.Educational_harmonie.Educational_harmonie.model.Invitacion;
import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.model.UsuarioPendiente;
import com.Educational_harmonie.Educational_harmonie.service.InvitacionService;
import com.Educational_harmonie.Educational_harmonie.service.UsuarioPendienteService;
import com.Educational_harmonie.Educational_harmonie.service.Usuarioservice;

@RestController
@RequestMapping("/api/v1/admin-gestion") // Nueva ruta para Flutter
@CrossOrigin(origins = "*")              // Permite conexión desde el móvil
@PreAuthorize("hasRole('ADMIN')")
public class AdminInvitacionAPI {

    @Autowired private InvitacionService invitacionService;
    @Autowired private UsuarioPendienteService usuarioPendienteService;
    @Autowired private Usuarioservice usuarioservice;

    @GetMapping("/usuarios/listar")
    public List<UsuarioDTO> listarUsuarios() {
        return usuarioservice.listarUsuarios().stream()
                .map(UsuarioDTO::from)
                .toList();
    }

    @PostMapping("/usuarios/crear-directo")
    public ResponseEntity<Map<String, Object>> crearUsuario(@RequestBody CrearUsuarioRequest req) {
        try {
            Usuario nuevo = new Usuario();
            nuevo.setNombre(req.getNombre());
            nuevo.setApellidop(req.getApellido());
            nuevo.setCorreo(req.getCorreo());
            nuevo.setContrasena(req.getContrasena());
            nuevo.setUsuario(req.getCorreo());        
            nuevo.setIdCargo(rolAIdCargo(req.getRol()));

            usuarioservice.guardarUsuario(nuevo);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Usuario creado exitosamente"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @DeleteMapping("/usuarios/eliminar/{id}")
    public ResponseEntity<Map<String, Object>> eliminarUsuario(@PathVariable Long id) {
        try {
            usuarioservice.eliminarPorId(id);
            return ResponseEntity.ok(Map.of("success", true, "mensaje", "Usuario eliminado"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @GetMapping("/invitaciones/listar")
    public List<Invitacion> listarInvitaciones(@AuthenticationPrincipal UserDetails userDetails) {
        return usuarioservice.buscarPorUsuario(userDetails.getUsername())
                .map(admin -> invitacionService.obtenerInvitacionesPorAdmin(admin.getId()))
                .orElse(List.of());
    }

    @PostMapping("/invitaciones/generar")
    public ResponseEntity<Map<String, Object>> generarInvitacion(
            @RequestParam String correo,
            @RequestParam String rol,
            @RequestParam int horas,
            @AuthenticationPrincipal UserDetails userDetails) {

        Usuario admin = usuarioservice.buscarPorUsuario(userDetails.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("Admin no encontrado"));

        Invitacion inv = invitacionService.crearInvitacion(correo, rol, horas, admin);
        return ResponseEntity.ok(Map.of("success", true, "codigo", inv.getCodigo()));
    }

    @GetMapping("/pendientes/listar")
    public List<UsuarioPendiente> listarPendientes() {
        return usuarioPendienteService.obtenerPendientes();
    }

    @PostMapping("/pendientes/aprobar/{id}")
    public ResponseEntity<Map<String, Object>> aprobarRegistro(
            @PathVariable Long id,
            @RequestParam String usuario,
            @RequestParam String password) {
        usuarioPendienteService.aprobarRegistro(id, usuario, password);
        return ResponseEntity.ok(Map.of("success", true, "mensaje", "Usuario aprobado"));
    }

    @PostMapping("/pendientes/rechazar/{id}")
    public ResponseEntity<Map<String, Object>> rechazarRegistro(@PathVariable Long id) {
        usuarioPendienteService.rechazarRegistro(id);
        return ResponseEntity.ok(Map.of("success", true, "mensaje", "Registro rechazado"));
    }

    private int rolAIdCargo(String rol) {
        return switch (rol.toUpperCase()) {
            case "ADMIN" -> 1;
            case "DOCENTE" -> 2;
            case "ACUDIENTE" -> 3;
            case "ESTUDIANTE" -> 4;
            default -> throw new IllegalArgumentException("Rol no válido: " + rol);
        };
    }
}