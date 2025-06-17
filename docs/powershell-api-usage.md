# PowerShell API Usage Guide

This guide provides ready-to-use PowerShell (`Invoke-RestMethod`) commands for interacting with all endpoints of the Go backend API. You can copy and paste these commands directly into your PowerShell terminal.

---

## Health Check
```powershell
Invoke-RestMethod -Uri http://localhost:8080/healthz -Method GET
```

## Hello Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/hello -Method GET
```

## Info Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/info -Method GET
```

## Echo Endpoint (POST)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/echo -Method POST \
  -Headers @{ "Content-Type" = "application/json" } \
  -Body '{ "message": "Hello, world!" }'
```

## Config Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/config -Method GET
```

## Metrics Endpoint
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/metrics -Method GET
```

---

# User Management CRUD

## Create a User (POST)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/users -Method POST \
  -Headers @{ "Content-Type" = "application/json" } \
  -Body '{ "name": "Alice", "email": "alice@example.com" }'
```

## List All Users (GET)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/users -Method GET
```

## Get a User by ID (GET)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/users/1 -Method GET
```

## Update a User (PUT)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/users/1 -Method PUT \
  -Headers @{ "Content-Type" = "application/json" } \
  -Body '{ "name": "Alice B", "email": "aliceb@example.com" }'
```

## Delete a User (DELETE)
```powershell
Invoke-RestMethod -Uri http://localhost:8080/api/v1/users/1 -Method DELETE
```

---

**Tip:** Replace `1` with the actual user ID as needed. You can format the commands on a single line if you prefer.

---

## Troubleshooting
- If you get an error about headers or method, ensure you are using PowerShell, not Command Prompt.
- For Windows Command Prompt or Git Bash, use standard `curl` commands instead.

---

For more endpoints or advanced usage, see the Swagger UI at [http://localhost:8080/swagger/index.html](http://localhost:8080/swagger/index.html)
