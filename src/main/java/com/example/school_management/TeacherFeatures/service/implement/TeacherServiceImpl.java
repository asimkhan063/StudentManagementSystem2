package com.example.school_management.TeacherFeatures.service.implement;

import com.example.school_management.TeacherFeatures.entity.Teacher;
import com.example.school_management.TeacherFeatures.repository.TeacherRepository;
import com.example.school_management.TeacherFeatures.service.TeacherService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class TeacherServiceImpl implements TeacherService {

    private final TeacherRepository teacherRepository;

    public TeacherServiceImpl(TeacherRepository teacherRepository) {
        this.teacherRepository = teacherRepository;
    }

    // ✅ 1. Get all teachers
    @Override
    public List<Teacher> getAllTeachers() {
        return teacherRepository.findAll();
    }

    // ✅ 2. Get teacher by ID
    public Teacher getTeacherById(Long id) {
        return teacherRepository.findById(id).orElse(null);
    }

    // ✅ 3. Save (Add or Update) teacher
    @Override
    public void saveTeacher(Teacher teacher) {
        teacherRepository.save(teacher);
    }

    // ✅ 4. Delete teacher by ID
    @Transactional
    public void deleteTeacher(Long id) {
        teacherRepository.deleteById(id);
    }

    @Override
    public List<Teacher> searchTeachers(String keyword) {
        return teacherRepository.searchByKeyword(keyword);
    }

}