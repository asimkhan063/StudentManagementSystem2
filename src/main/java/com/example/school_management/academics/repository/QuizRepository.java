package com.example.school_management.academics.repository;

import com.example.school_management.academics.entity.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    @Query("select distinct q from Quiz q left join fetch q.questions where q.grade = :grade and q.section = :section order by q.createdAt desc")
    List<Quiz> findForClass(@Param("grade") String grade, @Param("section") String section);

    @Query("select distinct q from Quiz q left join fetch q.questions where q.createdBy = :teacher order by q.createdAt desc")
    List<Quiz> findByTeacher(@Param("teacher") String teacher);

    @Query("select distinct q from Quiz q left join fetch q.questions where q.id = :id")
    Optional<Quiz> findWithQuestions(@Param("id") Long id);
}
