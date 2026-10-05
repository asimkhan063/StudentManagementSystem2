package com.example.school_management.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "gateway_payment_orders", uniqueConstraints = {
        @UniqueConstraint(name = "uk_gateway_order_id", columnNames = "gateway_order_id"),
        @UniqueConstraint(name = "uk_gateway_payment_id", columnNames = "gateway_payment_id")
})
public class GatewayPaymentOrder {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(fetch = FetchType.LAZY, optional = false) @JoinColumn(name = "invoice_id", nullable = false) private FeeInvoice invoice;
    @Column(name = "gateway_order_id", nullable = false, length = 64) private String gatewayOrderId;
    @Column(name = "gateway_payment_id", length = 64) private String gatewayPaymentId;
    @Column(nullable = false, precision = 12, scale = 2) private BigDecimal amount;
    @Column(nullable = false, length = 20) private String status;
    @Column(nullable = false, length = 190) private String parentUsername;
    @Column(nullable = false, updatable = false) private Instant createdAt;
    protected GatewayPaymentOrder() { }
    public GatewayPaymentOrder(FeeInvoice invoice, String gatewayOrderId, BigDecimal amount, String parentUsername) {
        this.invoice = invoice; this.gatewayOrderId = gatewayOrderId; this.amount = amount;
        this.parentUsername = parentUsername; this.status = "PENDING"; this.createdAt = Instant.now();
    }
    public Long getId() { return id; }
    public FeeInvoice getInvoice() { return invoice; }
    public String getGatewayOrderId() { return gatewayOrderId; }
    public String getGatewayPaymentId() { return gatewayPaymentId; }
    public BigDecimal getAmount() { return amount; }
    public String getStatus() { return status; }
    public String getParentUsername() { return parentUsername; }
    public void markPaid(String paymentId) { this.gatewayPaymentId = paymentId; this.status = "PAID"; }
}
