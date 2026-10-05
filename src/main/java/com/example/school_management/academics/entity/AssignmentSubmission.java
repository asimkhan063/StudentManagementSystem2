package com.example.school_management.academics.entity;

import com.example.school_management.entity.Student;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity @Table(name = "assignment_submissions", uniqueConstraints =
        @UniqueConstraint(name = "uk_assignment_student", columnNames = {"assignment_id", "student_id"}))
public class AssignmentSubmission {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "assignment_id", nullable = false) private Assignment assignment;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "student_id", nullable = false) private Student student;
    @Column(nullable = false, length = 8000) private String responseText;
    @Column(nullable = false, updatable = false) private LocalDateTime submittedAt;
    private Integer score;
    @Column(length = 1000) private String feedback;
    protected AssignmentSubmission() { }
    public AssignmentSubmission(Assignment assignment, Student student, String responseText) {
        this.assignment = assignment; this.student = student; this.responseText = responseText; this.submittedAt = LocalDateTime.now();
    }
    public Long getId() { return id; }
    public Assignment getAssignment() { return assignment; }
    public Student getStudent() { return student; }
    public String getResponseText() { return responseText; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public Integer getScore() { return score; }
    public String getFeedback() { return feedback; }
    public void grade(Integer score, String feedback) { this.score = score; this.feedback = feedback; }
}
