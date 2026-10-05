package com.example.school_management.academics.repository;

import com.example.school_management.academics.entity.QuizAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {
    Optional<QuizAttempt> findByQuizIdAndStudentId(Long quizId, Long studentId);
    List<QuizAttempt> findByQuiz_CreatedByOrderBySubmittedAtDesc(String teacher);
    List<QuizAttempt> findByStudent_IdOrderBySubmittedAtDesc(Long studentId);
}
