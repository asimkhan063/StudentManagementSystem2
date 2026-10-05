package com.example.school_management.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "fee_payments")
public class FeePayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "invoice_id", nullable = false)
    private FeeInvoice invoice;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(name = "paid_at", nullable = false, updatable = false)
    private Instant paidAt;

    @Column(name = "payment_method", nullable = false, length = 24)
    private String paymentMethod;

    @Column(name = "receipt_reference", length = 80)
    private String receiptReference;

    protected FeePayment() { }

    public FeePayment(FeeInvoice invoice, BigDecimal amount, String paymentMethod, String receiptReference) {
        this.invoice = invoice;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.receiptReference = receiptReference;
        this.paidAt = Instant.now();
    }

    public Long getId() { return id; }
    public FeeInvoice getInvoice() { return invoice; }
    public BigDecimal getAmount() { return amount; }
    public Instant getPaidAt() { return paidAt; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getReceiptReference() { return receiptReference; }
}
