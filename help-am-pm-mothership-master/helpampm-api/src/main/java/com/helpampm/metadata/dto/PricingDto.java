/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.dto;

import com.helpampm.metadata.pricing.Currency;
import com.helpampm.metadata.pricing.PricingType;
import com.helpampm.metadata.timeslot.Timeslot;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class PricingDto {
    private Integer id;
    private PricingType type;
    private Double residentialPrice;
    private Double commercialPrice;
    private Timeslot timeslot;
    private Boolean isActive;
    private Currency currency;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdatedAt;
}
