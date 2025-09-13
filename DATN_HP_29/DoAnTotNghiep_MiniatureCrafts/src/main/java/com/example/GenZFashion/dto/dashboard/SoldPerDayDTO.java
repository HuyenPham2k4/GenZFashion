package com.example.GenZFashion.dto.dashboard;

import java.time.LocalDate;

public record SoldPerDayDTO(LocalDate day, Long quantity) {}