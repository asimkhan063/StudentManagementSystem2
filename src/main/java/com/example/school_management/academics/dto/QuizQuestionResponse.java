package com.example.school_management.academics.dto;

public record QuizQuestionResponse(Long questionId, String prompt, String optionA, String optionB,
                                   String optionC, String optionD) { }
