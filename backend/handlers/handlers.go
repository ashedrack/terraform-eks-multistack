package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"sync/atomic"
	"time"
)

var (
	startTime   = time.Now()
	reqCount    uint64
	buildInfo   = map[string]string{
		"version":   "1.0.0",
		"build":     "dev",
		"timestamp": time.Now().Format(time.RFC3339),
		"env":       os.Getenv("APP_ENV"),
	}
)

func HealthzHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("ok"))
}

func HelloHandler(w http.ResponseWriter, r *http.Request) {
	resp := map[string]string{"message": "Hello from Go backend!"}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}

func InfoHandler(w http.ResponseWriter, r *http.Request) {
	atomic.AddUint64(&reqCount, 1)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(buildInfo)
}

func EchoHandler(w http.ResponseWriter, r *http.Request) {
	atomic.AddUint64(&reqCount, 1)
	w.Header().Set("Content-Type", "application/json")
	var payload map[string]interface{}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		log.Printf("[ERROR] Echo decode: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid JSON"})
		return
	}
	json.NewEncoder(w).Encode(payload)
}

func ConfigHandler(w http.ResponseWriter, r *http.Request) {
	atomic.AddUint64(&reqCount, 1)
	config := map[string]string{
		"featureFlag": "true",
		"maxUsers":    "100",
		"region":      "eu-west-2",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(config)
}

func MetricsHandler(w http.ResponseWriter, r *http.Request) {
	uptime := time.Since(startTime).Seconds()
	count := atomic.LoadUint64(&reqCount)
	metrics := map[string]interface{}{
		"uptime_seconds": uptime,
		"request_count":  count,
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(metrics)
}

// CORSMiddleware adds CORS headers to responses
func CORSMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}
