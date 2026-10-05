package com.example.school_management.academics.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity @Table(name = "quizzes")
public class Quiz {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(nullable = false, length = 140) private String title;
    @Column(nullable = false, length = 30) private String grade;
    @Column(nullable = false, length = 30) private String section;
    @Column(nullable = false, length = 190) private String createdBy;
    @Column(nullable = false, updatable = false) private LocalDateTime createdAt;
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, orphanRemoval = true) private List<QuizQuestion> questions = new ArrayList<>();
    protected Quiz() { }
    public Quiz(String title, String grade, String section, String createdBy) {
        this.title = title; this.grade = grade; this.section = section; this.createdBy = createdBy; this.createdAt = LocalDateTime.now();
    }
    public void addQuestion(QuizQuestion question) { questions.add(question); question.setQuiz(this); }
    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getGrade() { return grade; }
    public String getSection() { return section; }
    public String getCreatedBy() { return createdBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public List<QuizQuestion> getQuestions() { return questions; }
}
