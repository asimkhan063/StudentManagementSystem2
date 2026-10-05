package com.example.school_management.service;

import com.example.school_management.entity.Subject;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SubjectAssignmentService {
    public void assignSubjectsToClass(String grade, String section, List<Long> subjectIds);

    public List<Subject> getSubjectsForGradeAndSection(String grade, String section);
}