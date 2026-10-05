package com.example.school_management.controller;

import com.example.school_management.entity.Student;
import com.example.school_management.entity.StudentDTO;
import com.example.school_management.entity.Subject;
import com.example.school_management.repository.StudentRepository;
import com.example.school_management.service.StudentService;
import com.example.school_management.service.SubjectService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;
import java.util.UUID;

@RequestMapping("/student")
@Controller
public class StudentDashboardController {

    @Autowired
    private StudentService studentService;
    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private SubjectService subjectService;

//    @Autowired
//    private SubjectService subjectService;
//
//    @Autowired
//    private AttendanceService attendanceService;
//
//    @Autowired
//    private GradeService gradeService;


    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model, Principal principal) {
        String username = principal.getName();
        Long id=(Long)session.getAttribute("roleId");
        //Student student = studentRepository.findByUserUsername(username).orElse(null);
        Student student = studentRepository.findById(id).orElse(null);
        if (student != null) {
            session.setAttribute("studentId", student.getId());
            model.addAttribute("student", student);
        }
        return "student/student_dashboard";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session,Model model, Principal principal) {
        String username = principal.getName();
        Long id=(Long)session.getAttribute("roleId");
        //Student student = studentRepository.findByUserUsername(username).orElse(null);
        Student student = studentRepository.findById(id).orElse(null);
        model.addAttribute("student", student);
        return "student/profile";
    }

    @GetMapping("/subjects")
    public String studentSubjects(Model model, HttpSession session) {
//        Long studentId = (Long) session.getAttribute("roleId");
//        Student student = studentRepository.findById(studentId).orElse(null);
//
//        List<Subject> subjects = subjectService.getSubjectsForStudent(student);
//        model.addAttribute("subjects", subjects);
//        return "student/subject_list";
        Long studentId = (Long) session.getAttribute("roleId");

        if (studentId == null) {
            return "redirect:/login"; // or handle session expiration
        }

        Student student = studentRepository.findById(studentId).orElse(null);

        if (student == null) {
            return "redirect:/login";
        }

        List<Subject> subjects = subjectService.getSubjectsForStudent(student);

        model.addAttribute("subjects", subjects);
        model.addAttribute("student", student); // ✅ Add this line

        return "student/subject_list";
    }

    @GetMapping("/edit")
    public String showEditForm(@RequestParam("id") Long studentId, Model model, HttpSession session) {
        if (studentId == null) {
            return "redirect:/login";
        }

        Student student = studentService.getStudentById(studentId);
        model.addAttribute("student", student);

        return "student/edit_profile"; // JSP file name
    }

/*

    @PostMapping("/update")
    public String updateStudentFromDashboard(@ModelAttribute Student student,
                                             @RequestParam("image") MultipartFile image,
                                             HttpSession session,
                                             RedirectAttributes redirectAttributes) {
        Long studentId = (Long) session.getAttribute("roleId");
        if (studentId == null) {
            return "redirect:/login";
        }

        //student.setId(studentId); // Ensure the correct ID is used

        try {
            if (!image.isEmpty()) {
                String fileName = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
                Path uploadPath = Paths.get("src/main/webapp/images");

                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                Path filePath = uploadPath.resolve(fileName);
                Files.copy(image.getInputStream(), filePath);

                student.setPhotoPath("/images/" + fileName);
            }

            studentService.updateStudent(studentId,student); // Make sure this method exists
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to update profile.");
        }

        return "redirect:/student-dashboard";
    }
*/

}