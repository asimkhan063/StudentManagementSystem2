package com.example.school_management.academics.controller;

import com.example.school_management.academics.dto.*;
import com.example.school_management.academics.service.AcademicService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/teacher/academics")
public class TeacherAcademicsApiController {
    private final AcademicService academicService;
    public TeacherAcademicsApiController(AcademicService academicService) { this.academicService = academicService; }

    @PostMapping("/assignments")
    public AssignmentResponse createAssignment(@Valid @RequestBody AssignmentCreateRequest request, Principal principal) {
        return academicService.createAssignment(request, principal.getName());
    }
    @GetMapping("/assignments")
    public List<AssignmentResponse> assignments(Principal principal) { return academicService.teacherAssignments(principal.getName()); }
    @GetMapping("/submissions")
    public List<AssignmentReviewResponse> submissions(Principal principal) { return academicService.teacherSubmissions(principal.getName()); }
    @PutMapping("/submissions/{id}/grade")
    public AssignmentReviewResponse grade(@PathVariable Long id, @Valid @RequestBody AssignmentGradeRequest request, Principal principal) {
        return academicService.gradeSubmission(id, principal.getName(), request);
    }
    @PostMapping("/quizzes")
    public QuizResponse createQuiz(@Valid @RequestBody QuizCreateRequest request, Principal principal) {
        return academicService.createQuiz(request, principal.getName());
    }
    @GetMapping("/quizzes")
    public List<QuizResponse> quizzes(Principal principal) { return academicService.teacherQuizzes(principal.getName()); }
    @GetMapping("/report-cards")
    public List<StudentReportCardResponse> reportCards(@RequestParam String grade, @RequestParam String section) {
        return academicService.classReportCards(grade, section);
    }
}
