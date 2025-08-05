/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.common.StringUtils;
import lombok.Data;

import javax.persistence.*;
import java.util.Map;
import java.util.Objects;

@Data
@Entity
@Table(name = "tb_invoice_taxes")
/*
  @author kuldeep
 */
public class InvoiceTax {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name")
    private String name;
    @Column(name = "amount")
    private Double amount;

    public void validate() {
        if (StringUtils.isNullOrEmpty(name)) {
            throw new InvoiceException("Invoice Tax name can't be null or empty.");
        }
        if (Objects.isNull(amount)) {
            throw new InvoiceException("Invoice Tax amount can't be null.");
        }
    }

    public void copyNonNullValues(InvoiceTax taxItem) {
        if (StringUtils.isNullOrEmpty(taxItem.getName())) {
            taxItem.setName(name);
        }
        if (Objects.isNull(taxItem.getAmount())) {
            taxItem.setAmount(amount);
        }
    }

    public Map<String, Object> toMap() {
        return Map.of("name", getName(),
                "amount", getAmount());
    }
}
