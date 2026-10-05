package com.example.school_management.ai;

import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;

@Service
public class AssistantService {

    private final ObjectProvider<AiService> aiServiceProvider;

    public AssistantService(ObjectProvider<AiService> aiServiceProvider) {
        this.aiServiceProvider = aiServiceProvider;
    }

    public String getAnswer(String question) {

        if (question == null || question.trim().isEmpty()) {
            return "Please ask me a question.";
        }

        AiService aiService = aiServiceProvider.getIfAvailable();
        if (aiService != null && aiService.isAvailable()) {
            try {
                return aiService.askAI(question);
            } catch (Exception exception) {
                return "AI jawaab dene mein abhi dikkat aa rahi hai. Thodi der baad phir koshish kijiye.";
            }
        }

        String q = question.toLowerCase().trim();

        // Greeting
        if (q.contains("hello") ||
                q.contains("hi") ||
                q.contains("hey")) {

            return "Hello! 👋 I am your School Management Assistant. "
                    + "How can I help you?";
        }

        // Student
        if (q.contains("student") &&
                (q.contains("add") ||
                        q.contains("register") ||
                        q.contains("create"))) {

            return "To add a student, go to Student Management → Add Student. "
                    + "Enter the required student details and save the form.";
        }

        // Teacher
        if (q.contains("teacher") &&
                (q.contains("add") ||
                        q.contains("register") ||
                        q.contains("create"))) {

            return "To add a teacher, go to Teacher Management → Add Teacher. "
                    + "Enter the required teacher details and save the form.";
        }

        // Admin
        if (q.contains("admin")) {

            return "Admin can manage school-related information such as "
                    + "students, teachers and other system records.";
        }

        // Login
        if (q.contains("login") ||
                q.contains("sign in")) {

            return "Use your registered username and password on the login page "
                    + "to access the School Management System.";
        }

        // Help
        if (q.contains("help") ||
                q.contains("what can you do")) {

            return "I can help you with Student Management, Teacher Management, "
                    + "Admin features, Login and basic school-system questions.";
        }

        // Default response
        return "I am the School Management Assistant. "
                + "I can currently help with students, teachers, admin features "
                + "and login-related questions. Please ask me something related "
                + "to the school system.";
    }
}
