package com.example.school_management.serviceImpl;

import com.example.school_management.dto.FeeInvoiceResponse;
import com.example.school_management.dto.OnlineOrderResponse;
import com.example.school_management.dto.VerifyOnlinePaymentRequest;
import com.example.school_management.entity.FeePayment;
import com.example.school_management.entity.GatewayPaymentOrder;
import com.example.school_management.repository.FeeInvoiceRepository;
import com.example.school_management.repository.FeePaymentRepository;
import com.example.school_management.repository.GatewayPaymentOrderRepository;
import com.example.school_management.repository.ParentStudentLinkRepository;
import com.razorpay.Order;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.UUID;

@Service
public class RazorpayPaymentService {
    private final FeeInvoiceRepository invoiceRepository;
    private final FeePaymentRepository paymentRepository;
    private final GatewayPaymentOrderRepository gatewayOrderRepository;
    private final ParentStudentLinkRepository parentLinkRepository;

    @Value("${razorpay.key-id:}") private String keyId;
    @Value("${razorpay.key-secret:}") private String keySecret;

    public RazorpayPaymentService(FeeInvoiceRepository invoiceRepository,
                                  FeePaymentRepository paymentRepository,
                                  GatewayPaymentOrderRepository gatewayOrderRepository,
                                  ParentStudentLinkRepository parentLinkRepository) {
        this.invoiceRepository = invoiceRepository; this.paymentRepository = paymentRepository;
        this.gatewayOrderRepository = gatewayOrderRepository; this.parentLinkRepository = parentLinkRepository;
    }

    @Transactional
    public OnlineOrderResponse createOrder(Long invoiceId, String parentUsername) {
        var invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found"));
        if (!parentLinkRepository.isParentLinkedToStudent(parentUsername, invoice.getStudent().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "This fee invoice is not linked to your parent account");
        }
        var paid = paymentRepository.sumPaidForInvoice(invoiceId);
        var balance = invoice.getTotalAmount().subtract(paid);
        if (balance.signum() <= 0) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "This invoice is already paid");
        ensureConfigured();
        long amountPaise;
        try {
            amountPaise = balance.movePointRight(2).setScale(0, RoundingMode.UNNECESSARY).longValueExact();
        } catch (ArithmeticException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invoice amount cannot be represented in paise");
        }
        try {
            String receipt = "fee-" + invoiceId + "-" + UUID.randomUUID().toString().substring(0, 8);
            JSONObject body = new JSONObject();
            body.put("amount", amountPaise);
            body.put("currency", "INR");
            body.put("receipt", receipt);
            JSONObject notes = new JSONObject();
            notes.put("invoice_id", invoiceId.toString());
            notes.put("parent_username", parentUsername);
            body.put("notes", notes);
            Order order = client().orders.create(body);
            String orderId = order.get("id");
            gatewayOrderRepository.save(new GatewayPaymentOrder(invoice, orderId, balance, parentUsername));
            return new OnlineOrderResponse(invoiceId, keyId, orderId, amountPaise, "INR",
                    "StudentSys", invoice.getTitle(), invoice.getStudent().getName());
        } catch (RazorpayException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY, "Could not create a Razorpay order", ex);
        }
    }

    @Transactional
    public FeeInvoiceResponse verifyAndRecord(VerifyOnlinePaymentRequest request, String parentUsername) {
        ensureConfigured();
        GatewayPaymentOrder gatewayOrder = gatewayOrderRepository.findByGatewayOrderId(request.razorpayOrderId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Payment order not found"));
        if (!gatewayOrder.getParentUsername().equalsIgnoreCase(parentUsername)
                || !parentLinkRepository.isParentLinkedToStudent(parentUsername, gatewayOrder.getInvoice().getStudent().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Payment order is not linked to your parent account");
        }
        if ("PAID".equals(gatewayOrder.getStatus())) {
            if (request.razorpayPaymentId().equals(gatewayOrder.getGatewayPaymentId())) return invoiceResponse(gatewayOrder);
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This order has already been paid");
        }
        try {
            JSONObject signatureData = new JSONObject();
            signatureData.put("razorpay_order_id", gatewayOrder.getGatewayOrderId());
            signatureData.put("razorpay_payment_id", request.razorpayPaymentId());
            signatureData.put("razorpay_signature", request.razorpaySignature());
            if (!Utils.verifyPaymentSignature(signatureData, keySecret)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Payment signature is invalid");
            }
            Payment payment = client().payments.fetch(request.razorpayPaymentId());
            if (!gatewayOrder.getGatewayOrderId().equals(payment.get("order_id"))
                    || !"captured".equalsIgnoreCase(payment.get("status"))) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Payment is not captured for this order");
            }
            long expectedPaise = gatewayOrder.getAmount().movePointRight(2).longValueExact();
            Object actual = payment.get("amount");
            long actualPaise = actual instanceof Number n ? n.longValue() : Long.parseLong(String.valueOf(actual));
            if (actualPaise != expectedPaise) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Captured amount does not match the invoice balance");

            var invoice = invoiceRepository.findByIdForUpdate(gatewayOrder.getInvoice().getId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Invoice not found"));
            BigDecimal remaining = invoice.getTotalAmount().subtract(paymentRepository.sumPaidForInvoice(invoice.getId()));
            if (gatewayOrder.getAmount().compareTo(remaining) > 0) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "Invoice balance changed; contact the school office");
            }
            paymentRepository.save(new FeePayment(invoice, gatewayOrder.getAmount(), "RAZORPAY", request.razorpayPaymentId()));
            gatewayOrder.markPaid(request.razorpayPaymentId());
            gatewayOrderRepository.save(gatewayOrder);
            BigDecimal balance = remaining.subtract(gatewayOrder.getAmount());
            BigDecimal paid = invoice.getTotalAmount().subtract(balance);
            String status = balance.signum() == 0 ? "PAID" : paid.signum() == 0 ? "UNPAID" : "PARTIAL";
            return new FeeInvoiceResponse(invoice.getId(), invoice.getStudent().getId(), invoice.getStudent().getName(),
                    invoice.getStudent().getRollNo(), invoice.getTitle(), invoice.getTotalAmount(), paid,
                    balance, invoice.getDueDate(), status);
        } catch (RazorpayException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY, "Could not verify payment with Razorpay", ex);
        }
    }

    private FeeInvoiceResponse invoiceResponse(GatewayPaymentOrder gatewayOrder) {
        var invoice = gatewayOrder.getInvoice();
        BigDecimal paid = paymentRepository.sumPaidForInvoice(invoice.getId());
        BigDecimal balance = invoice.getTotalAmount().subtract(paid);
        String status = balance.signum() == 0 ? "PAID" : paid.signum() == 0 ? "UNPAID" : "PARTIAL";
        return new FeeInvoiceResponse(invoice.getId(), invoice.getStudent().getId(), invoice.getStudent().getName(),
                invoice.getStudent().getRollNo(), invoice.getTitle(), invoice.getTotalAmount(), paid,
                balance, invoice.getDueDate(), status);
    }

    private RazorpayClient client() throws RazorpayException { return new RazorpayClient(keyId, keySecret); }

    private void ensureConfigured() {
        if (keyId == null || keyId.isBlank() || keySecret == null || keySecret.isBlank()) {
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE, "Online payments are not configured yet");
        }
    }
}
