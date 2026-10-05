package com.example.school_management.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreateFeeInvoiceRequest(
        @NotNull Long studentId,
        @NotBlank @Size(max = 120) String title,
        @NotNull @DecimalMin("0.01") BigDecimal totalAmount,
        @NotNull LocalDate dueDate) {
}
