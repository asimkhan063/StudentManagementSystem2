package com.example.school_management.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "parent_student_links", uniqueConstraints =
        @UniqueConstraint(name = "uk_parent_student_link", columnNames = {"parent_id", "student_id"}))
public class ParentStudentLink {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "parent_id", nullable = false)
    private AppUser parent;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    protected ParentStudentLink() { }

    public ParentStudentLink(AppUser parent, Student student) {
        this.parent = parent;
        this.student = student;
    }

    public Long getId() { return id; }
    public AppUser getParent() { return parent; }
    public Student getStudent() { return student; }
}
