package com.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {

    @GetMapping("/")
    public String holaMundo() {
        return "¡Hola Mundo desde Java!!! inicio DMC clase 03 taller 02 - fecha 27/10/2026";
    }

    @GetMapping("/saludo")
    public String saludo() {
        return "Saludo desde mi aplicación Java - inicio DMC clase 03 taller 02 - fecha 27/10/2026";
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

