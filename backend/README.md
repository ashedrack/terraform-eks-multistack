# Go Backend API

A minimal REST API built with Go for the cloud-native reference platform.

## Features
- `/healthz`: Health check endpoint
- `/api/v1/hello`: Example API endpoint
- Dockerfile for containerization
- Unit tests for handlers

## Local Development

```bash
cd backend
# Run the server
go run main.go
```

## Run Tests

```bash
go test ./handlers
```

## Build and Run with Docker

```bash
docker build -t go-backend .
docker run -p 8080:8080 go-backend
```

---

This service is designed to be production-ready and easily deployable to Kubernetes/EKS.
