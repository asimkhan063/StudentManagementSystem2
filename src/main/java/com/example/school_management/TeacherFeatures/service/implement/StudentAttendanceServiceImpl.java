package com.example.school_management.TeacherFeatures.service.implement;

import com.example.school_management.TeacherFeatures.dto.AttendanceRequest;
import com.example.school_management.TeacherFeatures.entity.AttendanceMeta;
import com.example.school_management.TeacherFeatures.entity.StudentAttendance;
import com.example.school_management.TeacherFeatures.repository.StudentAttendanceRepository;
import com.example.school_management.TeacherFeatures.repository.AttendanceMetaRepository;
import com.example.school_management.TeacherFeatures.service.StudentAttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StudentAttendanceServiceImpl implements StudentAttendanceService {

    @Autowired
    private StudentAttendanceRepository studentAttendanceRepository;

    @Autowired
    private AttendanceMetaRepository attendanceMetaRepository;

    @Override
    public void saveAttendance(AttendanceRequest request, Long teacherId, String recordedBy) {
        // First, save attendance metadata
        AttendanceMeta meta = new AttendanceMeta(
                request.getDate(),
                request.getGrade(),
                request.getSection(),
                teacherId
        );
        attendanceMetaRepository.save(meta); // Save and get the persisted entity

        List<AttendanceRequest.AttendanceEntry> entries = request.getAttendancelist();

        // Avoid NullPointerException
        if (entries != null && !entries.isEmpty()) {
            for (AttendanceRequest.AttendanceEntry entry : entries) {
                StudentAttendance studentAttendance = new StudentAttendance();
                studentAttendance.setStudentId(entry.getStudentId());
                studentAttendance.setStatus(entry.getStatus());
                studentAttendance.setDate(request.getDate());
                studentAttendance.setGrade(request.getGrade());
                studentAttendance.setSection(request.getSection());
                studentAttendance.setTeacherId(teacherId);
                studentAttendance.setRecordedBy(recordedBy);
                studentAttendance.setAttendanceMeta(meta); // Now meta is available

                // Add the StudentAttendance to AttendanceMeta (bidirectional relationship)
                meta.addStudentAttendance(studentAttendance);

                // Save the StudentAttendance entity
                studentAttendanceRepository.save(studentAttendance);
            }
        } else {
            System.out.println("No student attendance entries found. Skipping studentAttendance save.");
        }
    }


    @Override
    public boolean existsByDateGradeSectionTeacher(LocalDate date, String grade, String section, Long teacherId) {
        return attendanceMetaRepository.existsByDateAndGradeAndSectionAndTeacherId(date, grade, section, teacherId);
    }

    @Override
    public List<AttendanceRequest> getAttendanceHistoryByTeacher(Long teacherId) {
        List<AttendanceMeta> metaList = attendanceMetaRepository.findByTeacherId(teacherId);

        return metaList.stream().map(meta -> {
            AttendanceRequest request = new AttendanceRequest();
            request.setDate(meta.getDate());
            request.setGrade(meta.getGrade());
            request.setSection(meta.getSection());
            request.setTeacherId(meta.getTeacherId());

            List<StudentAttendance> studentAttendanceList = studentAttendanceRepository.findByAttendanceMetaWithStudent(meta);

            // ✅ Convert to AttendanceEntry DTOs
            List<AttendanceRequest.AttendanceEntry> entryList = studentAttendanceList.stream().map(att -> {
                AttendanceRequest.AttendanceEntry entry = new AttendanceRequest.AttendanceEntry();
                entry.setStudentId(att.getStudentId()); // ✅ Use this
                entry.setStatus(att.getStatus());
                return entry;
            }).toList();

            request.setAttendancelist(entryList); // ✅ Fixed method name

            return request;
        }).toList();
    }

    @Override
    public List<AttendanceMeta> getFilteredStudentAttendanceHistory(Long teacherId, String grade, String section, LocalDate date) {
        if (date != null && (grade == null || grade.isEmpty()) && (section == null || section.isEmpty())) {
            // Filter by only date and teacherId
            return attendanceMetaRepository.findByTeacherIdAndDate(teacherId, date);
        } else if (grade != null && !grade.isEmpty() && section != null && !section.isEmpty() && date != null) {
            return attendanceMetaRepository.findByTeacherIdAndGradeAndSectionAndDate(teacherId, grade, section, date);
        } else if (grade != null && !grade.isEmpty() && section != null && !section.isEmpty()) {
            return attendanceMetaRepository.findByTeacherIdAndGradeAndSection(teacherId, grade, section);
        } else if (grade != null && !grade.isEmpty()) {
            return attendanceMetaRepository.findByTeacherIdAndGrade(teacherId, grade);
        } else if (section != null && !section.isEmpty()) {
            return attendanceMetaRepository.findByTeacherIdAndSection(teacherId, section);
        }
        return attendanceMetaRepository.findByTeacherId(teacherId);
    }

    @Override
    public boolean existsByDateGradeSection(LocalDate date, String grade, String section) {
        return attendanceMetaRepository.existsByDateAndGradeAndSection(date, grade, section);
    }

    @Override
    public List<AttendanceRequest> getAllAttendanceHistory() {
        // Fetch all attendance metadata records
        List<AttendanceMeta> allMeta = attendanceMetaRepository.findAll();

        List<AttendanceRequest> history = new ArrayList<>();

        // Iterate through all attendance metadata records
        for (AttendanceMeta meta : allMeta) {
            // For each metadata, create an AttendanceRequest object
            AttendanceRequest request = new AttendanceRequest();
            request.setDate(meta.getDate());
            request.setGrade(meta.getGrade());
            request.setSection(meta.getSection());
            request.setTeacherId(meta.getTeacherId());

            // Fetch student attendance records associated with the metadata
            List<StudentAttendance> attendanceList = studentAttendanceRepository.findByAttendanceMeta(meta);

            // Convert student attendance records into AttendanceEntry DTOs
            List<AttendanceRequest.AttendanceEntry> entries = attendanceList.stream().map(att -> {
                // For each student attendance, create an AttendanceEntry
                AttendanceRequest.AttendanceEntry entry = new AttendanceRequest.AttendanceEntry();
                entry.setStudentId(att.getStudentId());
                entry.setStatus(att.getStatus());
                return entry;
            }).collect(Collectors.toList());

            // Set the attendance entries in the request
            request.setAttendancelist(entries);

            // Add the request to the history list
            history.add(request);
        }

        // Return the list of all attendance history
        return history;
    }
    @Override
    public double getTodaysAttendancePercentage(Long teacherId) {
        LocalDate today = LocalDate.now();
        int presentCount = studentAttendanceRepository.countByTeacherIdAndDateAndStatus(teacherId, today, "Present");
        int totalMarked = studentAttendanceRepository.countByTeacherIdAndDate(teacherId, today);

        if (totalMarked == 0) return 0.0;
        return (presentCount * 100.0) / totalMarked;
    }

    @Override
    public int getTotalStudentsAssignedToTeacher(Long teacherId) {
        return studentAttendanceRepository.countDistinctStudentsByTeacherId(teacherId);
    }

    @Override
    public int getTotalClassesAssignedToTeacher(Long teacherId) {
        return attendanceMetaRepository.countDistinctClassesByTeacherId(teacherId);
    }

    @Override
    public double getOverallAttendanceRate(Long teacherId) {
        int totalPresent = studentAttendanceRepository.countByTeacherIdAndStatus(teacherId, "Present");
        int totalMarked = studentAttendanceRepository.countByTeacherId(teacherId);

        if (totalMarked == 0) return 0.0;
        return (totalPresent * 100.0) / totalMarked;
    }

    @Override
    public List<AttendanceMeta> getAllAttendanceMetaByTeacher(Long teacherId) {
        return attendanceMetaRepository.findByTeacherId(teacherId);
    }

    @Override
    public List<AttendanceMeta> getLatestStudentAttendanceByTeacher(Long teacherId) {
        LocalDate latestDate = attendanceMetaRepository.findLatestAttendanceDateByTeacherId(teacherId);
        if (latestDate != null) {
            return attendanceMetaRepository.findByTeacherIdAndDate(teacherId, latestDate);
        }
        return Collections.emptyList();
    }

}