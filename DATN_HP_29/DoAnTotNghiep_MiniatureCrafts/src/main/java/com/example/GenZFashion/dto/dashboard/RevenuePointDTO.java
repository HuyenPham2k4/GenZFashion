package com.example.GenZFashion.dto.dashboard;


import java.math.BigDecimal;
import java.time.LocalDate;

public record RevenuePointDTO(LocalDate day, BigDecimal revenue) {}