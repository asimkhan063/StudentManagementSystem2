package com.example.school_management.academics.service;

import com.example.school_management.academics.dto.*;
import com.example.school_management.academics.entity.*;
import com.example.school_management.academics.repository.*;
import com.example.school_management.entity.Student;
import com.example.school_management.repository.StudentRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@Service
public class AcademicService {
    private final AssignmentRepository assignmentRepository;
    private final AssignmentSubmissionRepository submissionRepository;
    private final QuizRepository quizRepository;
    private final QuizAttemptRepository attemptRepository;
    private final StudentRepository studentRepository;

    public AcademicService(AssignmentRepository assignmentRepository,
                           AssignmentSubmissionRepository submissionRepository,
                           QuizRepository quizRepository,
                           QuizAttemptRepository attemptRepository,
                           StudentRepository studentRepository) {
        this.assignmentRepository = assignmentRepository;
        this.submissionRepository = submissionRepository;
        this.quizRepository = quizRepository;
        this.attemptRepository = attemptRepository;
        this.studentRepository = studentRepository;
    }

    @Transactional
    public AssignmentResponse createAssignment(AssignmentCreateRequest request, String teacher) {
        Assignment assignment = assignmentRepository.save(new Assignment(request.title().trim(),
                request.description().trim(), request.grade().trim(), request.section().trim(),
                request.dueDate(), request.maxScore(), teacher));
        return assignmentResponse(assignment, null);
    }

    @Transactional(readOnly = true)
    public List<AssignmentResponse> teacherAssignments(String teacher) {
        return assignmentRepository.findByCreatedByOrderByCreatedAtDesc(teacher).stream()
                .map(a -> assignmentResponse(a, null)).toList();
    }

    @Transactional(readOnly = true)
    public List<AssignmentReviewResponse> teacherSubmissions(String teacher) {
        return submissionRepository.findByAssignment_CreatedByOrderBySubmittedAtDesc(teacher).stream()
                .map(this::reviewResponse).toList();
    }

    @Transactional(readOnly = true)
    public List<AssignmentResponse> studentAssignments(Long studentId) {
        Student student = getStudent(studentId);
        return assignmentRepository.findByGradeAndSectionOrderByDueDateAsc(student.getGrade(), student.getSection())
                .stream().map(a -> assignmentResponse(a,
                        submissionRepository.findByAssignmentIdAndStudentId(a.getId(), studentId).orElse(null)))
                .toList();
    }

    @Transactional
    public AssignmentResponse submitAssignment(Long assignmentId, Long studentId, AssignmentSubmissionRequest request) {
        Assignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Assignment not found"));
        Student student = getStudent(studentId);
        assertClassMatches(assignment.getGrade(), assignment.getSection(), student);
        if (assignment.getDueDate().isBefore(java.time.LocalDate.now())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "The assignment submission deadline has passed");
        }
        if (submissionRepository.findByAssignmentIdAndStudentId(assignmentId, studentId).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This assignment has already been submitted");
        }
        AssignmentSubmission saved = submissionRepository.save(new AssignmentSubmission(assignment, student, request.responseText().trim()));
        return assignmentResponse(assignment, saved);
    }

    @Transactional
    public AssignmentReviewResponse gradeSubmission(Long submissionId, String teacher, AssignmentGradeRequest request) {
        AssignmentSubmission submission = submissionRepository.findById(submissionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Submission not found"));
        if (!submission.getAssignment().getCreatedBy().equals(teacher)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You can grade only assignments you created");
        }
        if (request.score() > submission.getAssignment().getMaxScore()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Score cannot exceed the assignment maximum");
        }
        submission.grade(request.score(), request.feedback() == null ? null : request.feedback().trim());
        return reviewResponse(submission);
    }

    @Transactional
    public QuizResponse createQuiz(QuizCreateRequest request, String teacher) {
        Quiz quiz = new Quiz(request.title().trim(), request.grade().trim(), request.section().trim(), teacher);
        request.questions().forEach(q -> quiz.addQuestion(new QuizQuestion(q.prompt().trim(), q.optionA().trim(),
                q.optionB().trim(), q.optionC().trim(), q.optionD().trim(), q.correctOption().toUpperCase(Locale.ROOT))));
        return quizResponse(quizRepository.save(quiz), null);
    }

    @Transactional(readOnly = true)
    public List<QuizResponse> teacherQuizzes(String teacher) {
        return quizRepository.findByTeacher(teacher).stream().map(q -> quizResponse(q, null)).toList();
    }

    @Transactional(readOnly = true)
    public List<QuizResponse> studentQuizzes(Long studentId) {
        Student student = getStudent(studentId);
        return quizRepository.findForClass(student.getGrade(), student.getSection()).stream()
                .map(q -> quizResponse(q, attemptRepository.findByQuizIdAndStudentId(q.getId(), studentId).orElse(null)))
                .toList();
    }

    @Transactional
    public QuizAttemptResponse submitQuiz(Long quizId, Long studentId, QuizAnswerRequest request) {
        Quiz quiz = quizRepository.findWithQuestions(quizId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Quiz not found"));
        Student student = getStudent(studentId);
        assertClassMatches(quiz.getGrade(), quiz.getSection(), student);
        if (attemptRepository.findByQuizIdAndStudentId(quizId, studentId).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This quiz has already been attempted");
        }
        Map<Long, String> answers = new HashMap<>();
        for (QuizAnswerRequest.Answer answer : request.answers()) {
            if (answers.put(answer.questionId(), answer.selectedOption().toUpperCase(Locale.ROOT)) != null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "A question was answered more than once");
            }
        }
        if (answers.size() != quiz.getQuestions().size()
                || quiz.getQuestions().stream().anyMatch(q -> !answers.containsKey(q.getId()))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Answer every quiz question exactly once");
        }
        int score = 0;
        for (QuizQuestion question : quiz.getQuestions()) {
            String selected = answers.get(question.getId());
            if (!List.of("A", "B", "C", "D").contains(selected)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid answer option");
            }
            if (question.getCorrectOption().equalsIgnoreCase(selected)) score++;
        }
        QuizAttempt attempt = attemptRepository.save(new QuizAttempt(quiz, student, score, quiz.getQuestions().size()));
        return attemptResponse(attempt);
    }

    @Transactional(readOnly = true)
    public List<StudentReportCardResponse> classReportCards(String grade, String section) {
        return studentRepository.findByGradeAndSection(grade, section).stream().map(s -> reportCard(s.getId())).toList();
    }

    @Transactional(readOnly = true)
    public StudentReportCardResponse reportCard(Long studentId) {
        Student student = getStudent(studentId);
        List<QuizAttemptResponse> quizzes = attemptRepository.findByStudent_IdOrderBySubmittedAtDesc(studentId)
                .stream().map(this::attemptResponse).toList();
        List<AssignmentResponse> assignments = submissionRepository.findByStudent_IdOrderBySubmittedAtDesc(studentId)
                .stream().map(s -> assignmentResponse(s.getAssignment(), s)).toList();
        double quizAverage = quizzes.isEmpty() ? 0.0 : quizzes.stream()
                .mapToDouble(q -> q.percentage()).average().orElse(0.0);
        List<AssignmentSubmission> graded = submissionRepository.findByStudent_IdOrderBySubmittedAtDesc(studentId)
                .stream().filter(s -> s.getScore() != null).toList();
        Double assignmentAverage = graded.isEmpty() ? null : graded.stream()
                .mapToDouble(s -> s.getScore() * 100.0 / s.getAssignment().getMaxScore()).average().orElse(0.0);
        return new StudentReportCardResponse(student.getId(), student.getName(), student.getGrade(), student.getSection(),
                quizzes.size(), round(quizAverage), assignments.size(), graded.size(),
                assignmentAverage == null ? null : round(assignmentAverage), quizzes, assignments);
    }

    private AssignmentResponse assignmentResponse(Assignment a, AssignmentSubmission s) {
        return new AssignmentResponse(a.getId(), a.getTitle(), a.getDescription(), a.getGrade(), a.getSection(),
                a.getDueDate(), a.getMaxScore(), a.getCreatedAt(), s == null ? null : s.getId(),
                s == null ? null : s.getSubmittedAt(), s == null ? null : s.getScore(), s == null ? null : s.getFeedback());
    }

    private AssignmentReviewResponse reviewResponse(AssignmentSubmission s) {
        var a = s.getAssignment(); var student = s.getStudent();
        return new AssignmentReviewResponse(s.getId(), a.getId(), a.getTitle(), student.getId(), student.getName(),
                student.getGrade(), student.getSection(), s.getResponseText(), s.getSubmittedAt(), s.getScore(),
                a.getMaxScore(), s.getFeedback());
    }

    private QuizResponse quizResponse(Quiz q, QuizAttempt attempt) {
        List<QuizQuestionResponse> questions = q.getQuestions().stream().map(item -> new QuizQuestionResponse(
                item.getId(), item.getPrompt(), item.getOptionA(), item.getOptionB(), item.getOptionC(), item.getOptionD())).toList();
        return new QuizResponse(q.getId(), q.getTitle(), q.getGrade(), q.getSection(), q.getCreatedAt(), questions,
                attempt == null ? null : attempt.getScore(), attempt == null ? null : attempt.getMaxScore(),
                attempt == null ? null : attempt.getSubmittedAt());
    }

    private QuizAttemptResponse attemptResponse(QuizAttempt a) {
        double percentage = a.getMaxScore() == 0 ? 0 : a.getScore() * 100.0 / a.getMaxScore();
        return new QuizAttemptResponse(a.getId(), a.getQuiz().getId(), a.getQuiz().getTitle(), a.getStudent().getId(),
                a.getStudent().getName(), a.getScore(), a.getMaxScore(), round(percentage), a.getSubmittedAt());
    }

    private Student getStudent(Long studentId) {
        return studentRepository.findById(studentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Student profile not found"));
    }

    private void assertClassMatches(String grade, String section, Student student) {
        if (!grade.equals(student.getGrade()) || !section.equals(student.getSection())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "This item is for a different class");
        }
    }

    private double round(double value) { return Math.round(value * 100.0) / 100.0; }
}
