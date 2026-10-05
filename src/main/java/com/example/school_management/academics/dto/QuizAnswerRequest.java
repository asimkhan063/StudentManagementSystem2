package com.example.school_management.academics.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.util.List;

public record QuizAnswerRequest(@NotEmpty List<@Valid Answer> answers) {
    public record Answer(@NotNull Long questionId, @NotNull @Pattern(regexp = "(?i)[A-D]") String selectedOption) { }
}
