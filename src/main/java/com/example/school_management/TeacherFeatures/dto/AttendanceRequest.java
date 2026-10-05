package com.example.school_management.TeacherFeatures.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.List;

public class AttendanceRequest {
    private Long teacherId;
    private String grade;
    private String section;
    private LocalDate date;
    @JsonProperty("attendance")
    private List<AttendanceEntry> attendancelist;

    // Default Constructor
    public AttendanceRequest() {}

    // Getters and Setters
    public Long getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public List<AttendanceEntry> getAttendancelist() {
        return attendancelist;
    }

    public void setAttendancelist(List<AttendanceEntry> attendance) {
        this.attendancelist = attendance;
    }

    @Override
    public String toString() {
        return "AttendanceRequest{" +
                "teacherId=" + teacherId +
                ", grade='" + grade + '\'' +
                ", section='" + section + '\'' +
                ", date=" + date +
                ", attendance=" + attendancelist +
                '}';
    }

    // Nested class to represent each student's attendance entry
    public static class AttendanceEntry {
        private Long studentId;
        private String status; // Present, Absent, Leave

        public AttendanceEntry() {}

        public Long getStudentId() {
            return studentId;
        }

        public void setStudentId(Long studentId) {
            this.studentId = studentId;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        @Override
        public String toString() {
            return "AttendanceEntry{" +
                    "studentId=" + studentId +
                    ", status='" + status + '\'' +
                    '}';
        }

    }
}