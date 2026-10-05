package com.example.school_management.repository;

import com.example.school_management.entity.GatewayPaymentOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface GatewayPaymentOrderRepository extends JpaRepository<GatewayPaymentOrder, Long> {
    Optional<GatewayPaymentOrder> findByGatewayOrderId(String gatewayOrderId);
}
