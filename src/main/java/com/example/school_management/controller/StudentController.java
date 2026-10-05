package com.example.school_management.controller;

import com.example.school_management.entity.StudentDTO;
import com.example.school_management.entity.Student;
import com.example.school_management.serviceImpl.StudentServiceImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/students")
public class StudentController {
    private final StudentServiceImpl studentService;

    public StudentController(StudentServiceImpl studentServiceImpl) {
        this.studentService = studentServiceImpl;
    }

    @PostMapping
    public ResponseEntity<?>  uploadStudent(@ModelAttribute StudentDTO studentDTO) throws IOException {
        String imagePath = null;

        if (studentDTO.getImage() != null && !studentDTO.getImage().isEmpty()) {
            imagePath = studentService.savePhoto(studentDTO.getImage());
        } else {
            imagePath = studentService.generatePlaceholder(studentDTO.getName());
        }

        Student student = new Student();
        student.setName(studentDTO.getName());
        student.setEmail(studentDTO.getEmail());
        student.setGrade(studentDTO.getGrade());
        student.setAddress(studentDTO.getAddress());
        student.setRollNo(studentDTO.getRollNo());
        student.setFatherName(studentDTO.getFatherName());
        student.setMotherName(studentDTO.getMotherName());
        student.setAadhaarNo(studentDTO.getAadhaarNo());
        student.setPhoneNo(studentDTO.getPhoneNo());
        student.setAltPhoneNo(studentDTO.getAltPhoneNo());
        student.setGender(studentDTO.getGender());
        student.setSection(studentDTO.getSection());
        student.setSessionId(studentDTO.getSessionId());
        student.setPhotoPath(imagePath);

        studentService.addStudent(student);
        return ResponseEntity.ok().body(student);
    }

    @PutMapping(value = "/{id}")
    public ResponseEntity<Student> updateStudent(
            @PathVariable Long id,
            @ModelAttribute StudentDTO studentDTO
            //        ,@RequestPart(value = "photo", required = false) MultipartFile photo
    ) {
        Optional<Student> existingStudent = studentService.getStudentByIdOptional(id);
        if (existingStudent.isEmpty()) {
            return ResponseEntity.notFound().build();
        }



        Student student = existingStudent.get();
        student.setName(studentDTO.getName());
        student.setEmail(studentDTO.getEmail());
        student.setGrade(studentDTO.getGrade());
        student.setAddress(studentDTO.getAddress());
        student.setRollNo(studentDTO.getRollNo());
        student.setFatherName(studentDTO.getFatherName());
        student.setMotherName(studentDTO.getMotherName());
        student.setAadhaarNo(studentDTO.getAadhaarNo());
        student.setPhoneNo(studentDTO.getPhoneNo());
        student.setAltPhoneNo(studentDTO.getAltPhoneNo());
        student.setGender(studentDTO.getGender());
        student.setSection(studentDTO.getSection());
        student.setSessionId(studentDTO.getSessionId());
        if (studentDTO.getImage() != null && !studentDTO.getImage().isEmpty()) {
            String uimagePath = null;
            uimagePath = studentService.savePhoto(studentDTO.getImage());
            student.setPhotoPath(uimagePath);
            System.out.println("updated");
        }

        Student updatedStudent = studentService.updateStudent(id, student);
        return ResponseEntity.ok(updatedStudent);
    }

    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        return ResponseEntity.ok(studentService.getAllStudents());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudentById(@PathVariable Long id) {
        return ResponseEntity.ok(studentService.getStudentById(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        studentService.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }
}