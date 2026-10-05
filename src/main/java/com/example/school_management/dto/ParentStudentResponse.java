package com.example.school_management.dto;

import com.example.school_management.academics.dto.StudentReportCardResponse;
import java.util.List;

public record ParentStudentResponse(
        Long studentId,
        String name,
        String rollNo,
        String grade,
        String section,
        List<ParentAttendanceResponse> attendance,
        List<ParentFeeInvoiceResponse> invoices,
        StudentReportCardResponse reportCard) {
}
