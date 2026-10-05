package com.example.school_management.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StudentDTO {
    private String name;
    private String email;
    private String grade;
    private String address;
    private String rollNo;
    private String fatherName;
    private String motherName;
    private String aadhaarNo;
    private String phoneNo;
    private String altPhoneNo;
    private String gender;
    private String section;
    private String sessionId;
    private MultipartFile image; // Image will be uploaded

    // Getters and Setters for all fields
}