package com.example.school_management.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "fee_invoices")
public class FeeInvoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(nullable = false, length = 120)
    private String title;

    @Column(name = "total_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    protected FeeInvoice() { }

    public FeeInvoice(Student student, String title, BigDecimal totalAmount, LocalDate dueDate) {
        this.student = student;
        this.title = title;
        this.totalAmount = totalAmount;
        this.dueDate = dueDate;
    }

    public Long getId() { return id; }
    public Student getStudent() { return student; }
    public String getTitle() { return title; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public LocalDate getDueDate() { return dueDate; }
}
