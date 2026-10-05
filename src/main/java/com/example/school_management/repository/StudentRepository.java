package com.example.school_management.repository;

import com.example.school_management.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    // Student Attandance
    List<Student> findByGradeAndSection(String grade, String section); // Ensure 'classId' data type matches in Student entity
    @Query("SELECT DISTINCT s.grade FROM Student s")
    List<String> findDistinctGrades();

    @Query("SELECT DISTINCT s.section FROM Student s")
    List<String> findDistinctSections();

}