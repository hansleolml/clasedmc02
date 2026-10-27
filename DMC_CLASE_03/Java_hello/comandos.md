# Documentación - Comandos Docker

Este archivo contiene los comandos necesarios para construir, etiquetar y publicar la imagen Docker de la aplicación Java Spring Boot para Azure Container Apps.

## Requisitos Previos

- Docker instalado
- Cuenta en Docker Hub (o GitLab Registry)
- También sirve para Mac M1/M2: construir con la plataforma correcta

---

## Proceso de Construcción y Publicación

### Paso 1: Construir la imagen Docker

Esto crea una imagen con el tag "latest":

```bash
docker build -t mi-app-java:latest .
```

> **⚠️ Importante para Mac M1/M2:** Si estás en Mac con chip Apple Silicon, debes usar:
> ```bash
> docker build --platform linux/amd64 -t mi-app-java:latest .
> ```
> Azure Container Apps solo acepta imágenes con arquitectura `linux/amd64`.

### Paso 2: Iniciar sesión en el registry de Docker

- **Docker Hub:**
  ```bash
  docker login
  ```

- **GitLab Registry:**
  ```bash
  docker login registry.gitlab.com
  ```

### Paso 3: Crear etiquetas para un registry específico

Etiqueta la imagen con tu usuario y la versión:

```bash
docker tag mi-app-java:latest hansleolml/mi-app-java:1.0.0
```

O para Docker Hub con tu usuario:
```bash
docker tag mi-app-java:latest tuusuario/mi-app-java:latest
```

### Paso 4: Publicar la imagen al registry

```bash
docker push hansleolml/mi-app-java:1.0.0
```

O para Docker Hub:
```bash
docker push tuusuario/mi-app-java:latest
```

---

## Comandos Adicionales Útiles

### Ver todas las imágenes locales

```bash
docker images
```

### Probar la aplicación localmente

Ejecutar el contenedor en modo detached (-d) mapeando el puerto 8081 del host al 8080 del contenedor:

```bash
docker run -d --name mi-app -p 8081:8080 mi-app-java:latest
```

Luego accede a la aplicación en: http://localhost:8081

### Detener el contenedor

```bash
docker stop mi-app
```

### Eliminar el contenedor

```bash
docker rm mi-app
```

### Ver logs del contenedor

Ver logs en tiempo real:

```bash
docker logs -f mi-app
```

### Ejecutar contenedor y eliminarlo automáticamente

Útil para pruebas rápidas:

```bash
docker run --rm -p 8081:8080 mi-app-java:latest
```

---

## Notas Importantes

- **Versión de la aplicación:** 1.0.0 (según pom.xml)
- **Puerto de la aplicación:** 8080
- **Arquitectura requerida para Azure:** `linux/amd64`
- **Registry utilizado:** Docker Hub (usuario: hansleolml)

