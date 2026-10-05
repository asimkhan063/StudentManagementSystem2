package com.example.school_management.academics.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AssignmentSubmissionRequest(@NotBlank @Size(max = 8000) String responseText) { }
