package com.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {

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
}

