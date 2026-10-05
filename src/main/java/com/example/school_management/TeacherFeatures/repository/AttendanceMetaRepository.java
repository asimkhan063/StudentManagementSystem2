package com.example.school_management.TeacherFeatures.repository;

import com.example.school_management.TeacherFeatures.entity.AttendanceMeta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AttendanceMetaRepository extends JpaRepository<AttendanceMeta, Long> {
    boolean existsByDateAndGradeAndSectionAndTeacherId(LocalDate date, String grade, String section, Long teacherId);

    boolean existsByDateAndGradeAndSection(LocalDate date, String grade, String section);

    @Query("SELECT a FROM AttendanceMeta a WHERE a.teacherId = :teacherId " +
            "AND (:grade IS NULL OR a.grade = :grade) " +
            "AND (:section IS NULL OR a.section = :section) " +
            "AND (:date IS NULL OR a.date = :date) " +
            "ORDER BY a.date DESC")
    List<AttendanceMeta> findByFilters(@Param("teacherId") Long teacherId,
                                       @Param("grade") String grade,
                                       @Param("section") String section,
                                       @Param("date") LocalDate date);

    @Query(value = "SELECT COUNT(DISTINCT am.grade || '-' || am.section) FROM attendance_meta am WHERE am.teacher_id = :teacherId", nativeQuery = true)
    int countDistinctClassesByTeacherId(@Param("teacherId") Long teacherId);

    @Query("SELECT a FROM AttendanceMeta a ORDER BY a.date DESC")
    List<AttendanceMeta> findAllAttendanceMeta();

    List<AttendanceMeta> findByTeacherId(Long teacherId);
    List<AttendanceMeta> findByTeacherIdAndDate(Long teacherId, LocalDate date);
    List<AttendanceMeta> findByTeacherIdAndGrade(Long teacherId, String grade);
    List<AttendanceMeta> findByTeacherIdAndSection(Long teacherId, String section);
    List<AttendanceMeta> findByTeacherIdAndGradeAndSection(Long teacherId, String grade, String section);
    List<AttendanceMeta> findByTeacherIdAndGradeAndSectionAndDate(Long teacherId, String grade, String section, LocalDate date);

    @Query("SELECT MAX(a.date) FROM AttendanceMeta a WHERE a.teacherId = :teacherId")
    LocalDate findLatestAttendanceDateByTeacherId(@Param("teacherId") Long teacherId);

}