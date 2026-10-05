
package com.example.school_management.TeacherFeatures.repository;

import com.example.school_management.TeacherFeatures.entity.AttendanceMeta;
import com.example.school_management.TeacherFeatures.entity.StudentAttendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface StudentAttendanceRepository extends JpaRepository<StudentAttendance, Long> {
    List<StudentAttendance> findByStudentId(Long studentId);
    List<StudentAttendance> findByStudentIdOrderByDateDesc(Long studentId);
    List<StudentAttendance> findByDate(LocalDate date);
    @Query("SELECT sa FROM StudentAttendance sa JOIN FETCH sa.student WHERE sa.attendanceMeta = :meta")
    List<StudentAttendance> findByAttendanceMetaWithStudent(@Param("meta") AttendanceMeta attendanceMeta);

    @Query("SELECT COUNT(sa) FROM StudentAttendance sa WHERE sa.teacherId = :teacherId AND sa.date = :date AND sa.status = :status")
    int countByTeacherIdAndDateAndStatus(@Param("teacherId") Long teacherId, @Param("date") LocalDate date, @Param("status") String status);

    @Query("SELECT COUNT(sa) FROM StudentAttendance sa WHERE sa.teacherId = :teacherId AND sa.date = :date")
    int countByTeacherIdAndDate(@Param("teacherId") Long teacherId, @Param("date") LocalDate date);

    @Query("SELECT COUNT(DISTINCT sa.studentId) FROM StudentAttendance sa WHERE sa.teacherId = :teacherId")
    int countDistinctStudentsByTeacherId(@Param("teacherId") Long teacherId);

    @Query("SELECT COUNT(sa) FROM StudentAttendance sa WHERE sa.teacherId = :teacherId AND sa.status = :status")
    int countByTeacherIdAndStatus(@Param("teacherId") Long teacherId, @Param("status") String status);

    @Query("SELECT COUNT(sa) FROM StudentAttendance sa WHERE sa.teacherId = :teacherId")
    int countByTeacherId(@Param("teacherId") Long teacherId);

    boolean existsByAttendanceMetaDateAndAttendanceMetaGradeAndAttendanceMetaSection(LocalDate date, String grade, String section);


    List<StudentAttendance> findByAttendanceMeta(AttendanceMeta attendanceMeta);

}
