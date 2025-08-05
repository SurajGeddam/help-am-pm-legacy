/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.dashboard.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * @author kuldeep
 */
@Data
@AllArgsConstructor
public class SaleDataByCategory {
    private double total;
    private int month;
    private String categoryName;
}
