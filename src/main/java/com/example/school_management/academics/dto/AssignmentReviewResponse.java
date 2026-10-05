package com.example.school_management.academics.dto;

import java.time.LocalDateTime;

public record AssignmentReviewResponse(Long submissionId, Long assignmentId, String assignmentTitle,
                                       Long studentId, String studentName, String grade, String section,
                                       String responseText, LocalDateTime submittedAt,
                                       Integer score, Integer maxScore, String feedback) { }
