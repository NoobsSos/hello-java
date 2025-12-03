FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY org.status6.hello.swing/target/*.jar swing.jar
COPY org.status6.hello.world/target/*.jar world.jar
ENTRYPOINT ["java", "-jar", "/app/swing.jar"]
