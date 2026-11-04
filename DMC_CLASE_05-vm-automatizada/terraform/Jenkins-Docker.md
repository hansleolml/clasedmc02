# Jenkins con Docker

Este documento levanta Jenkins en un contenedor, en lugar de instalarlo en Ubuntu con `apt` como hace `install.sh`. Se usa la imagen LTS gratuita `jenkins/jenkins:lts`, que ya trae Java, así que no hace falta instalar `openjdk` ni agregar el repositorio de Jenkins.

Los datos de Jenkins (trabajos, plugins, usuarios y credenciales) viven en un volumen montado en `/var/jenkins_home`. Si se borra el contenedor, esa información se conserva.

## Requisitos

- Docker instalado y el servicio en ejecución.
- Puerto `8080` libre en el host. Es la interfaz web.

## Volumen

Jenkins guarda su estado en `/var/jenkins_home` dentro del contenedor. Ese directorio incluye:

| Ruta dentro del volumen | Qué guarda |
| --- | --- |
| `jobs/` | Pipelines y trabajos |
| `plugins/` | Plugins instalados |
| `users/` | Usuarios |
| `secrets/` | Clave inicial y secretos |
| `config.xml` | Configuración global |
| `credentials.xml` | Credenciales |

Se usa un volumen con nombre, `jenkins_home`. Docker lo crea y lo administra; no depende de una carpeta del proyecto.

## Levantar Jenkins

Desde esta carpeta:

```bash
docker volume create jenkins_home

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

- `8080:8080` publica la interfaz web.
- `jenkins_home:/var/jenkins_home` monta el volumen en el directorio de datos de Jenkins.
- `jenkins/jenkins:lts` es la imagen LTS gratuita y oficial.

La interfaz queda en [http://localhost:8080](http://localhost:8080).

## Primera configuración

La contraseña de administrador inicial está dentro del volumen:

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Pégala en el asistente, instala los plugins recomendados y crea el usuario administrador. A partir de ahí el acceso ya no depende de esa clave.

## Comprobar que el volumen persiste

```bash
docker volume ls
docker volume inspect jenkins_home
```

Para verificar que los datos sobreviven al contenedor:

```bash
docker stop jenkins
docker rm jenkins

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

Al entrar de nuevo deben seguir los trabajos, plugins y el usuario creados. No vuelvas a usar la contraseña inicial.

## Operación diaria

```bash
docker ps --filter name=jenkins
docker logs -f jenkins
docker stop jenkins
docker start jenkins
```

`docker stop` y `docker start` no tocan el volumen. `docker rm jenkins` tampoco, mientras no se borre el volumen.

## Copia del volumen

```bash
docker run --rm \
  -v jenkins_home:/data:ro \
  -v "$(pwd)":/backup \
  alpine \
  tar czf /backup/jenkins_home.tar.gz -C /data .
```

Para restaurarla en un volumen vacío:

```bash
docker volume create jenkins_home

docker run --rm \
  -v jenkins_home:/data \
  -v "$(pwd)":/backup \
  alpine \
  tar xzf /backup/jenkins_home.tar.gz -C /data
```

Jenkins tiene que estar detenido durante la restauración.

## Volumen en una carpeta del host

Si prefieres ver los archivos en el disco, usa un bind mount. El proceso de Jenkins dentro de la imagen corre con UID `1000`:

```bash
mkdir -p jenkins_home
sudo chown -R 1000:1000 jenkins_home

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -v "$(pwd)/jenkins_home":/var/jenkins_home \
  jenkins/jenkins:lts
```

No subas `jenkins_home/` al repositorio: contiene secretos y credenciales.

## Apagar y borrar

```bash
docker stop jenkins
docker rm jenkins
```

Eso quita el contenedor y deja el volumen. Para borrar también los datos:

```bash
docker volume rm jenkins_home
```
