package com.cloudnative.controller;

import com.cloudnative.model.User;
import com.cloudnative.model.UserRequest;
import com.cloudnative.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
public class ApiController {
    @Autowired
    private UserService userService;
    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(ApiController.class);

    // --- Health ---
    @GetMapping("/healthz")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of("status", "ok"));
    }

    // --- Hello ---
    @GetMapping("/api/v1/hello")
    public ResponseEntity<Map<String, String>> hello() {
        return ResponseEntity.ok(Map.of("message", "Hello from Java backend!"));
    }

    // --- Info ---
    @GetMapping("/api/v1/info")
    public ResponseEntity<Map<String, String>> info() {
        return ResponseEntity.ok(Map.of(
                "name", "Cloud Native Java Backend",
                "version", "1.0.0",
                "env", System.getenv().getOrDefault("APP_ENV", "dev")
        ));
    }

    // --- Echo ---
    @PostMapping("/api/v1/echo")
    public ResponseEntity<Map<String, Object>> echo(@RequestBody Map<String, Object> payload) {
        return ResponseEntity.ok(Map.of("echo", payload));
    }

    // --- Config ---
    @GetMapping("/api/v1/config")
    public ResponseEntity<Map<String, String>> config() {
        String env = System.getenv().getOrDefault("APP_ENV", "dev");
        String region = System.getenv().getOrDefault("AWS_REGION", "eu-west-2");
        return ResponseEntity.ok(Map.of(
                "APP_ENV", env,
                "AWS_REGION", region
        ));
    }

    // --- Users CRUD ---
    @PostMapping("/api/v1/users")
    public ResponseEntity<User> createUser(@RequestBody UserRequest req) {
        User user = userService.createUser(req);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/api/v1/users")
    public ResponseEntity<List<User>> listUsers() {
        return ResponseEntity.ok(userService.listUsers());
    }

    @GetMapping("/api/v1/users/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        return userService.getUser(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/api/v1/users/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody UserRequest req) {
        return userService.updateUser(id, req)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/api/v1/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        return userService.deleteUser(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
