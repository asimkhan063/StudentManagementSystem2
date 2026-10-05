package com.example.school_management.entity;

import lombok.Data;

@Data
public class DashboardStatsDTO {
    private int studentCount;
    private int teacherCount;
    private String attendanceRate;

    // Add other stats if needed (feesPaid, unpaid, etc.)

    // Getters and Setters
}