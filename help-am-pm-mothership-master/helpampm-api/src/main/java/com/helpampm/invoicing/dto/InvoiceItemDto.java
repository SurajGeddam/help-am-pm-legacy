/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing.dto;

import com.helpampm.invoicing.InvoiceItem;
import lombok.Builder;
import lombok.Data;

@Builder(setterPrefix = "with")
@Data
/*
  @author kuldeep
 */
public class InvoiceItemDto {

    private String description;
    private Double price;

    public static InvoiceItemDto buildWithInvoiceItem(InvoiceItem invoiceItem) {
        return InvoiceItemDto.builder().withDescription(invoiceItem.getDescription())
                .withPrice(invoiceItem.getPrice())
                .build();
    }
}
