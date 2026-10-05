package com.example.school_management.academics.entity;

import jakarta.persistence.*;

@Entity @Table(name = "quiz_questions")
public class QuizQuestion {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "quiz_id", nullable = false) private Quiz quiz;
    @Column(nullable = false, length = 1200) private String prompt;
    @Column(nullable = false, length = 400) private String optionA;
    @Column(nullable = false, length = 400) private String optionB;
    @Column(nullable = false, length = 400) private String optionC;
    @Column(nullable = false, length = 400) private String optionD;
    @Column(nullable = false, length = 1) private String correctOption;
    protected QuizQuestion() { }
    public QuizQuestion(String prompt, String optionA, String optionB, String optionC, String optionD, String correctOption) {
        this.prompt = prompt; this.optionA = optionA; this.optionB = optionB; this.optionC = optionC; this.optionD = optionD; this.correctOption = correctOption;
    }
    void setQuiz(Quiz quiz) { this.quiz = quiz; }
    public Long getId() { return id; }
    public Quiz getQuiz() { return quiz; }
    public String getPrompt() { return prompt; }
    public String getOptionA() { return optionA; }
    public String getOptionB() { return optionB; }
    public String getOptionC() { return optionC; }
    public String getOptionD() { return optionD; }
    public String getCorrectOption() { return correctOption; }
}
