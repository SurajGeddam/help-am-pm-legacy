/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.tax;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_tax_info")
@Data
/*
  @author kuldeep
 */
public class Tax {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "tax_country")
    private String taxCounty;
    @Column(name = "tax_rate")
    private Double taxRate;
    @Column(name = "tax_name")
    private String taxName;
    // Example: 2022-2023
    @Column(name = "tax_period")
    private String taxPeriod;
    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(taxCounty) || Objects.equals("", taxCounty.trim())) {
            throw new TaxException("County can not be null or empty");
        }

        if (Objects.isNull(taxRate)) {
            throw new TaxException("Tax rate can not be null");
        }

        if (Objects.isNull(taxPeriod) || Objects.equals("", taxPeriod.trim())) {
            throw new TaxException("Tax period can not be null or empty: example- 2022-2023");
        }

        if (Objects.isNull(taxName) || Objects.equals("", taxName.trim())) {
            throw new TaxException("Tax name can not be null or empty");
        }
    }

    public void copyNonNullValues(Tax tax) {
        if (Objects.isNull(tax.getTaxPeriod())) {
            tax.setTaxPeriod(taxPeriod);
        }
        if (Objects.isNull(tax.getTaxRate())) {
            tax.setTaxRate(taxRate);
        }
        if (Objects.isNull(tax.getTaxCounty())) {
            tax.setTaxCounty(taxCounty);
        }
        if (Objects.isNull(tax.getTaxName())) {
            tax.setTaxName(taxName);
        }
        if (Objects.isNull(tax.getCreatedAt())) {
            tax.setCreatedAt(createdAt);
        }
        if (Objects.isNull(tax.getIsActive())) {
            tax.setIsActive(isActive);
        }
    }
}
