package com.example.school_management.TeacherFeatures.entity;

import com.example.school_management.entity.Student;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "student_attendance")
public class StudentAttendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "recorded_by", nullable = true)
    private String recordedBy;

    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "studentId", insertable = false, updatable = false)
    private Student student;

    private LocalDate date;
    private String status; // Present, Absent, Leave

    // ✅ Add these fields:
    private String grade;
    private String section;
    @Column(nullable = true)
    private Long teacherId;

    @ManyToOne
    @JoinColumn(name = "attendance_meta_id")
    private AttendanceMeta attendanceMeta;
}