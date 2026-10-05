package com.example.school_management.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record FeeInvoiceResponse(
        Long invoiceId,
        Long studentId,
        String studentName,
        String rollNo,
        String title,
        BigDecimal totalAmount,
        BigDecimal paidAmount,
        BigDecimal balance,
        LocalDate dueDate,
        String status) {
}
