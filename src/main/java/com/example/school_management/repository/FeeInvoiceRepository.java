package com.example.school_management.repository;

import com.example.school_management.entity.FeeInvoice;
import jakarta.persistence.LockModeType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Optional;

public interface FeeInvoiceRepository extends JpaRepository<FeeInvoice, Long> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select invoice from FeeInvoice invoice where invoice.id = :id")
    Optional<FeeInvoice> findByIdForUpdate(@Param("id") Long id);

    Page<FeeInvoice> findAllByOrderByDueDateAsc(Pageable pageable);

    java.util.List<FeeInvoice> findAllByStudent_IdOrderByDueDateAsc(Long studentId);

    java.util.List<FeeInvoice> findByDueDateBefore(java.time.LocalDate date);
}
