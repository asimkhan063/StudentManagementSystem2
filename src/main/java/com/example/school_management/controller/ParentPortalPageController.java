package com.example.school_management.controller;

import com.example.school_management.repository.StudentRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ParentPortalPageController {

    private final StudentRepository studentRepository;

    public ParentPortalPageController(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @GetMapping("/admin/parents")
    public String parentLinksPage(Model model) {
        model.addAttribute("students", studentRepository.findAll());
        return "admin/parents";
    }

    @GetMapping("/parent/dashboard")
    public String parentDashboard() {
        return "parent/dashboard";
    }
}
