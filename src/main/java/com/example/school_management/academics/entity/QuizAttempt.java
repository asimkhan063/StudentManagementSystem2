package com.example.school_management.academics.entity;

import com.example.school_management.entity.Student;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity @Table(name = "quiz_attempts", uniqueConstraints =
        @UniqueConstraint(name = "uk_quiz_student_attempt", columnNames = {"quiz_id", "student_id"}))
public class QuizAttempt {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "quiz_id", nullable = false) private Quiz quiz;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "student_id", nullable = false) private Student student;
    @Column(nullable = false) private Integer score;
    @Column(name = "max_score", nullable = false) private Integer maxScore;
    @Column(nullable = false, updatable = false) private LocalDateTime submittedAt;
    protected QuizAttempt() { }
    public QuizAttempt(Quiz quiz, Student student, int score, int maxScore) {
        this.quiz = quiz; this.student = student; this.score = score; this.maxScore = maxScore; this.submittedAt = LocalDateTime.now();
    }
    public Long getId() { return id; }
    public Quiz getQuiz() { return quiz; }
    public Student getStudent() { return student; }
    public Integer getScore() { return score; }
    public Integer getMaxScore() { return maxScore; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
}
