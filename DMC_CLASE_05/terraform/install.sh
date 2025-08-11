#!/bin/bash
echo "=== Actualizando paquetes ==="
sudo apt update

echo "=== Instalando dependencias de Java ==="
sudo apt install -y fontconfig openjdk-21-jre

echo "=== Verificando versión de Java ==="
java -version

echo "=== Descargando clave GPG de Jenkins ==="
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "=== Agregando repositorio de Jenkins ==="
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

echo "=== Actualizando paquetes nuevamente ==="
sudo apt-get update

echo "=== Instalando Jenkins ==="
sudo apt-get install -y jenkins

echo "=== Instalación completa. Iniciando Jenkins ==="
sudo systemctl enable jenkins
