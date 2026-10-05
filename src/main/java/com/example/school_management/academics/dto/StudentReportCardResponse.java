package com.example.school_management.academics.dto;

import java.util.List;

public record StudentReportCardResponse(Long studentId, String studentName, String grade,
                                        String section, int quizCount, double averageQuizPercentage,
                                        int assignmentsSubmitted, int assignmentsGraded,
                                        Double averageAssignmentScore, List<QuizAttemptResponse> quizzes,
                                        List<AssignmentResponse> assignments) { }
