# Imagen base de Maven con Java
FROM maven:3.9-eclipse-temurin-17 AS build

# Directorio de trabajo
WORKDIR /app

# Copiar pom.xml
COPY pom.xml .

# Descargar dependencias
RUN mvn dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Construir la aplicación
RUN mvn clean package -DskipTests

# Imagen final más pequeña
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copiar el JAR desde la etapa de build
COPY --from=build /app/target/mi-app-java-1.0.0.jar app.jar

# Exponer puerto
EXPOSE 8080

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]

