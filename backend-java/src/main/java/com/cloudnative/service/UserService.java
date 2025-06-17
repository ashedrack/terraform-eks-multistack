package com.cloudnative.service;

import com.cloudnative.model.User;
import com.cloudnative.model.UserRequest;
import com.cloudnative.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User createUser(UserRequest req) {
        User user = new User(null, req.getName(), req.getEmail());
        return userRepository.save(user);
    }
    public List<User> listUsers() {
        return userRepository.findAll();
    }
    public Optional<User> getUser(Long id) {
        return userRepository.findById(id);
    }
    public Optional<User> updateUser(Long id, UserRequest req) {
        return userRepository.findById(id).map(user -> {
            user.setName(req.getName());
            user.setEmail(req.getEmail());
            return userRepository.save(user);
        });
    }
    public boolean deleteUser(Long id) {
        if (userRepository.existsById(id)) {
            userRepository.delete(id);
            return true;
        }
        return false;
    }
}
