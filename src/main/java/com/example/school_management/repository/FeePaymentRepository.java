package com.example.school_management.repository;

import com.example.school_management.entity.FeePayment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;

public interface FeePaymentRepository extends JpaRepository<FeePayment, Long> {

    @Query("select coalesce(sum(payment.amount), 0) from FeePayment payment where payment.invoice.id = :invoiceId")
    BigDecimal sumPaidForInvoice(@Param("invoiceId") Long invoiceId);
}
