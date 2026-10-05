package com.example.school_management.service;


import com.example.school_management.entity.DashboardStatsDTO;
import com.example.school_management.entity.Student;

import java.util.List;

public interface DashboardService {
    DashboardStatsDTO getDashboardStats();
    List<Student> getAllStudents();
}
