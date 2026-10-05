package com.example.school_management.academics.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record AssignmentGradeRequest(@NotNull @Min(0) @Max(10000) Integer score, @Size(max = 1000) String feedback) { }
