FROM maven:3-jdk-8 as builder
COPY . /app
WORKDIR /app
RUN mvn clean install

FROM openjdk:8-jre
VOLUME ["/hygieia/logs"]
RUN mkdir -p /hygieia/config
EXPOSE 8080
ENV PROP_FILE /hygieia/config/application.properties
WORKDIR /hygieia
COPY --from=builder /app/target/*.jar /hygieia/
COPY --from=builder app/docker/properties-builder.sh /hygieia/
CMD ./properties-builder.sh &&\
  java -Djava.security.egd=file:/dev/./urandom -jar *.jar --spring.config.location=$PROP_FILE
