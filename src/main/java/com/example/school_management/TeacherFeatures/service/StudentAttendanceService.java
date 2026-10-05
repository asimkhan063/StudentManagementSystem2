package com.example.school_management.TeacherFeatures.service;

import com.example.school_management.TeacherFeatures.dto.AttendanceRequest;
import com.example.school_management.TeacherFeatures.entity.AttendanceMeta;
import com.example.school_management.TeacherFeatures.entity.StudentAttendance;

import java.time.LocalDate;
import java.util.List;

public interface StudentAttendanceService {
    void saveAttendance(AttendanceRequest request, Long teacherId, String recordedBy);

    boolean existsByDateGradeSectionTeacher(LocalDate date, String grade, String section, Long teacherId);

    List<AttendanceRequest> getAttendanceHistoryByTeacher(Long teacherId);

    List<AttendanceMeta> getFilteredStudentAttendanceHistory(Long teacherId, String grade, String section, LocalDate date);
    double getTodaysAttendancePercentage(Long teacherId);
    int getTotalStudentsAssignedToTeacher(Long teacherId);
    int getTotalClassesAssignedToTeacher(Long teacherId);
    double getOverallAttendanceRate(Long teacherId);

    // In AttendanceService
    List<AttendanceMeta> getLatestStudentAttendanceByTeacher(Long teacherId);

    public boolean existsByDateGradeSection(LocalDate date, String grade, String section);
    public List<AttendanceRequest> getAllAttendanceHistory(); // Like teacher’s history but for all

    List<AttendanceMeta> getAllAttendanceMetaByTeacher(Long teacherId);

}