package com.example.school_management.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "app_user")
public class AppUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String displayName;
    private String password;
    private String role;    // ADMIN, TEACHER, STUDENT, PARENT
    private Long roleId;    // ID of related Admin/Teacher/Student


    private boolean mustChangePassword = true; // default true
}
