package com.example.school_management.academics.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record AssignmentResponse(Long assignmentId, String title, String description, String grade,
                                 String section, LocalDate dueDate, Integer maxScore, LocalDateTime createdAt,
                                 Long submissionId, LocalDateTime submittedAt, Integer score, String feedback) { }
