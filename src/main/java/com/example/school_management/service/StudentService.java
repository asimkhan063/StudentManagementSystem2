package com.example.school_management.service;


import com.example.school_management.entity.Student;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface StudentService {
    Student addStudent(Student student);
    List<Student> getAllStudents();

    List<Student> getStudentsByGradeAndSection(String grade, String section);     // Student Attandance
    List<String> getAllGrades();               // Student Attandance
    List<String> getAllSections();             // Student Attandance

    Student getStudentById(Long id);
    Student updateStudent(Long id, Student student);
    void deleteStudent(Long id);
    public String savePhoto(MultipartFile photo);
    public String generatePlaceholder(String name);
    public String generateRandomColor();
}