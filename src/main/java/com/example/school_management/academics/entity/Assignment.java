package com.example.school_management.academics.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity @Table(name = "assignments")
public class Assignment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(nullable = false, length = 140) private String title;
    @Column(nullable = false, length = 4000) private String description;
    @Column(nullable = false, length = 30) private String grade;
    @Column(nullable = false, length = 30) private String section;
    @Column(nullable = false) private LocalDate dueDate;
    @Column(nullable = false) private Integer maxScore;
    @Column(nullable = false, length = 190) private String createdBy;
    @Column(nullable = false, updatable = false) private LocalDateTime createdAt;
    protected Assignment() { }
    public Assignment(String title, String description, String grade, String section, LocalDate dueDate, Integer maxScore, String createdBy) {
        this.title = title; this.description = description; this.grade = grade; this.section = section;
        this.dueDate = dueDate; this.maxScore = maxScore; this.createdBy = createdBy; this.createdAt = LocalDateTime.now();
    }
    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getGrade() { return grade; }
    public String getSection() { return section; }
    public LocalDate getDueDate() { return dueDate; }
    public Integer getMaxScore() { return maxScore; }
    public String getCreatedBy() { return createdBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
