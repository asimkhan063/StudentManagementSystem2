package com.example.school_management.service;

import org.springframework.stereotype.Service;

@Service
public interface AppUserService {

    public void createAppUser(String username, String rawPassword, String role, Long roleId);
}