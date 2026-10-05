package com.example.school_management.repository;

import com.example.school_management.entity.SubjectAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubjectAssignmentRepository extends JpaRepository<SubjectAssignment, Long> {
    List<SubjectAssignment> findByGradeAndSection(String grade, String section);
    void deleteByGradeAndSection(String grade, String section);

}