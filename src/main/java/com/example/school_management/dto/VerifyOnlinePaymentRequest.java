package com.example.school_management.dto;

import jakarta.validation.constraints.NotBlank;

public record VerifyOnlinePaymentRequest(@NotBlank String razorpayOrderId,
                                         @NotBlank String razorpayPaymentId,
                                         @NotBlank String razorpaySignature) { }
