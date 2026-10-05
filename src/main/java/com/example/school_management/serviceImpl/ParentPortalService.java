package com.example.school_management.serviceImpl;

import com.example.school_management.dto.LinkParentRequest;
import com.example.school_management.dto.ParentLinkResponse;
import com.example.school_management.dto.ParentStudentResponse;
import com.example.school_management.academics.service.AcademicService;
import com.example.school_management.entity.AppUser;
import com.example.school_management.entity.ParentStudentLink;
import com.example.school_management.TeacherFeatures.repository.StudentAttendanceRepository;
import com.example.school_management.repository.AppUserRepository;
import com.example.school_management.repository.FeeInvoiceRepository;
import com.example.school_management.repository.FeePaymentRepository;
import com.example.school_management.repository.ParentStudentLinkRepository;
import com.example.school_management.repository.StudentRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;

@Service
public class ParentPortalService {

    private final AppUserRepository userRepository;
    private final StudentRepository studentRepository;
    private final ParentStudentLinkRepository linkRepository;
    private final StudentAttendanceRepository attendanceRepository;
    private final FeeInvoiceRepository invoiceRepository;
    private final FeePaymentRepository paymentRepository;
    private final AcademicService academicService;

    public ParentPortalService(AppUserRepository userRepository,
                               StudentRepository studentRepository,
                               ParentStudentLinkRepository linkRepository,
                               StudentAttendanceRepository attendanceRepository,
                               FeeInvoiceRepository invoiceRepository,
                               FeePaymentRepository paymentRepository,
                               AcademicService academicService) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.linkRepository = linkRepository;
        this.attendanceRepository = attendanceRepository;
        this.invoiceRepository = invoiceRepository;
        this.paymentRepository = paymentRepository;
        this.academicService = academicService;
    }

    @Transactional
    public ParentLinkResponse linkStudent(LinkParentRequest request) {
        String email = request.parentEmail().trim().toLowerCase();
        AppUser parent = userRepository.findByUsername(email);
        if (parent == null || !"PARENT".equalsIgnoreCase(parent.getRole())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Create a parent account before linking a student");
        }
        var student = studentRepository.findById(request.studentId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Student not found"));
        if (linkRepository.existsByParentIdAndStudentId(parent.getId(), student.getId())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This parent is already linked to the student");
        }
        ParentStudentLink link = linkRepository.save(new ParentStudentLink(parent, student));
        return toLinkResponse(link);
    }

    @Transactional(readOnly = true)
    public List<ParentLinkResponse> getAllLinks() {
        return linkRepository.findAllWithParentAndStudent().stream().map(this::toLinkResponse).toList();
    }

    @Transactional(readOnly = true)
    public List<ParentStudentResponse> getChildren(String parentEmail) {
        return linkRepository.findChildrenForParent(parentEmail).stream()
                .map(link -> {
                    var student = link.getStudent();
                    var attendance = attendanceRepository.findByStudentIdOrderByDateDesc(student.getId()).stream()
                            .limit(20)
                            .map(row -> new com.example.school_management.dto.ParentAttendanceResponse(
                                    row.getDate(), row.getStatus(), row.getGrade(), row.getSection()))
                            .toList();
                    var invoices = invoiceRepository.findAllByStudent_IdOrderByDueDateAsc(student.getId()).stream()
                            .map(invoice -> {
                                var paid = paymentRepository.sumPaidForInvoice(invoice.getId());
                                var balance = invoice.getTotalAmount().subtract(paid);
                                var status = balance.signum() == 0 ? "PAID"
                                        : invoice.getDueDate().isBefore(java.time.LocalDate.now()) ? "OVERDUE"
                                        : paid.signum() == 0 ? "UNPAID" : "PARTIAL";
                                return new com.example.school_management.dto.ParentFeeInvoiceResponse(
                                        invoice.getId(), invoice.getTitle(), invoice.getTotalAmount(), paid,
                                        balance, invoice.getDueDate(), status);
                            })
                            .toList();
                    return new ParentStudentResponse(student.getId(), student.getName(), student.getRollNo(),
                            student.getGrade(), student.getSection(), attendance, invoices,
                            academicService.reportCard(student.getId()));
                })
                .toList();
    }

    private ParentLinkResponse toLinkResponse(ParentStudentLink link) {
        var student = link.getStudent();
        return new ParentLinkResponse(link.getId(), link.getParent().getUsername(), link.getParent().getDisplayName(),
                student.getId(), student.getName(), student.getRollNo(), student.getGrade(), student.getSection());
    }
}
