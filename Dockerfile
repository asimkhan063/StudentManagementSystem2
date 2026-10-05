FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY target/School_management-0.0.1-SNAPSHOT.war app.war

EXPOSE 8181

ENTRYPOINT ["java", "-jar", "app.war"]