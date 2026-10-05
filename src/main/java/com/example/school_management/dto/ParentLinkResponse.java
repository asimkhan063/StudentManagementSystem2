package com.example.school_management.dto;

public record ParentLinkResponse(
        Long linkId,
        String parentEmail,
        String parentName,
        Long studentId,
        String studentName,
        String rollNo,
        String grade,
        String section) {
}
