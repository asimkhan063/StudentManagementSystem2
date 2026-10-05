package com.example.school_management.controller;

import com.example.school_management.dto.FeeInvoiceResponse;
import com.example.school_management.dto.OnlineOrderResponse;
import com.example.school_management.dto.VerifyOnlinePaymentRequest;
import com.example.school_management.serviceImpl.RazorpayPaymentService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;

@RestController
@RequestMapping("/api/parent/payments")
public class ParentPaymentController {
    private final RazorpayPaymentService paymentService;
    public ParentPaymentController(RazorpayPaymentService paymentService) { this.paymentService = paymentService; }

    @PostMapping("/invoices/{invoiceId}/order")
    public OnlineOrderResponse createOrder(@PathVariable Long invoiceId, Principal principal) {
        return paymentService.createOrder(invoiceId, principal.getName());
    }

    @PostMapping("/verify")
    public FeeInvoiceResponse verify(@Valid @RequestBody VerifyOnlinePaymentRequest request, Principal principal) {
        return paymentService.verifyAndRecord(request, principal.getName());
    }
}
