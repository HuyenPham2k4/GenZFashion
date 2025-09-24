package com.example.GenZFashion.dto.dashboard;

public record OrdersCountByPaymentDTO(Long paymentMethodId, String paymentMethodName, Long count) {
}
