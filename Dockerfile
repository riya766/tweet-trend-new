FROM openjdk:8

# Set working directory inside container
WORKDIR /app

# Copy the JAR file from the correct path
COPY target/demo-workshop-2.1.2.jar ttrend.jar

# Run the application
ENTRYPOINT ["java", "-jar", "ttrend.jar"]
