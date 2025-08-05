/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_pricing")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Pricing implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "type")
    @Enumerated(EnumType.STRING)
    private PricingType type;

    @Column(name = "residential_price")
    private Double residentialPrice;

    @Column(name = "commercial_price")
    private Double commercialPrice;

    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "currency")
    @Enumerated(EnumType.STRING)
    private Currency currency;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(type)) {
            throw new PricingException("Type can not be null");
        }
        if (Objects.isNull(currency)) {
            throw new PricingException("Currency can not be null");
        }
    }

    public void copyNonNullValues(Pricing pricing) {
        if (Objects.isNull(pricing.getCommercialPrice())) {
            pricing.setCommercialPrice(commercialPrice);
        }
        if (Objects.isNull(pricing.getResidentialPrice())) {
            pricing.setResidentialPrice(residentialPrice);
        }
        if (Objects.isNull(pricing.getType())) {
            pricing.setType(type);
        }
        if (Objects.isNull(pricing.getCurrency())) {
            pricing.setCurrency(currency);
        }
        if (Objects.isNull(pricing.getCreatedAt())) {
            pricing.setCreatedAt(createdAt);
        }
    }
}
