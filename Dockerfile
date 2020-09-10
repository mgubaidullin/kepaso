### Stage 1 : Build client
FROM ubuntu:20.10 AS build-client
RUN apt update && apt install -y git curl unzip xz-utils zip wget libglu1-mesa

WORKDIR /app
# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b beta
ENV PATH "$PATH:/app/flutter/bin"
RUN flutter doctor

COPY . /app
WORKDIR /app/kepaso_client
RUN flutter config --enable-web
RUN flutter build web


## Stage 2 : Build server
FROM ubuntu:20.10 AS build-server
RUN apt-get update && apt-get install -y gnupg2 wget apt-transport-https
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && apt-get install dart=2.7.*
ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:/root/.pub-cache/bin:$PATH
RUN pub global activate aqueduct 4.0.0-b1

COPY . /app
WORKDIR /app/kepaso_server
RUN pub get
RUN aqueduct build

## Stage 3 : Create the docker final image
#FROM alpine:latest
FROM gcr.io/distroless/base:latest
COPY --from=build-server /usr/lib/dart/bin/dartaotruntime /usr/lib/dart/bin/dartaotruntime
ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:$PATH

WORKDIR /app
COPY --from=build-server /app/kepaso_server/kepaso_server.aot /app
COPY --from=build-client /app/kepaso_client/build/web /app/web
EXPOSE 8080
ENTRYPOINT ["/app/kepaso_server.aot","--port","8080","--isolates","4"]

