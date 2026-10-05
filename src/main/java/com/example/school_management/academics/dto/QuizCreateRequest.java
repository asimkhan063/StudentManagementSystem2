package com.example.school_management.academics.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;

public record QuizCreateRequest(
        @NotBlank @Size(max = 140) String title,
        @NotBlank @Size(max = 30) String grade,
        @NotBlank @Size(max = 30) String section,
        @NotEmpty @Size(min = 1, max = 100) List<@Valid QuestionInput> questions) {
    public record QuestionInput(@NotBlank @Size(max = 1200) String prompt,
                                @NotBlank @Size(max = 400) String optionA,
                                @NotBlank @Size(max = 400) String optionB,
                                @NotBlank @Size(max = 400) String optionC,
                                @NotBlank @Size(max = 400) String optionD,
                                @NotBlank @Pattern(regexp = "(?i)[A-D]") String correctOption) { }
}
