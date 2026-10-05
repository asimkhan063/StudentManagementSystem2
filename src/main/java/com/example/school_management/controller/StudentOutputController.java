package com.example.school_management.controller;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import com.example.school_management.TeacherFeatures.service.TeacherService;
import com.example.school_management.entity.DashboardStatsDTO;
import com.example.school_management.entity.Student;
import com.example.school_management.entity.Subject;
import com.example.school_management.entity.UserCreationRequestDTO;
import com.example.school_management.repository.StudentRepository;
import com.example.school_management.service.DashboardService;
import com.example.school_management.service.StudentService;
import com.example.school_management.service.SubjectAssignmentService;
import com.example.school_management.service.SubjectService;
import com.example.school_management.serviceImpl.UserRegistrationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RequestMapping("/admin")
@Controller
public class StudentOutputController {

    @Autowired
    private StudentService studentService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private  SubjectService subjectService;

    @Autowired
    private SubjectAssignmentService subjectAssignmentService;

    @Autowired
    private UserRegistrationService userRegService;


    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping("/dashboard")
    public String adminDashboard(Model model) {
        DashboardStatsDTO stats = dashboardService.getDashboardStats();
        List<Student> students = dashboardService.getAllStudents();

        model.addAttribute("stats", stats);
        model.addAttribute("students", students);
        return "admin/admin_dashboard";
    }

    @GetMapping("/fees")
    public String feeManagement(Model model) {
        model.addAttribute("students", studentRepository.findAll());
        return "admin/fees";
    }

    @GetMapping("/students")
    public String showStudentManagementPage() {
        return "admin/students";  // This will map to students.jsp
    }

    @GetMapping("/teachers")
    public String showTeacherManagementPage(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Teacher> teachers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            teachers = teacherService.searchTeachers(keyword);
        } else {
            teachers = teacherService.getAllTeachers();
        }

        model.addAttribute("teachers", teachers);
        model.addAttribute("keyword", keyword);  // Preserve search input in UI
        return "admin/teachers";  // This will map to students.jsp
    }

    @GetMapping("/teachers/form")
    public String showTeacherForm(@RequestParam(required = false) Long id, Model model) {
        if (id != null) {
            Teacher teacher = teacherService.getTeacherById(id);
            model.addAttribute("teacher", teacher);
        } else {
            model.addAttribute("teacher", new Teacher());
        }
        return "admin/teacher-form"; // This maps to teacher-form.jsp
    }

    @PostMapping("/teachers/save")
    public String saveTeacher(@Valid @ModelAttribute("teacher") Teacher teacher,
                              BindingResult result,
                              @RequestParam("file") MultipartFile file,
                              RedirectAttributes redirectAttributes, Model model) {

        // ✅ Step 1: Check for validation errors and return to form
        if (result.hasErrors()) {
            model.addAttribute("teacher", teacher); // Retain form data
            return "admin/teacher-form"; // Redirects back to form with errors
        }

        try {
            if (!file.isEmpty()) {
                // ✅ Generate a unique file name using UUID
                String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();

                // ✅ Define the storage path
                Path uploadDir = Paths.get("src/main/webapp/images");
                if (!Files.exists(uploadDir)) {
                    Files.createDirectories(uploadDir);
                }

                // ✅ Save the file
                Path filePath = uploadDir.resolve(fileName);
                Files.copy(file.getInputStream(), filePath);

                // ✅ Save the file path in the database
                teacher.setPhotoUrl("/images/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ Step 2: Save teacher
        teacherService.saveTeacher(teacher);
        redirectAttributes.addFlashAttribute("successMessage", "Teacher saved successfully!");

        return "redirect:/admin/teachers";
    }

    @GetMapping("/teachers/edit/{id}")
    public String editTeacher(@PathVariable Long id, Model model) {
        Teacher teacher = teacherService.getTeacherById(id);
        if (teacher == null) {
            return "redirect:/admin/teachers?error=notfound";
        }
        model.addAttribute("teacher", teacher);
        return "admin/teacher-form"; // This should match your JSP file name
    }


    @GetMapping("/studentPort")
    public String studentPortal()
    {
        return "/student_frontend/student_index.html";
    }
    @GetMapping("/studentshow")
    public String studentshow(Model model)
    {
        List<Student> students = studentService.getAllStudents();
        model.addAttribute("teachers", students);
        return "student/student_index";
    }
    @GetMapping("/addoreditstudent")
    public String saveOrEditStudent()
    {
        return "admin/addOrEditStudent";
    }

//    @GetMapping("/assign-subjects")
//    public String showAssignSubjectsForm(Model model) {
//        model.addAttribute("subjects", subjectService.getAllSubjects());
//        return "admin/assign_subjects";
//    }

    @GetMapping("/assign-subjects")
    public String showAssignSubjectsForm(Model model) {
        model.addAttribute("subjects", subjectService.getAllSubjects());
        model.addAttribute("grades", subjectService.getAllGrades()); // ["1", "2", ..., "12"]
        model.addAttribute("sections", subjectService.getAllSections()); // ["A", "B", ...]

        // Optional: to highlight already selected subjects (defaults to class 1A)
        String defaultGrade = "1";
        String defaultSection = "A";

        List<Long> assignedSubjectIds = subjectService.getAssignedSubjectIds(defaultGrade, defaultSection);
        model.addAttribute("assignedSubjectIds", assignedSubjectIds);

        return "admin/assign_subjects";
    }

    @GetMapping("/get-assigned-subjects")
    @ResponseBody
    public List<Long> getAssignedSubjectIds(@RequestParam String grade, @RequestParam String section) {
        List<Subject> assigned = subjectAssignmentService.getSubjectsForGradeAndSection(grade, section);
        return assigned.stream().map(Subject::getId).collect(Collectors.toList());
    }

    @PostMapping("/assign-subjects")
    public String handleAssignSubjects(
            @RequestParam String grade,
            @RequestParam String section,
            @RequestParam List<Long> subjectIds
    ) {
        subjectAssignmentService.assignSubjectsToClass(grade, section, subjectIds);
        return "redirect:/admin/assign-subjects?success";
    }

    @GetMapping("/create-user")
    public String showUserForm(Model model) {
        model.addAttribute("user", new UserCreationRequestDTO());
        return "admin/create_user_form";
    }

    @PostMapping("/create-user")
    public String createUser(@ModelAttribute("user") UserCreationRequestDTO dto, Model model) {
        try {
            model.addAttribute("message", userRegService.createUser(dto));
        } catch (IllegalArgumentException exception) {
            model.addAttribute("error", exception.getMessage());
        }
        return "admin/create_user_form";
    }
}
