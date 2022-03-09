FROM docker.io/library/maven:3.6.1-jdk-11
COPY . .
RUN mvn clean verify
RUN chmod 777 /target/credit-service-0.0.1-SNAPSHOT.jar
CMD ["java","-jar","target/credit-service-0.0.1-SNAPSHOT.jar"]
