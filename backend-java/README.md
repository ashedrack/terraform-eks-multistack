# Cloud Native Reference Platform - Java Backend

This is a Spring Boot REST API mirroring the Go backend, designed for cloud-native infrastructure demos and interview presentations.

## Features
- Endpoints: `/healthz`, `/api/v1/hello` (more coming)
- Ready for Docker, Swagger UI, and CI/CD

## Quick Start
```sh
mvn spring-boot:run
```

## API Docs
After starting, visit [http://localhost:8081/swagger-ui.html](http://localhost:8081/swagger-ui.html)

---

## Docker
```sh
docker build -t backend-java .
docker run -p 8081:8081 backend-java
```

---

## Structure
- `src/main/java/com/cloudnative/BackendJavaApplication.java` (main)
- `src/main/java/com/cloudnative/controller/HealthController.java`
- `src/main/java/com/cloudnative/controller/HelloController.java`

---

## To Do
- Add `/api/v1/info`, `/api/v1/echo`, `/api/v1/config`, `/api/v1/metrics`, `/api/v1/users` CRUD
- Add CORS, graceful shutdown, and Dockerfile
- Add integration tests

---

## License
MIT
