package com.example.school_management.academics.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public record AssignmentCreateRequest(
        @NotBlank @Size(max = 140) String title,
        @NotBlank @Size(max = 4000) String description,
        @NotBlank @Size(max = 30) String grade,
        @NotBlank @Size(max = 30) String section,
        @NotNull LocalDate dueDate,
        @NotNull @Min(1) @Max(10000) Integer maxScore) { }
