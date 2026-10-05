package com.example.school_management.academics.dto;

import java.time.LocalDateTime;

public record QuizAttemptResponse(Long attemptId, Long quizId, String quizTitle, Long studentId,
                                  String studentName, Integer score, Integer maxScore,
                                  double percentage, LocalDateTime submittedAt) { }
