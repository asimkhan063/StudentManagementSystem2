package com.example.school_management.academics.repository;

import com.example.school_management.academics.entity.AssignmentSubmission;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AssignmentSubmissionRepository extends JpaRepository<AssignmentSubmission, Long> {
    Optional<AssignmentSubmission> findByAssignmentIdAndStudentId(Long assignmentId, Long studentId);
    List<AssignmentSubmission> findByAssignment_CreatedByOrderBySubmittedAtDesc(String createdBy);
    List<AssignmentSubmission> findByStudent_IdOrderBySubmittedAtDesc(Long studentId);
}
