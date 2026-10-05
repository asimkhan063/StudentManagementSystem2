package com.example.school_management.TeacherFeatures.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "attendance_meta")
public class AttendanceMeta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate date;
    private String grade;
    private String section;
    private Long teacherId;

    @OneToMany(mappedBy = "attendanceMeta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<StudentAttendance> attendancelist;

    public AttendanceMeta() {}

    public AttendanceMeta(LocalDate date, String grade, String section, Long teacherId) {
        this.date = date;
        this.grade = grade;
        this.section = section;
        this.teacherId = teacherId;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public List<StudentAttendance> getAttendancelist() {
        return attendancelist;
    }
    public void setAttendancelist(List<StudentAttendance> attendancelist) {
        this.attendancelist = attendancelist;
    }

    public void addStudentAttendance(StudentAttendance attendance) {
        if (this.attendancelist == null) {
            this.attendancelist = new ArrayList<>();
        }
        this.attendancelist.add(attendance);
        attendance.setAttendanceMeta(this); // Ensure bidirectional relationship
    }
}