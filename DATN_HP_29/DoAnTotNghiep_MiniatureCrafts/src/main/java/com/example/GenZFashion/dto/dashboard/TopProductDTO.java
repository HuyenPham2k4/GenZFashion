package com.example.GenZFashion.dto.dashboard;

import java.math.BigDecimal;

public record TopProductDTO(
        Long variationId,
        String variationName,
        Long totalSold,
        BigDecimal totalRevenue) {
}
