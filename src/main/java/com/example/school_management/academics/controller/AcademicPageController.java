package com.example.school_management.academics.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AcademicPageController {
    @GetMapping("/teachers/academics")
    public String teacherAcademics() { return "teacher/academics"; }

    @GetMapping("/student/academics")
    public String studentAcademics() { return "student/academics"; }
}
