package com.example.school_management.serviceImpl;


import com.example.school_management.TeacherFeatures.repository.TeacherRepository;
import com.example.school_management.entity.DashboardStatsDTO;
import com.example.school_management.entity.Student;
import com.example.school_management.repository.StudentRepository;
import com.example.school_management.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private StudentRepository studentRepo;

    @Autowired
    private TeacherRepository teacherRepo;

    @Override
    public DashboardStatsDTO getDashboardStats() {
        DashboardStatsDTO stats = new DashboardStatsDTO();
        stats.setStudentCount((int) studentRepo.count());
        System.out.println("student count:"+(int) studentRepo.count()+" teacher count:"+(int) teacherRepo.count());
        stats.setTeacherCount((int) teacherRepo.count());

        // Dummy Attendance Rate calculation (replace with actual logic)
        stats.setAttendanceRate("91%");

        return stats;
    }

    @Override
    public List<Student> getAllStudents() {
        return studentRepo.findAll();
    }
}