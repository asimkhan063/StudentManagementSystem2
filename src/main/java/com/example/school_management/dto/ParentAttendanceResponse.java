package com.example.school_management.dto;

import java.time.LocalDate;

public record ParentAttendanceResponse(LocalDate date, String status, String grade, String section) { }
