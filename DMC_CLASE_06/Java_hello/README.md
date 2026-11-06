# Mi App Java - Hola Mundo

Aplicación Java simple desarrollada con Spring Boot que muestra "Hola Mundo" al acceder a su URL.

## Descripción

Este proyecto es una aplicación web Java construida con Spring Boot que responde con un mensaje de bienvenida cuando accedes a sus endpoints. La aplicación está configurada para ejecutarse en el puerto 8080.

## Tecnologías

- **Java 17**
- **Spring Boot 3.2.0**
- **Maven** (Gestión de dependencias)
- **Docker** (Containerización)

## Estructura del Proyecto

```
prueba/
├── .gitlab-ci.yml          # Pipeline de CI/CD
├── Dockerfile              # Configuración Docker
├── pom.xml                 # Dependencias Maven
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/
│       │       ├── MiAppApplication.java          # Clase principal
│       │       └── controller/
│       │           └── HolaMundoController.java   # Controlador REST
│       └── resources/
│           └── application.properties             # Configuración
└── README.md

```

## Endpoints

- `GET /` - Devuelve "¡Hola Mundo desde Java!"
- `GET /saludo` - Devuelve "Bienvenido a mi aplicación Java"

## Ejecución Local

### Pre-requisitos

- Java 17 o superior
- Maven 3.x

### Pasos

1. Compilar el proyecto:
```bash
./mvnw clean package
```

2. Ejecutar la aplicación:
```bash
java -jar target/mi-app-java-1.0.0.jar
```

3. Acceder a la aplicación:
- http://localhost:8080/
- http://localhost:8080/saludo

## Ejecución con Docker

### Construir la imagen:
```bash
docker build -t mi-app-java:latest .
```

### Ejecutar el contenedor:
```bash
docker run -d --name mi-app -p 8080:8080 mi-app-java:latest
```

### Acceder a la aplicación:
- http://localhost:8080/
- http://localhost:8080/saludo

## GitLab CI/CD

El proyecto incluye un pipeline de GitLab CI/CD configurado en `.gitlab-ci.yml` que:

1. **Etapa Build**: Construye la imagen Docker de la aplicación
2. **Etapa Deploy**: Despliega la aplicación en un contenedor

El pipeline se ejecuta automáticamente cuando se hace push al repositorio.

## Autor

Desarrollado para ONPE - Instituto DMC
