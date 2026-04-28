package com.Educational_harmonie.Educational_harmonie.api;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/v1/chat") // Cambiamos la ruta para seguir el estándar de la app móvil
@CrossOrigin(origins = "*") 
public class ChatAPI {

    // TIP PARA LA NUBE: En el futuro, cambiaremos 'localhost' por la IP de tu servidor de IA
    private final String OLLAMA_URL = "http://localhost:11434/api/generate"; 

    @PostMapping("/preguntar")
    public ResponseEntity<Map<String, Object>> chatMovil(@RequestBody Map<String, String> request) {
        String mensajeUsuario = request.get("message");
        Map<String, Object> result = new HashMap<>();

        // Mantenemos tu lógica de contexto (Muy buena para Minería de Datos II)
        String contexto = "Eres el asistente virtual oficial del sistema web educativo 'Educational Harmonie'.\n" +
                "Este proyecto gestiona reportes disciplinarios, usuarios (docentes, acudientes, estudiantes, coordinadores),\n" +
                "formularios, visualizaciones y control institucional.\n" +
                "Tu función es responder únicamente preguntas relacionadas con este proyecto, su uso, funcionalidades o arquitectura.\n" +
                "Si la pregunta no tiene relación con Educational Harmonie, debes responder literalmente:\n" +
                "\"Lo siento, no estoy entrenado para responder esa pregunta.\"\n" +
                "Responde de forma breve, clara y en español.";

        Map<String, Object> body = new HashMap<>();
        body.put("model", "gemma:2b");
        body.put("prompt", contexto + "\n\nPregunta del usuario: " + mensajeUsuario);
        body.put("stream", false);

        RestTemplate restTemplate = new RestTemplate();

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(OLLAMA_URL, body, Map.class);
            Map responseBody = response.getBody();
            if (responseBody != null) {
                String respuesta = (String) responseBody.get("response");
                result.put("reply", respuesta);
            } else {
                result.put("reply", "⚠ El asistente no está disponible.");
            }
        } catch (RestClientException e) {
            // Error común si Ollama no está corriendo
            result.put("reply", "⚠ Error de conexión con el motor de IA.");
        }

        return ResponseEntity.ok(result);
    }
}