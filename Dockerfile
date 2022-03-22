FROM docker.io/library/maven:3.6.1-jdk-11
COPY . .
RUN ls -l
RUN mvn clean verify
RUN chmod 777 /target/account-service-0.0.1-SNAPSHOT.jar
CMD ["java","-jar","target/account-service-0.0.1-SNAPSHOT.jar"]
