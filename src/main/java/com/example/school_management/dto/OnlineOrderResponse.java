package com.example.school_management.dto;

public record OnlineOrderResponse(Long invoiceId, String keyId, String orderId, long amount, String currency,
                                  String schoolName, String invoiceTitle, String studentName) { }
