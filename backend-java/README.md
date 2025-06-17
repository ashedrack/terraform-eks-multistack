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

## Example PowerShell Commands (Java backend on port 8081)

### Health Check
```powershell
Invoke-RestMethod -Uri http://localhost:8081/healthz -Method GET
```

### Hello Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/hello -Method GET
```

### Info Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/info -Method GET
```

### Echo Endpoint (POST)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/echo -Method POST `
  -Headers @{ "Content-Type" = "application/json" } `
  -Body '{ "message": "Hello, Java!" }'
```

### Config Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/config -Method GET
```

### User Management CRUD

#### Create a User (POST)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/users -Method POST `
  -Headers @{ "Content-Type" = "application/json" } `
  -Body '{ "name": "Alice", "email": "alice@example.com" }'
```

#### List All Users (GET)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/users -Method GET
```

#### Get a User by ID (GET)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/users/1 -Method GET
```

#### Update a User (PUT)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/users/1 -Method PUT `
  -Headers @{ "Content-Type" = "application/json" } `
  -Body '{ "name": "Alice B", "email": "aliceb@example.com" }'
```

#### Delete a User (DELETE)
```powershell
Invoke-RestMethod -Uri http://localhost:8081/api/v1/users/1 -Method DELETE
```

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
