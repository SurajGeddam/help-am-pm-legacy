/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.commission;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_commission")
@Data
/*
  @author kuldeep
 */
public class Commission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "county")
    private String county;
    @Column(name = "rate")
    private Double rate;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    @Column(name = "stripe_fixed_amount")
    private double stripeFixedAmount;
    @Column(name = "stripe_percent_amount")
    private double stripePercentAmount;


    public void updateNullValues(Commission commission) {
        if(Objects.nonNull(commission.getRate())) {
            this.setRate(commission.getRate());
        }
        if(Objects.nonNull(commission.getCounty())) {
            this.setCounty(commission.getCounty());
        }
    }
}
