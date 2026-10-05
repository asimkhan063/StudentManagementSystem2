package com.example.school_management.TeacherFeatures.entity;

import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Teacher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 50, message = "Name must be between 2 and 50 characters")
    private String name;

    @Column(unique = true)
    @Email(message = "Email should be valid")
    @NotBlank(message = "Email is required")
    private String email;

    @NotBlank(message = "Qualification is required")
    private String qualification;

    @NotBlank(message = "Specialization is required")
    private String specialization;

    @NotNull(message = "Experience is required")
    @Min(value = 0, message = "Experience cannot be negative")
    private Integer experience;

    @NotBlank(message = "Address is required")
    private String address;

    //    @Pattern(regexp = "^(https?|ftp)://.*|^/.*$", message = "Invalid URL format for photo link")
//    @Size(max = 255, message = "Photo URL must not exceed 255 characters")
    private String photoUrl;

    @NotNull(message = "Date of Birth is required")
    @PastOrPresent(message = "Date of Birth cannot be in the future")
    private LocalDate dob;

    @NotBlank(message = "Phone is required")
    @Pattern(regexp = "^\\d{10}$", message = "Phone number must be 10 digits")
    private String phone;

    private String altPhoneNo;

    @NotBlank(message = "Aadhaar Number is required")
    @Pattern(regexp = "\\d{12}", message = "Aadhaar must be 12 digits")
    private String aadhaarNo;

    @NotBlank(message = "Gender is required")
    private String gender;

    @NotNull(message = "Date of Joining is required")
    @PastOrPresent(message = "Date of Joining cannot be in the future")
    private LocalDate doj;

    private Boolean isActive = true;
}