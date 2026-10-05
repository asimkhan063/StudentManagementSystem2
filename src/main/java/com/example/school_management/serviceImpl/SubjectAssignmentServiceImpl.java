package com.example.school_management.serviceImpl;

import com.example.school_management.entity.Subject;
import com.example.school_management.entity.SubjectAssignment;
import com.example.school_management.repository.SubjectAssignmentRepository;
import com.example.school_management.repository.SubjectRepository;
import com.example.school_management.service.SubjectAssignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SubjectAssignmentServiceImpl implements SubjectAssignmentService {
    @Autowired
    private final SubjectAssignmentRepository subjectAssignmentRepository;
    @Autowired
    private final SubjectRepository subjectRepository;

    @Transactional
    public void assignSubjectsToClass(String grade, String section, List<Long> subjectIds) {
        // Delete old assignments for this grade-section
        subjectAssignmentRepository.deleteByGradeAndSection(grade, section);

        for (Long subjectId : subjectIds) {
            Subject subject = subjectRepository.findById(subjectId).orElse(null);
            if (subject != null) {
                SubjectAssignment sa = new SubjectAssignment();
                sa.setGrade(grade);
                sa.setSection(section);
                sa.setSubject(subject);
                subjectAssignmentRepository.save(sa);
            }
        }
    }

    public List<Subject> getSubjectsForGradeAndSection(String grade, String section) {
        List<SubjectAssignment> assignments = subjectAssignmentRepository.findByGradeAndSection(grade, section);
        return assignments.stream()
                .map(SubjectAssignment::getSubject)
                .collect(Collectors.toList());
    }

}