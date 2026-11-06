package com.example.controller;

import java.nio.file.Files;
import java.nio.file.Path;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {

    private static final Path IMAGEN_BOSQUE = Path.of("/mnt/bosque.jpg");

    @GetMapping("/")
    public String holaMundo() {
        return "¡Hola haciendo prueba de Jenkins";
    }

    @GetMapping("/saludo")
    public String saludo() {
        return "Hola haciendo prueba de Jenkins en Saludo";
    }

    @GetMapping("/secreto")
    public String secreto() {
        String passwordbd = System.getenv("passwordbd");
        if (passwordbd == null) {
            return "La variable de entorno passwordbd no está definida";
        }
        return passwordbd;
    }

    @GetMapping(value = "/imagen", produces = MediaType.IMAGE_JPEG_VALUE)
    public ResponseEntity<Resource> imagen() {
        if (!Files.isRegularFile(IMAGEN_BOSQUE)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_JPEG)
                .body(new FileSystemResource(IMAGEN_BOSQUE));
    }
}

