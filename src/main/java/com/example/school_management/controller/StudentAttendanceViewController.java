package com.example.school_management.controller;


import com.example.school_management.TeacherFeatures.entity.StudentAttendance;
import com.example.school_management.TeacherFeatures.repository.StudentAttendanceRepository;
import com.example.school_management.entity.Student;
import com.example.school_management.repository.StudentRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentAttendanceViewController {

    @Autowired
    private StudentAttendanceRepository studentAttendanceRepository;

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping("/attendance")
    public String viewAttendance(Model model, HttpSession session) {
        Long studentId = (Long) session.getAttribute("roleId"); // assuming student ID is stored as roleId

        if (studentId == null) {
            model.addAttribute("error", "Student not logged in.");
            return "error"; // or your custom error page
        }

        Student student = studentRepository.findById(studentId).orElse(null);
        if (student == null) {
            model.addAttribute("error", "Student not found.");
            return "error";
        }

        List<StudentAttendance> attendanceList = studentAttendanceRepository
                .findByStudentId(studentId);

        model.addAttribute("student", student);
        model.addAttribute("attendanceList", attendanceList);
        return "student/viewAttendance"; // JSP page to be created
    }
}