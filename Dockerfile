### Stage 1 : Build client
FROM ubuntu:20.10 AS build-client
RUN apt update && apt install -y git curl unzip xz-utils zip wget libglu1-mesa

WORKDIR /app
RUN git clone https://github.com/flutter/flutter.git -b beta
ENV PATH "$PATH:/app/flutter/bin"
RUN flutter doctor

COPY ./kepaso_client /app
RUN flutter config --enable-web
RUN flutter build web


### Stage 2 : Build server
FROM quay.io/quarkus/centos-quarkus-maven:20.1.0-java11 AS build
COPY ./kepaso-server/pom.xml /usr/src/app/pom.xml
#RUN mvn -f /usr/src/app/pom.xml -B de.qaware.maven:go-offline-maven-plugin:1.2.5:resolve-dependencies
COPY ./kepaso-server/src /usr/src/app/src
COPY --from=build-client /app/build/web /usr/src/app/src/main/resources/META-INF/resources
USER root
RUN chown -R quarkus /usr/src/app
USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package

### Source of libs
FROM debian:stable-slim AS lib-env
#
### Stage 2 : create the docker final image
FROM gcr.io/distroless/base
COPY --from=lib-env /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6
COPY --from=lib-env /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=lib-env /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=build /usr/src/app/target/*-runner /work/application
WORKDIR /work
EXPOSE 8080
CMD ["./application", "-Dquarkus.http.host=0.0.0.0", "-Xmx64m"]

