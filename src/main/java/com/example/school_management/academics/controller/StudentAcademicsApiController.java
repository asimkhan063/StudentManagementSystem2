package com.example.school_management.academics.controller;

import com.example.school_management.academics.dto.*;
import com.example.school_management.academics.service.AcademicService;
import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/student/academics")
public class StudentAcademicsApiController {
    private final AcademicService academicService;
    private final AppUserRepository userRepository;
    public StudentAcademicsApiController(AcademicService academicService, AppUserRepository userRepository) {
        this.academicService = academicService; this.userRepository = userRepository;
    }
    @GetMapping("/assignments")
    public List<AssignmentResponse> assignments(Principal principal) { return academicService.studentAssignments(studentId(principal)); }
    @PostMapping("/assignments/{id}/submit")
    public AssignmentResponse submitAssignment(@PathVariable Long id, @Valid @RequestBody AssignmentSubmissionRequest request, Principal principal) {
        return academicService.submitAssignment(id, studentId(principal), request);
    }
    @GetMapping("/quizzes")
    public List<QuizResponse> quizzes(Principal principal) { return academicService.studentQuizzes(studentId(principal)); }
    @PostMapping("/quizzes/{id}/attempt")
    public QuizAttemptResponse submitQuiz(@PathVariable Long id, @Valid @RequestBody QuizAnswerRequest request, Principal principal) {
        return academicService.submitQuiz(id, studentId(principal), request);
    }
    @GetMapping("/report-card")
    public StudentReportCardResponse reportCard(Principal principal) { return academicService.reportCard(studentId(principal)); }

    private Long studentId(Principal principal) {
        AppUser user = userRepository.findByUsername(principal.getName());
        if (user == null || !"STUDENT".equalsIgnoreCase(user.getRole()) || user.getRoleId() == null)
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Student profile is not linked to this account");
        return user.getRoleId();
    }
}
