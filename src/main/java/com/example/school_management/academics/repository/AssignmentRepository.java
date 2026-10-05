package com.example.school_management.academics.repository;

import com.example.school_management.academics.entity.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AssignmentRepository extends JpaRepository<Assignment, Long> {
    List<Assignment> findByGradeAndSectionOrderByDueDateAsc(String grade, String section);
    List<Assignment> findByCreatedByOrderByCreatedAtDesc(String createdBy);
}
