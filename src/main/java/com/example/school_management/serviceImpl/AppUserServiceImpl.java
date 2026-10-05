package com.example.school_management.serviceImpl;

import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import com.example.school_management.service.AppUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AppUserServiceImpl implements AppUserService {

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void createAppUser(String username, String rawPassword, String role, Long roleId) {
        AppUser user = new AppUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(rawPassword));
        user.setRole(role);
        user.setRoleId(roleId);
        appUserRepository.save(user);
    }
}