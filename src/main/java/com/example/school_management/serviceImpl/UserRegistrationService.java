package com.example.school_management.serviceImpl;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import com.example.school_management.TeacherFeatures.repository.TeacherRepository;
import com.example.school_management.entity.Admin;
import com.example.school_management.entity.AppUser;
import com.example.school_management.entity.Student;
import com.example.school_management.entity.UserCreationRequestDTO;
import com.example.school_management.repository.AdminRepository;
import com.example.school_management.repository.AppUserRepository;
import com.example.school_management.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;

@Service
public class UserRegistrationService {

    @Autowired
    private StudentRepository studentRepo;

    @Autowired
    private TeacherRepository teacherRepo;

    @Autowired
    private AdminRepository adminRepo;

    @Autowired
    private AppUserRepository logUserRepo;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private PasswordEncoder passwordEncoder;



    @Transactional
    public String createUser(UserCreationRequestDTO dto) {
        if (dto.getEmail() == null || dto.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }
        String generatedUsername = dto.getEmail().trim().toLowerCase();
        if (logUserRepo.existsByUsername(generatedUsername)) {
            throw new IllegalArgumentException("An account with this email already exists");
        }

        String generatedPassword = generateRandomPassword(8);
        String encodedPassword = passwordEncoder.encode(generatedPassword);
        Long userProfileId = null;
        String role = dto.getRole() == null ? "" : dto.getRole().trim().toUpperCase();

        switch (role) {
            case "STUDENT" -> {
                Student student = new Student();
                student.setName(dto.getName());
                student.setEmail(generatedUsername);
                student.setGrade(dto.getGrade());
                student.setSection(dto.getSection());
                studentRepo.save(student);
                userProfileId = student.getId();
            }
            case "TEACHER" -> {
                Teacher teacher = new Teacher();
                teacher.setName(dto.getName());
                teacher.setEmail(generatedUsername);
                teacherRepo.save(teacher);
                userProfileId = teacher.getId();
            }
            case "ADMIN" -> {
                Admin admin = new Admin();
                admin.setFullName(dto.getName());
                admin.setEmail(generatedUsername);
                adminRepo.save(admin);
                userProfileId = admin.getId();
            }
            case "PARENT" -> { }
            default -> throw new IllegalArgumentException("Unsupported account role");
        }

        AppUser user = new AppUser();
        user.setUsername(generatedUsername);
        user.setDisplayName(dto.getName());
        user.setPassword(encodedPassword);
        user.setRole(role);
        user.setRoleId(userProfileId);
        user.setMustChangePassword(true);
        logUserRepo.save(user);

        try {
            sendEmail(dto.getEmail(), generatedUsername, generatedPassword);
            return "Account created and login credentials emailed successfully.";
        } catch (MailException exception) {
            // Keep the account creation transaction successful even when SMTP is unavailable.
            // The user is forced to change this temporary password after their first login.
            return "Account created, but email delivery failed. Give this temporary password to the user securely: "
                    + generatedPassword;
        }
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private void sendEmail(String toEmail, String username, String password) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("School Management System - Your Login Details");
        message.setText("Dear user,\n\nYour login details are:\nUsername: " + username + "\nPassword: " + password +
                "\n\nLogin here: https://yourdomain.com/login\n\nRegards,\nAdmin Team");
        mailSender.send(message);
    }
}
