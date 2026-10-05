package com.example.school_management.TeacherFeatures.Controller;

import com.example.school_management.TeacherFeatures.dto.AttendanceRequest;
import com.example.school_management.TeacherFeatures.entity.AttendanceMeta;
import com.example.school_management.TeacherFeatures.entity.StudentAttendance;
import com.example.school_management.TeacherFeatures.entity.Teacher;
import com.example.school_management.TeacherFeatures.repository.AttendanceMetaRepository;
import com.example.school_management.TeacherFeatures.repository.StudentAttendanceRepository;
import com.example.school_management.TeacherFeatures.repository.TeacherRepository;
import com.example.school_management.TeacherFeatures.service.StudentAttendanceService;
import com.example.school_management.entity.Student;
import com.example.school_management.service.StudentService;
import com.example.school_management.serviceImpl.SchoolNotificationService;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/teacher/student-attendance")
public class StudentAttendanceController {

    @Autowired
    private StudentAttendanceService attendanceService; // Use the interface here

    @Autowired
    private StudentService studentService;

    @Autowired
    private AttendanceMetaRepository attendanceMetaRepository;

    @Autowired
    private StudentAttendanceRepository studentAttendanceRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private SchoolNotificationService notificationService;

    @GetMapping("/view")
    public String showAttendancePage(@ModelAttribute AttendanceRequest request, HttpSession session) {
        if (request.getTeacherId() == null) {
            request.setTeacherId((Long) session.getAttribute("teacherId"));
        }

        System.out.println("Teacher ID: " + request.getTeacherId());
        return "teacher/student-Attendance/studentMarkAttendance"; // This will load studentMarkAttendance.jsp
    }

    // Get all students for the selected grade and section
    @GetMapping("/students-attendance")
    public ResponseEntity<List<Student>> getStudentsByGradeAndSection(@RequestParam String grade, @RequestParam String section) {
        List<Student> students = studentService.getStudentsByGradeAndSection(grade, section);
        return ResponseEntity.ok(students);
    }

    // Get attendance records for a specific date
    @GetMapping("/get-attendance")
    public ResponseEntity<?> getAttendance(@RequestParam String grade, @RequestParam String section, @RequestParam String date) {
        LocalDate attendanceDate = LocalDate.parse(date);
        List<Student> students = studentService.getStudentsByGradeAndSection(grade, section);
        return ResponseEntity.ok(students);
    }

    // Fetch all grades dynamically
    @GetMapping("/grades")
    public ResponseEntity<List<String>> getAllGrades() {
        List<String> grades = studentService.getAllGrades();
        return ResponseEntity.ok(grades);
    }

    // Fetch all sections dynamically
    @GetMapping("/sections")
    public ResponseEntity<List<String>> getAllSections() {
        List<String> sections = studentService.getAllSections();
        return ResponseEntity.ok(sections);
    }

    @GetMapping("/attendance-exists")
    @ResponseBody
    public boolean attendanceAlreadyExists(@RequestParam("date") LocalDate date,
                                           @RequestParam String grade,
                                           @RequestParam String section,
                                           HttpSession session) {
        Long teacherId = (Long  ) session.getAttribute("id");
        return attendanceService.existsByDateGradeSectionTeacher(date, grade, section, teacherId);
    }

    @PostMapping("/submit-attendance")
    public ResponseEntity<?> submitAttendance(@RequestBody AttendanceRequest request, HttpSession session) {
        if (request == null || request.getDate() == null || request.getGrade() == null
                || request.getGrade().isBlank() || request.getSection() == null
                || request.getSection().isBlank() || request.getAttendancelist() == null
                || request.getAttendancelist().isEmpty()) {
            return ResponseEntity.badRequest().body("Date, grade, section and at least one student status are required");
        }
        for (AttendanceRequest.AttendanceEntry entry : request.getAttendancelist()) {
            if (entry == null || entry.getStudentId() == null) {
                return ResponseEntity.badRequest().body("Every attendance entry must include a student");
            }
            String normalizedStatus = normalizeStatus(entry.getStatus());
            if (normalizedStatus == null) {
                return ResponseEntity.badRequest().body("Attendance status must be Present, Absent or Leave");
            }
            entry.setStatus(normalizedStatus);
        }

        Long teacherId = (Long) session.getAttribute("teacherId");
        if (teacherId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Teacher session expired; please sign in again");
        }
        String teacherName = (String) session.getAttribute("teacherName"); // ✅ Get from session

        request.setTeacherId(teacherId); // Set teacherId into request for downstream use

        // ✅ Prevent duplicate attendance entry
        if (attendanceService.existsByDateGradeSectionTeacher(
                request.getDate(),
                request.getGrade(),
                request.getSection(),
                teacherId)) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Attendance already taken");
        }

        // ✅ Create and save metadata
        AttendanceMeta attendanceMeta = new AttendanceMeta();
        attendanceMeta.setDate(request.getDate());
        attendanceMeta.setGrade(request.getGrade());
        attendanceMeta.setSection(request.getSection());
        attendanceMeta.setTeacherId(teacherId);
        attendanceMeta = attendanceMetaRepository.save(attendanceMeta);

        // ✅ Save student attendance records
        for (AttendanceRequest.AttendanceEntry entry : request.getAttendancelist()) {
            StudentAttendance studentAttendance = new StudentAttendance();
            studentAttendance.setStudentId(entry.getStudentId());
            studentAttendance.setStatus(entry.getStatus());
            studentAttendance.setDate(request.getDate());
            studentAttendance.setTeacherId(teacherId);
            studentAttendance.setGrade(request.getGrade());
            studentAttendance.setSection(request.getSection());
            studentAttendance.setAttendanceMeta(attendanceMeta);

            // ✅ Set recordedBy
            studentAttendance.setRecordedBy(teacherName);

            studentAttendanceRepository.save(studentAttendance);
        }

        notificationService.notifyParentsOfAbsences(request.getAttendancelist(), request.getDate());

        return ResponseEntity.ok("Attendance submitted successfully");
    }

    private String normalizeStatus(String status) {
        if (status == null) return null;
        return switch (status.trim().toLowerCase()) {
            case "present" -> "Present";
            case "absent" -> "Absent";
            case "leave" -> "Leave";
            default -> null;
        };
    }


    @GetMapping("/check-exists")
    public ResponseEntity<Boolean> checkAttendanceExists(
            @RequestParam String grade,
            @RequestParam String section,
            @RequestParam("date") LocalDate date,
            HttpSession session) {

        Long teacherId = (Long) session.getAttribute("id");
        boolean exists = attendanceService.existsByDateGradeSectionTeacher(date, grade, section, teacherId);
        return ResponseEntity.ok(exists);
    }

    @GetMapping("/student-attendance-history")
    public String showAttendanceHistory(@RequestParam(required = false) String grade,
                                        @RequestParam(required = false) String section,
                                        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
                                        HttpSession session,
                                        Model model) {

        Long teacherId = (Long) session.getAttribute("teacherId");

        if (teacherId == null) {
            model.addAttribute("error", "Teacher ID not found in session.");
            return "login/login";
        }

        List<Student> students = studentService.getStudentsByGradeAndSection(grade, section);

        List<AttendanceMeta> history;

        if ((grade != null && !grade.isEmpty()) ||
                (section != null && !section.isEmpty()) ||
                date != null) {
            // Filtered attendance based on grade, section or date
            history = attendanceService.getFilteredStudentAttendanceHistory(teacherId, grade, section, date);
        } else {
            // Show latest attendance if nothing is selected
            history = attendanceService.getLatestStudentAttendanceByTeacher(teacherId);
        }

        model.addAttribute("history", history);
        model.addAttribute("grade", grade);
        model.addAttribute("section", section);
        model.addAttribute("date", date);
        model.addAttribute("students", students);

        return "teacher/student-Attendance/studentAttendanceHistory";
    }


}
