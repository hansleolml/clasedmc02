package com.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HolaMundoController {

    @GetMapping("/")
    public String holaMundo() {
        return "¡Hola Mundo desde Java!!!";
    }

    @GetMapping("/saludo")
    public String saludo() {
        return "Bienvenido a mi aplicación Java";
    }
}

