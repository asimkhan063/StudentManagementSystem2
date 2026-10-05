package com.example.school_management.academics.dto;

import java.time.LocalDateTime;
import java.util.List;

public record QuizResponse(Long quizId, String title, String grade, String section,
                           LocalDateTime createdAt, List<QuizQuestionResponse> questions,
                           Integer score, Integer maxScore, LocalDateTime submittedAt) { }
