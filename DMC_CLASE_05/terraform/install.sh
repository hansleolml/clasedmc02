#!/bin/bash
set -euo pipefail

echo "=== Actualizando paquetes ==="
sudo apt update

echo "=== Instalando dependencias de Docker ==="
sudo apt install -y ca-certificates curl

echo "=== Agregando la clave GPG de Docker ==="
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "=== Agregando el repositorio de Docker ==="
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "=== Actualizando paquetes nuevamente ==="
sudo apt update

echo "=== Instalando Docker ==="
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Permitiendo ejecutar Docker sin sudo ==="
DOCKER_USER="${SUDO_USER:-${USER:-adminuser}}"
if [ "$DOCKER_USER" = "root" ]; then
  DOCKER_USER="adminuser"
fi
sudo usermod -aG docker "$DOCKER_USER"

echo "=== Habilitando el servicio de Docker ==="
sudo systemctl enable --now docker

echo "=== Levantando Jenkins ==="
sudo docker volume create jenkins_home
sudo docker rm -f jenkins >/dev/null 2>&1 || true
sudo docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

echo "=== Instalación completa ==="
sudo docker --version
sudo docker ps --filter name=jenkins
echo "Jenkins queda en el puerto 8080."
echo "El usuario ${DOCKER_USER} puede usar docker sin sudo después de cerrar la sesión y volver a entrar."
