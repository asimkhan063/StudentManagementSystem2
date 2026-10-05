package com.example.school_management.controller;

import com.example.school_management.dto.CreateFeeInvoiceRequest;
import com.example.school_management.dto.FeeInvoiceResponse;
import com.example.school_management.dto.RecordFeePaymentRequest;
import com.example.school_management.serviceImpl.FeeManagementService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/fees")
public class FeeManagementController {

    private final FeeManagementService feeManagementService;

    public FeeManagementController(FeeManagementService feeManagementService) {
        this.feeManagementService = feeManagementService;
    }

    @PostMapping("/invoices")
    public FeeInvoiceResponse createInvoice(@Valid @RequestBody CreateFeeInvoiceRequest request) {
        return feeManagementService.createInvoice(request);
    }

    @GetMapping("/invoices")
    public Page<FeeInvoiceResponse> getInvoices(@PageableDefault(size = 20) Pageable pageable) {
        return feeManagementService.getInvoices(pageable);
    }

    @PostMapping("/invoices/{invoiceId}/payments")
    public FeeInvoiceResponse recordPayment(@PathVariable Long invoiceId,
                                           @Valid @RequestBody RecordFeePaymentRequest request) {
        return feeManagementService.recordPayment(invoiceId, request);
    }
}
