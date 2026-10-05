package com.example.school_management.atRuntime;

import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.util.StringUtils;

@Configuration
public class DataInitializer {

    /**
     * Optional one-time admin bootstrap. No account is created or reset unless an
     * operator explicitly provides BOOTSTRAP_ADMIN_PASSWORD in the environment.
     */
    @Bean
    CommandLineRunner bootstrapAdmin(AppUserRepository users, PasswordEncoder passwordEncoder) {
        return args -> {
            String password = System.getenv("BOOTSTRAP_ADMIN_PASSWORD");
            if (!StringUtils.hasText(password)) {
                return;
            }

            String username = System.getenv().getOrDefault("BOOTSTRAP_ADMIN_USERNAME", "admin");
            if (users.findByUsername(username) != null) {
                return;
            }

            AppUser admin = new AppUser();
            admin.setUsername(username);
            admin.setPassword(passwordEncoder.encode(password));
            admin.setRole("ADMIN");
            admin.setRoleId(1L);
            admin.setMustChangePassword(true);
            users.save(admin);
        };
    }
}
