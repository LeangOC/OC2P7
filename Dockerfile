FROM node:20-alpine AS front-builder
WORKDIR /app
COPY ./front/package*.json ./
RUN npm ci
COPY ./front .
RUN npm run build


FROM gradle:8.7-jdk17 AS back-build
WORKDIR /app
COPY ./back .
RUN sed -i 's/\r$//' gradlew
RUN ./gradlew build


FROM nginx:1.27-alpine as front
RUN rm -rf /usr/share/nginx/html/*
COPY --from=front-builder /app/dist/microcrm/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

FROM eclipse-temurin:17-jre-jammy as back
WORKDIR /app
COPY --from=back-build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]


FROM alpine:3.19 as standalone
COPY --from=front /usr/share/nginx/html /usr/share/nginx/html
COPY --from=back /app/app.jar /app/app.jar
COPY misc/docker/supervisor.ini /app/supervisor.ini
RUN apk add nginx openjdk21-jre-headless supervisor
WORKDIR /app
CMD ["/usr/bin/supervisord", "-c", "/app/supervisor.ini"]


