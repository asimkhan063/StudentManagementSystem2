package com.example.school_management.serviceImpl;

import com.example.school_management.entity.Student;
import com.example.school_management.entity.Subject;
import com.example.school_management.entity.SubjectAssignment;
import com.example.school_management.repository.SubjectAssignmentRepository;
import com.example.school_management.repository.SubjectRepository;
import com.example.school_management.service.SubjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SubjectServiceImpl implements SubjectService {
    @Autowired
    private SubjectAssignmentRepository subjectAssignmentRepository;

    @Autowired
    private SubjectRepository subjectRepository;
    public List<Subject> getSubjectsForStudent(Student student) {
        List<SubjectAssignment> assignments = subjectAssignmentRepository
                .findByGradeAndSection(student.getGrade(), student.getSection());

        return assignments.stream()
                .map(SubjectAssignment::getSubject)
                .collect(Collectors.toList());
    }

    public List<Subject> getAllSubjects() {
        return subjectRepository.findAll();
    }


    @Override
    public List<String> getAllGrades() {
        List<String> grades = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            grades.add(String.valueOf(i));
        }
        return grades;
    }


    @Override
    public List<String> getAllSections() {
        return Arrays.asList("A", "B", "C");
    }


    public List<Long> getAssignedSubjectIds(String grade, String section) {
        List<SubjectAssignment> assignments = subjectAssignmentRepository.findByGradeAndSection(grade, section);
        return assignments.stream()
                .map(a -> a.getSubject().getId())
                .collect(Collectors.toList());
    }

}