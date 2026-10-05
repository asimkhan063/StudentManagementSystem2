package com.example.school_management.service;

import com.example.school_management.entity.Student;
import com.example.school_management.entity.Subject;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SubjectService {
    public List<Subject> getSubjectsForStudent(Student student);
    public List<Subject> getAllSubjects();

    public List<String> getAllGrades();

    public List<String> getAllSections();

    List<Long> getAssignedSubjectIds(String defaultGrade, String defaultSection);
}