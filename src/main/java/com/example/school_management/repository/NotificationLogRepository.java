package com.example.school_management.repository;

import com.example.school_management.entity.NotificationLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationLogRepository extends JpaRepository<NotificationLog, Long> {
    boolean existsByEventKey(String eventKey);
}
