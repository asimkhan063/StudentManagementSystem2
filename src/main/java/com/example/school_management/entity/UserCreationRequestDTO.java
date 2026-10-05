package com.example.school_management.entity;

import lombok.Data;

@Data
public class UserCreationRequestDTO {
    private String name;
    private String email;
    private String role; // STUDENT / TEACHER / ADMIN
    private String grade;     // for students only
    private String section;   // optional
}