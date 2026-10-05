package com.example.school_management.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.time.Instant;

@Entity
@Table(name = "notification_logs", uniqueConstraints =
        @UniqueConstraint(name = "uk_notification_event_key", columnNames = "event_key"))
public class NotificationLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "event_key", nullable = false, length = 64)
    private String eventKey;

    @Column(name = "sent_at", nullable = false)
    private Instant sentAt;

    protected NotificationLog() { }

    public NotificationLog(String eventKey) {
        this.eventKey = eventKey;
        this.sentAt = Instant.now();
    }
}
