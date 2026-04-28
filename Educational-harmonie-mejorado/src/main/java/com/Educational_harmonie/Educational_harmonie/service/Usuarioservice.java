package com.Educational_harmonie.Educational_harmonie.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.repository.Usuariorepository;

@Service
public class Usuarioservice {

    @Autowired
    private Usuariorepository usuarioRepository;

    public Optional<Usuario> buscarPorUsuario(String username) {
        System.out.println(">>> Buscando usuario en BD: [" + username + "]");
        return usuarioRepository.findByUsuario(username.trim());
    }
    
    public Optional<Usuario> buscarPorId(Long id) {
        return usuarioRepository.findById(id);
    }
    
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll();
    }
    
    public Usuario guardarUsuario(Usuario usuario) {
        return usuarioRepository.save(usuario);
    }
    
    public void eliminarPorId(Long id) {
        usuarioRepository.deleteById(id);
    }
}