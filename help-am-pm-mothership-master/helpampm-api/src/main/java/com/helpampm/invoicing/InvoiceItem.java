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
@Table(name = "tb_invoice_items")
/*
  @author kuldeep
 */
public class InvoiceItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "description")
    private String description;
    @Column(name = "price")
    private Double price;

    public void validate() {
        if (StringUtils.isNullOrEmpty(description)) {
            throw new InvoiceException("Invoice Item description can't be null or empty.");
        }
        if (Objects.isNull(price)) {
            throw new InvoiceException("Invoice Item price can't be null.");
        }
    }

    public void copyNonNullValues(InvoiceItem item) {
        if (StringUtils.isNullOrEmpty(item.getDescription())) {
            item.setDescription(description);
        }
        if (Objects.isNull(item.getPrice())) {
            item.setPrice(price);
        }
    }

    public Map<String, Object> toMap() {
        return Map.of("description", getDescription(),
                "price", getPrice());
    }
}
