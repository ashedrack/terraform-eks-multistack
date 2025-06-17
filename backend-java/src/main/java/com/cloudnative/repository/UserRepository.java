package com.cloudnative.repository;

import com.cloudnative.model.User;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

@Repository
public class UserRepository {
    private final Map<Long, User> users = new ConcurrentHashMap<>();
    private final AtomicLong idGen = new AtomicLong(1);

    public User save(User user) {
        if (user.getId() == null) {
            user.setId(idGen.getAndIncrement());
        }
        users.put(user.getId(), user);
        return user;
    }
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(users.get(id));
    }
    public List<User> findAll() {
        return new ArrayList<>(users.values());
    }
    public void delete(Long id) {
        users.remove(id);
    }
    public boolean existsById(Long id) {
        return users.containsKey(id);
    }
}
