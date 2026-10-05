package com.example.school_management.serviceImpl;

import com.example.school_management.entity.Student;
import com.example.school_management.repository.StudentRepository;
import com.example.school_management.service.StudentService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

@Service
public class StudentServiceImpl implements StudentService {
    private final StudentRepository studentRepository;

    public StudentServiceImpl(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @Override
    public Student addStudent(Student student) {
        return studentRepository.save(student);
    }

    @Override
    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    // student Attendance part
    @Override
    public List<Student> getStudentsByGradeAndSection(String grade, String section) {
        List<Student> students = studentRepository.findByGradeAndSection(grade, section);

        // Debugging
        System.out.println("Fetched students for Grade: " + grade + ", Section: " + section);
        students.forEach(student -> System.out.println(student.getName()));

        return students;
    }

    // student Attendance
    @Override
    public List<String> getAllGrades() {                            // Student Attandance
        return studentRepository.findDistinctGrades();
    }

    // student Attendance
    @Override
    public List<String> getAllSections() {              // Student Attandance
        return studentRepository.findDistinctSections();
    }

    @Override
    public Student getStudentById(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + id));
    }
    public Optional<Student> getStudentByIdOptional(Long id) {
        return studentRepository.findById(id);
    }

    @Override
    public Student updateStudent(Long id, Student student) {
        Student existingStudent = getStudentById(id);
        existingStudent.setName(student.getName());
        existingStudent.setEmail(student.getEmail());
        existingStudent.setGrade(student.getGrade());
        existingStudent.setAddress(student.getAddress());
        existingStudent.setPhoneNo(student.getPhoneNo());
        existingStudent.setRollNo(student.getRollNo());
        existingStudent.setFatherName(student.getFatherName());
        existingStudent.setMotherName(student.getMotherName());
        existingStudent.setAadhaarNo(student.getAadhaarNo());
        existingStudent.setAltPhoneNo(student.getAltPhoneNo());
        existingStudent.setGender(student.getGender());
        existingStudent.setSection(student.getSection());
        existingStudent.setSessionId(student.getSessionId());
        return studentRepository.save(existingStudent);
    }

    @Override
    public void deleteStudent(Long id) {
        studentRepository.deleteById(id);
    }


    public String savePhoto(MultipartFile photo) {
        try {
            String directory = "src/main/webapp/images/";
            String filename = UUID.randomUUID() + "_" + photo.getOriginalFilename();

            // Save the file to the directory
            Path filePath = Paths.get(directory + filename);
            Files.createDirectories(filePath.getParent());
            Files.write(filePath, photo.getBytes());

            // Return the web-accessible path
            return "/images/" + filename;
        } catch (IOException e) {
            throw new RuntimeException("Failed to save photo", e);
        }
    }

    @Override
    public String generatePlaceholder(String name) {
        try {
            String firstLetter = name.substring(0, 1).toUpperCase();
            String backgroundColor = generateRandomColor();

            int width = 100;
            int height = 100;
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = image.createGraphics();

            g2d.setColor(Color.decode(backgroundColor));
            g2d.fillRect(0, 0, width, height);

            g2d.setColor(Color.WHITE);
            g2d.setFont(new Font("Arial", Font.BOLD, 50));
            FontMetrics fm = g2d.getFontMetrics();
            int x = (width - fm.stringWidth(firstLetter)) / 2;
            int y = ((height - fm.getHeight()) / 2) + fm.getAscent();
            g2d.drawString(firstLetter, x, y);
            g2d.dispose();

            String directory = "admin/placeholders/";
            String filename = UUID.randomUUID() + "_placeholder.png";
            Path filePath = Paths.get(directory + filename);
            Files.createDirectories(filePath.getParent());
            ImageIO.write(image, "png", filePath.toFile());

            // Return the web-accessible path
            return "placeholders/" + filename;
        } catch (IOException e) {
            throw new RuntimeException("Failed to generate placeholder", e);
        }
    }

    @Override
    public String generateRandomColor() {
        Random random = new Random();
        int r = random.nextInt(256);
        int g = random.nextInt(256);
        int b = random.nextInt(256);
        return String.format("#%02x%02x%02x", r, g, b);
    }

}