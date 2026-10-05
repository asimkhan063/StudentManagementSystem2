package com.example.school_management.serviceImpl;

import com.example.school_management.dto.CreateFeeInvoiceRequest;
import com.example.school_management.dto.FeeInvoiceResponse;
import com.example.school_management.dto.RecordFeePaymentRequest;
import com.example.school_management.entity.FeeInvoice;
import com.example.school_management.entity.FeePayment;
import com.example.school_management.repository.FeeInvoiceRepository;
import com.example.school_management.repository.FeePaymentRepository;
import com.example.school_management.repository.StudentRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import java.math.BigDecimal;

@Service
public class FeeManagementService {

    private final FeeInvoiceRepository invoiceRepository;
    private final FeePaymentRepository paymentRepository;
    private final StudentRepository studentRepository;

    public FeeManagementService(FeeInvoiceRepository invoiceRepository,
                               FeePaymentRepository paymentRepository,
                               StudentRepository studentRepository) {
        this.invoiceRepository = invoiceRepository;
        this.paymentRepository = paymentRepository;
        this.studentRepository = studentRepository;
    }

    @Transactional
    public FeeInvoiceResponse createInvoice(CreateFeeInvoiceRequest request) {
        var student = studentRepository.findById(request.studentId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Student not found"));
        FeeInvoice invoice = invoiceRepository.save(new FeeInvoice(
                student, request.title().trim(), request.totalAmount(), request.dueDate()));
        return toResponse(invoice);
    }

    @Transactional(readOnly = true)
    public Page<FeeInvoiceResponse> getInvoices(Pageable pageable) {
        return invoiceRepository.findAllByOrderByDueDateAsc(pageable).map(this::toResponse);
    }

    @Transactional
    public FeeInvoiceResponse recordPayment(Long invoiceId, RecordFeePaymentRequest request) {
        FeeInvoice invoice = invoiceRepository.findByIdForUpdate(invoiceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found"));

        BigDecimal alreadyPaid = paymentRepository.sumPaidForInvoice(invoiceId);
        BigDecimal newTotal = alreadyPaid.add(request.amount());
        if (newTotal.compareTo(invoice.getTotalAmount()) > 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Payment exceeds the remaining balance");
        }

        paymentRepository.save(new FeePayment(invoice, request.amount(),
                request.paymentMethod().name(), cleanReference(request.receiptReference())));
        return toResponse(invoice);
    }

    private FeeInvoiceResponse toResponse(FeeInvoice invoice) {
        BigDecimal paid = paymentRepository.sumPaidForInvoice(invoice.getId());
        BigDecimal balance = invoice.getTotalAmount().subtract(paid);
        String status = balance.signum() == 0 ? "PAID" : paid.signum() == 0 ? "UNPAID" : "PARTIAL";
        return new FeeInvoiceResponse(invoice.getId(), invoice.getStudent().getId(),
                invoice.getStudent().getName(), invoice.getStudent().getRollNo(), invoice.getTitle(),
                invoice.getTotalAmount(), paid, balance, invoice.getDueDate(), status);
    }

    private String cleanReference(String reference) {
        return reference == null || reference.isBlank() ? null : reference.trim();
    }
}
