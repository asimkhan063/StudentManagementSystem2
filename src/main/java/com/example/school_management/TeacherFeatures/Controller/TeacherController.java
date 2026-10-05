package com.example.school_management.TeacherFeatures.Controller;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import com.example.school_management.TeacherFeatures.repository.TeacherRepository;
import com.example.school_management.TeacherFeatures.service.StudentAttendanceService;
import com.example.school_management.TeacherFeatures.service.TeacherService;
import com.example.school_management.entity.Student;
import com.example.school_management.service.StudentService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.*;
import java.security.Principal;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/teachers")
public class TeacherController {

    private final TeacherService teacherService;

    @Autowired
    private TeacherRepository teacherRepository;

    @Autowired
    private StudentAttendanceService studentAttendanceService;

    @Autowired
    private StudentService studentService;

    public TeacherController(TeacherService teacherService) {
        this.teacherService = teacherService;
    }

    // ✅ 1. Show all teachers (for listing)
    @GetMapping("")
    public String getAllTeachers(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Teacher> teachers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            teachers = teacherService.searchTeachers(keyword);
        } else {
            teachers = teacherService.getAllTeachers();
        }

        model.addAttribute("teachers", teachers);
        model.addAttribute("keyword", keyword);  // Preserve search input in UI
        return "teacher/teacher-index";
    }

    @GetMapping("/api")   // for backend
    @ResponseBody
    public ResponseEntity<List<Teacher>> getAllTeachersApi() {
        List<Teacher> teachers = teacherService.getAllTeachers();
        return ResponseEntity.ok(teachers);  // Returns JSON response
    }

    // ✅ 2. Show Add/Update Form
    @GetMapping("/form")
    public String showTeacherForm(@RequestParam(required = false) Long id, Model model) {
        if (id != null) {
            Teacher teacher = teacherService.getTeacherById(id);
            model.addAttribute("teacher", teacher);
        } else {
            model.addAttribute("teacher", new Teacher());
        }
        return "teacher/teacher-form"; // This maps to teacher-form.jsp
    }

    // ✅ 3. Save (Add or Update) Teacher

    @PostMapping("/save")
    public String saveTeacher(@Valid @ModelAttribute("teacher") Teacher teacher,
                              BindingResult result,
                              @RequestParam("file") MultipartFile file,
                              RedirectAttributes redirectAttributes, Model model) {

        // ✅ Step 1: Check for validation errors and return to form
        if (result.hasErrors()) {
            model.addAttribute("teacher", teacher); // Retain form data
            return "teacher/teacher-form"; // Redirects back to form with errors
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

        return "redirect:/teachers/teacher-profile";
    }

    // ✅ 4. Delete a Teacher
    @GetMapping("/delete/{id}")
    public String deleteTeacher(@PathVariable Long id) {
        teacherService.deleteTeacher(id);
        return "redirect:/teachers";
    }

    @GetMapping("/edit/{id}")
    public String editTeacher(@PathVariable Long id, Model model) {
        Teacher teacher = teacherService.getTeacherById(id);
        if (teacher == null) {
            return "redirect:/teachers?error=notfound";
        }
        model.addAttribute("teacher", teacher);
        return "teacher/teacher-form"; // This should match your JSP file name
    }

    @GetMapping("/dashboard")
    public String teacherDashboard(HttpSession session, Principal principal, Model model) {
        System.out.println("Dashboard method-------------");

        if (principal == null) {
            return "redirect:/login";
        }

        System.out.println("Principal pass method-------------");

        Long teacherId = (Long) session.getAttribute("roleId"); // Assuming roleId is the teacher's ID
        String username = principal.getName(); // e.g., teacher's username
        Teacher teacher = teacherRepository.findById(teacherId).orElse(null);

        if (teacher != null) {
            session.setAttribute("teacherId", teacher.getId());
            session.setAttribute("teacherName", teacher.getName());
            session.setAttribute("teacherPhoto", teacher.getPhotoUrl());

            // Fetch data using the StudentAttendanceService methods
            int totalStudents = studentAttendanceService.getTotalStudentsAssignedToTeacher(teacher.getId());
            int totalClasses = studentAttendanceService.getTotalClassesAssignedToTeacher(teacher.getId());
            double todaysAttendancePercentage = studentAttendanceService.getTodaysAttendancePercentage(teacher.getId());
            double overallAttendanceRate = studentAttendanceService.getOverallAttendanceRate(teacher.getId());

            // Set the fetched data in the model to be accessed in the JSP
            model.addAttribute("todaysAttendance", todaysAttendancePercentage);
            model.addAttribute("totalStudents", totalStudents);
            model.addAttribute("classesAssigned", totalClasses);
            model.addAttribute("attendanceRate", overallAttendanceRate);
        }

        System.out.println("Teacher ID: " + teacherId);
        return "teacher/teacherDashboard";
    }

    @GetMapping("/teacher-profile")
    public String getTeacherProfile(HttpSession session, Model model) {
        Long teacherId = (Long) session.getAttribute("teacherId");

        // Fetch teacher details from the database using the teacherId
        Teacher teacher = teacherService.getTeacherById(teacherId);

        if (teacher != null) {
            // Add teacher object to the model if teacher exists
            model.addAttribute("teacher", teacher);
        } else {
            // Optionally, you can return an error page if the teacher is not found
            model.addAttribute("errorMessage", "Teacher not kfound.");
            return "error";  // You can define an error.jsp page to handle this
        }

        // Return the teacher profile page
        return "teacher/teacherProfile";  // Return the name of the JSP page
    }

    @GetMapping("/teacherStudents")
    public String loadTeacherStudentsPage(Model model) {
        model.addAttribute("grades", studentService.getAllGrades());
        model.addAttribute("sections", studentService.getAllSections());
        return "teacher/teacherStudents"; // JSP page name
    }

    // Handle form submission
    @PostMapping("/teacherStudents")
    public String TeacherStudents(
            @RequestParam String grade,
            @RequestParam String section,
            Model model) {

        List<Student> students = studentService.getStudentsByGradeAndSection(grade, section);

        model.addAttribute("grades", studentService.getAllGrades());
        model.addAttribute("sections", studentService.getAllSections());
        model.addAttribute("selectedGrade", grade);
        model.addAttribute("selectedSection", section);
        model.addAttribute("students", students);

        return "teacher/teacherStudents";
    }
}