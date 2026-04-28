package com.Educational_harmonie.Educational_harmonie.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.Educational_harmonie.Educational_harmonie.model.Usuario;
import com.Educational_harmonie.Educational_harmonie.service.Usuarioservice;

@Configuration
public class SecurityConfig {

    // 1. SERVICIO DE DETALLES DE USUARIO (Para Web y Móvil)
    @Bean
    public UserDetailsService userDetailsService(Usuarioservice usuarioservice) {
        return username -> {
            Usuario usuario = usuarioservice.buscarPorUsuario(username)
                    .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));

            int idCargo = usuario.getIdCargo() != null ? usuario.getIdCargo() : 5;
            
            return User.builder()
                    .username(usuario.getUsuario())
                    .password(usuario.getContrasena())
                    .roles(obtenerRolPorCargo(idCargo))
                    .build();
        };
    }

    private String obtenerRolPorCargo(int idCargo) {
        switch (idCargo) {
            case 1: return "ADMIN";
            case 2: return "DOCENTE";
            case 3: return "ACUDIENTE";
            case 4: return "ESTUDIANTE";
            default: return "USUARIO";
        }
    }

    // 2. CODIFICADOR DE CONTRASEÑAS
    // Nota: Si tus claves en DB son texto plano, usa NoOpPasswordEncoder (solo para pruebas)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); 
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider(UserDetailsService userDetailsService) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    // =========================================================================
    // 3. FILTRO PARA LA API (FLUTTER / MÓVIL) - TIENE PRIORIDAD
    // =========================================================================
    @Bean
    @Order(1)
    public SecurityFilterChain apiSecurity(HttpSecurity http) throws Exception {
        http
            .securityMatcher("/api/**") // Solo aplica para rutas que empiecen con /api
            .csrf(AbstractHttpConfigurer::disable) // Deshabilitar CSRF es vital para APIs
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**", "/api/v1/test/**").permitAll() // Login y Test son públicos
                .anyRequest().authenticated()
            );
        return http.build();
    }

    // =========================================================================
    // 4. FILTRO PARA LA WEB (THYMELEAF)
    // =========================================================================
    @Bean
    @Order(2)
    public SecurityFilterChain appSecurity(HttpSecurity http, DaoAuthenticationProvider provider) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable) // Deshabilitado para facilitar el desarrollo
            .authenticationProvider(provider)
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers("/", "/home", "/login", "/registro/**", "/registro/completar",
                            "/css/**", "/js/**", "/img/**", "/static/**")
                    .permitAll()
                    .requestMatchers("/admin/**").hasRole("ADMIN")
                    .requestMatchers("/docente/**").hasRole("DOCENTE")
                    .requestMatchers("/acudiente/**").hasRole("ACUDIENTE")
                    .requestMatchers("/estudiante/**").hasRole("ESTUDIANTE")
                    .anyRequest().authenticated()
            )
            .formLogin(form -> form
                    .loginPage("/login")
                    .loginProcessingUrl("/login")
                    .usernameParameter("username")
                    .passwordParameter("password")
                    .defaultSuccessUrl("/redirect", true)
                    .failureUrl("/login?error=true")
                    .permitAll()
            )
            .logout(logout -> logout
                    .logoutUrl("/logout")
                    .logoutSuccessUrl("/login?logout")
                    .permitAll()
            );
        return http.build();
    }
}