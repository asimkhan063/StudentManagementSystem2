package com.example.school_management.TeacherFeatures.repository;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Long> {

    @Query("SELECT t FROM Teacher t WHERE LOWER(t.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(t.email) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(t.specialization) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Teacher> searchByKeyword(@Param("keyword") String keyword);
}