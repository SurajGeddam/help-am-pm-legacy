/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
/*
  @author kuldeep
 */
public class TaxDto {
    private Integer id;

    private String taxCounty;
    private Double taxRate;
    private String taxName;
    private String taxPeriod;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdatedAt;
}
