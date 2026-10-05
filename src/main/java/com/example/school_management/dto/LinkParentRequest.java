package com.example.school_management.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record LinkParentRequest(
        @NotNull Long studentId,
        @NotBlank @Email String parentEmail) {
}
