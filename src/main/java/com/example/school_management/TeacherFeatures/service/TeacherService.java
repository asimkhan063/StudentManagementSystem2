package com.example.school_management.TeacherFeatures.service;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import java.util.List;

public interface TeacherService {
    List<Teacher> getAllTeachers();

    Teacher getTeacherById(Long id);

    void saveTeacher(Teacher teacher);

    void deleteTeacher(Long id);

    List<Teacher> searchTeachers(String keyword);

}