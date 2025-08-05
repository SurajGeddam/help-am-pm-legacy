/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteitems;

import com.helpampm.common.StringUtils;
import com.helpampm.quote.QuoteException;
import lombok.Data;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Data
@Entity
@Table(name = "tb_service_items")
/*
  @author kuldeep
 */
public class QuoteItem implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "description")
    private String description;
    @Column(name = "price")
    private double price;

    public void validate() {
        if (StringUtils.isNullOrEmpty(description)) {
            throw new QuoteException("Service Item description can't be null or empty.", HttpStatus.BAD_REQUEST.value());
        }
    }

    public void copyNonNullValues(com.helpampm.invoicing.InvoiceItem item) {
        if (StringUtils.isNullOrEmpty(item.getDescription())) {
            item.setDescription(description);
        }
        if (Objects.isNull(item.getPrice())) {
            item.setPrice(price);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        QuoteItem quoteItem = (QuoteItem) o;

        return Objects.equals(id, quoteItem.id);
    }

    @Override
    public int hashCode() {
        return getId() != null ? getId().hashCode() : 0;
    }
}
