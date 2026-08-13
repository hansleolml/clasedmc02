# Construir imagen
docker build -t app-saludo-dmc-01 .

# Listar la imagen construida
docker images | grep "app"

# Copiar variables de entorno (no subir .env al repositorio)
cp .env.example .env

# Ejecutar contenedor con conexión a SQL Server
docker run -d -p 8080:5000 \
  --env-file .env \
  app-saludo-dmc-01

# Probar con curl
curl http://localhost:8080/saludo
curl http://localhost:8080/db

# Tagear la imagen
docker tag app-saludo-dmc-01:latest hansleolml/app-saludo-dmc-01:v2.0

# Logearse a DockerHub
docker login

# Subimos la imagen a DockerHub
docker push hansleolml/app-saludo-dmc-01:v2.0
