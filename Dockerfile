# Build stage: compile the Spring Boot jar inside Docker
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Cache dependencies first
COPY pom.xml ./
COPY .mvn .mvn
COPY mvnw ./
RUN chmod +x mvnw && ./mvnw -q -DskipTests dependency:go-offline

# Copy source and package
COPY src src
RUN ./mvnw clean package -DskipTests

# Runtime stage: run only the built jar on a slim JRE image
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/ci_cd_test-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
