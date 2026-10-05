package com.example.school_management.repository;

import com.example.school_management.entity.ParentStudentLink;
import com.example.school_management.entity.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ParentStudentLinkRepository extends JpaRepository<ParentStudentLink, Long> {

    boolean existsByParentIdAndStudentId(Long parentId, Long studentId);

    @Query("select link from ParentStudentLink link join fetch link.parent join fetch link.student order by link.id desc")
    List<ParentStudentLink> findAllWithParentAndStudent();

    @Query("select link from ParentStudentLink link join fetch link.student where lower(link.parent.username) = lower(:email)")
    List<ParentStudentLink> findChildrenForParent(@Param("email") String email);

    @Query("select link.parent from ParentStudentLink link where link.student.id = :studentId")
    List<AppUser> findParentsForStudent(@Param("studentId") Long studentId);

    @Query("select case when count(link) > 0 then true else false end from ParentStudentLink link " +
            "where lower(link.parent.username) = lower(:email) and link.student.id = :studentId")
    boolean isParentLinkedToStudent(@Param("email") String email, @Param("studentId") Long studentId);
}
