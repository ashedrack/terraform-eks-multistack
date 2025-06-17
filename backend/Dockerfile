# Start from the official Golang image
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod init cloud-native-reference-platform/backend || true
RUN go build -o server .

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/server ./
EXPOSE 8080
CMD ["./server"]
