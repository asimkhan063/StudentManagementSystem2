package com.example.school_management.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class SubjectAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String grade;   // e.g., "Class 1"
    private String section; // e.g., "A"

    @ManyToOne
    private Subject subject;

    public SubjectAssignment(String grade, String section, Subject subject) {
        this.grade = grade;
        this.section = section;
        this.subject = subject;
    }

}