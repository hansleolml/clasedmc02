# Construir imagen
docker build -t app-saludo-dmc-01 .

# Listar la imagen construida
docker images | grep "app“

# Ejecutar contenedor
docker run -d -p 8080:5000 app-saludo-dmc-01

# Probar con curl
curl http://localhost:8080/saludo

# Tagear la imagen
docker tag app-saludo-dmc-01:latest hansleolml/app-saludo-dmc-01:v2.0

# Logearse a DockerHub
docker login

# Subimos la imagen a DockerHub
docker push hansleolml/app-saludo-dmc-01:v2.0