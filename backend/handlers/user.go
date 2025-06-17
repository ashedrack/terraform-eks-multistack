package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"sync"
)

type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

var (
	users      = make(map[int]User)
	nextUserID = 1
	mu         sync.Mutex
)

// CreateUserHandler handles POST /api/v1/users
func CreateUserHandler(w http.ResponseWriter, r *http.Request) {
	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		log.Printf("[ERROR] CreateUser decode: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid JSON"})
		return
	}
	if user.Name == "" || user.Email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "name and email required"})
		return
	}
	mu.Lock()
	user.ID = nextUserID
	nextUserID++
	users[user.ID] = user
	mu.Unlock()
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

// ListUsersHandler handles GET /api/v1/users
func ListUsersHandler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	userList := make([]User, 0, len(users))
	for _, u := range users {
		userList = append(userList, u)
	}
	mu.Unlock()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(userList)
}

// GetUserHandler handles GET /api/v1/users/{id}
func GetUserHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/api/v1/users/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid user id"})
		return
	}
	mu.Lock()
	user, ok := users[id]
	mu.Unlock()
	if !ok {
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "user not found"})
		return
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// UpdateUserHandler handles PUT /api/v1/users/{id}
func UpdateUserHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/api/v1/users/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid user id"})
		return
	}
	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid JSON"})
		return
	}
	if user.Name == "" || user.Email == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "name and email required"})
		return
	}
	mu.Lock()
	_, ok := users[id]
	if !ok {
		mu.Unlock()
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "user not found"})
		return
	}
	user.ID = id
	users[id] = user
	mu.Unlock()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

// DeleteUserHandler handles DELETE /api/v1/users/{id}
func DeleteUserHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/api/v1/users/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid user id"})
		return
	}
	mu.Lock()
	_, ok := users[id]
	if !ok {
		mu.Unlock()
		w.WriteHeader(http.StatusNotFound)
		json.NewEncoder(w).Encode(map[string]string{"error": "user not found"})
		return
	}
	delete(users, id)
	mu.Unlock()
	w.WriteHeader(http.StatusNoContent)
}
