FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/devops-integration.jar /app/
EXPOSE 8090
CMD [ "java","-jar","devops-integration.jar" ]
