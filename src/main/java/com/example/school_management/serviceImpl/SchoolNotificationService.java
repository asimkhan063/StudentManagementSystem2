package com.example.school_management.serviceImpl;

import com.example.school_management.TeacherFeatures.dto.AttendanceRequest;
import com.example.school_management.entity.AppUser;
import com.example.school_management.entity.FeeInvoice;
import com.example.school_management.entity.NotificationLog;
import com.example.school_management.repository.FeeInvoiceRepository;
import com.example.school_management.repository.FeePaymentRepository;
import com.example.school_management.repository.NotificationLogRepository;
import com.example.school_management.repository.ParentStudentLinkRepository;
import com.example.school_management.repository.StudentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDate;
import java.util.HexFormat;
import java.util.List;

@Service
public class SchoolNotificationService {
    private static final Logger log = LoggerFactory.getLogger(SchoolNotificationService.class);

    private final JavaMailSender mailSender;
    private final ParentStudentLinkRepository linkRepository;
    private final StudentRepository studentRepository;
    private final FeeInvoiceRepository invoiceRepository;
    private final FeePaymentRepository paymentRepository;
    private final NotificationLogRepository notificationLogRepository;

    @Value("${spring.mail.username:}")
    private String senderEmail;

    public SchoolNotificationService(JavaMailSender mailSender,
                                     ParentStudentLinkRepository linkRepository,
                                     StudentRepository studentRepository,
                                     FeeInvoiceRepository invoiceRepository,
                                     FeePaymentRepository paymentRepository,
                                     NotificationLogRepository notificationLogRepository) {
        this.mailSender = mailSender;
        this.linkRepository = linkRepository;
        this.studentRepository = studentRepository;
        this.invoiceRepository = invoiceRepository;
        this.paymentRepository = paymentRepository;
        this.notificationLogRepository = notificationLogRepository;
    }

    @Transactional
    public void notifyParentsOfAbsences(List<AttendanceRequest.AttendanceEntry> entries, LocalDate date) {
        if (entries == null || date == null) return;
        for (AttendanceRequest.AttendanceEntry entry : entries) {
            if (entry == null || entry.getStudentId() == null || !"Absent".equalsIgnoreCase(entry.getStatus())) continue;
            var student = studentRepository.findById(entry.getStudentId()).orElse(null);
            if (student == null) continue;
            for (AppUser parent : linkRepository.findParentsForStudent(student.getId())) {
                send("ATTENDANCE_ABSENT", student.getId() + ":" + date + ":" + parent.getUsername(),
                        parent.getUsername(), "Student absent: " + student.getName(),
                        "Hello " + parent.getDisplayName() + ",\n\n" + student.getName()
                                + " was marked absent on " + date + ".\n\nStudentSys");
            }
        }
    }

    @Scheduled(cron = "0 0 9 * * *", zone = "${school.time-zone:Asia/Kolkata}")
    @Transactional
    public void notifyParentsOfOverdueFees() {
        LocalDate today = LocalDate.now();
        for (FeeInvoice invoice : invoiceRepository.findByDueDateBefore(today)) {
            BigDecimal paid = paymentRepository.sumPaidForInvoice(invoice.getId());
            BigDecimal balance = invoice.getTotalAmount().subtract(paid);
            if (balance.signum() <= 0) continue;
            var student = invoice.getStudent();
            for (AppUser parent : linkRepository.findParentsForStudent(student.getId())) {
                send("FEE_OVERDUE", invoice.getId() + ":" + parent.getUsername(), parent.getUsername(),
                        "Overdue school fee for " + student.getName(),
                        "Hello " + parent.getDisplayName() + ",\n\nFee invoice '" + invoice.getTitle()
                                + "' for " + student.getName() + " is overdue. Balance: ₹" + balance
                                + ". Due date: " + invoice.getDueDate()
                                + ".\n\nPlease contact the school office to arrange payment.\n\nStudentSys");
            }
        }
    }

    private void send(String type, String sourceKey, String to, String subject, String body) {
        if (senderEmail == null || senderEmail.isBlank() || to == null || to.isBlank()) {
            log.info("Skipping {} notification because mail sender/recipient is not configured", type);
            return;
        }
        String eventKey = hash(type + ":" + sourceKey);
        if (notificationLogRepository.existsByEventKey(eventKey)) return;
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(senderEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(body);
            mailSender.send(message);
            notificationLogRepository.save(new NotificationLog(eventKey));
        } catch (MailException ex) {
            log.warn("Could not send {} notification to {}: {}", type, to, ex.getMessage());
        }
    }

    private String hash(String value) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256")
                    .digest(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to create notification key", ex);
        }
    }
}
