package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"cloud-native-reference-platform/backend/handlers"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", handlers.HealthzHandler)
	mux.HandleFunc("/api/v1/hello", handlers.HelloHandler)
	mux.HandleFunc("/api/v1/info", handlers.InfoHandler)
	mux.HandleFunc("/api/v1/echo", handlers.EchoHandler)
	mux.HandleFunc("/api/v1/config", handlers.ConfigHandler)
	mux.HandleFunc("/api/v1/metrics", handlers.MetricsHandler)

	// User CRUD endpoints
	mux.HandleFunc("/api/v1/users", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodPost:
			handlers.CreateUserHandler(w, r)
		case http.MethodGet:
			handlers.ListUsersHandler(w, r)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	})
	// Handler for /api/v1/users/ endpoint (GET, PUT, DELETE)
	mux.HandleFunc("/api/v1/users/", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			// Get a single user by ID
			handlers.GetUserHandler(w, r)
		case http.MethodPut:
			// Update a user by ID
			handlers.UpdateUserHandler(w, r)
		case http.MethodDelete:
			// Delete a user by ID
			handlers.DeleteUserHandler(w, r)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	})

	// Swagger UI endpoint

	// CORS middleware
	handler := handlers.CORSMiddleware(mux)

	srv := &http.Server{
		Addr:    ":8080",
		Handler: handler,
	}

	// Graceful shutdown
	go func() {
		log.Println("[INFO] Starting server on :8080...")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("[ERROR] Server failed: %v", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("[INFO] Shutting down server...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("[ERROR] Server forced to shutdown: %v", err)
	}
	log.Println("[INFO] Server exited properly.")
}
