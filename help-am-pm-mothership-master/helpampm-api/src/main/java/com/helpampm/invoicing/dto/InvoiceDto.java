/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing.dto;

import com.helpampm.invoicing.*;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Set;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class InvoiceDto {
    private Long id;

    private String uniqueId;
    private String currency;
    private Double totalDiscount;
    private Double totalPrice;

    private InvoiceCustomer customer;
    private InvoicePayment payment;
    private InvoiceTax tax;
    private Set<InvoiceItem> items;

    private LocalDateTime paidAt;
    private LocalDateTime createdAt;
    private String invoicePath;

    private Double subTotal;

    public static InvoiceDto buildWithInvoice(Invoice invoice) {
        return InvoiceDto.builder()
                .withUniqueId(invoice.getUniqueId())
                .withId(invoice.getId())
                .withInvoicePath(invoice.getInvoicePath())
                .withCustomer(invoice.getCustomer())
                .withItems(invoice.getItems())
                .withCurrency(invoice.getCurrency())
                .withPayment(invoice.getPayment())
                .withTax(invoice.getTax())
                .withCreatedAt(invoice.getCreatedAt())
                .withTotalPrice(invoice.getTotalPrice())
                .withPaidAt(invoice.getPaidAt())
                .withSubTotal(invoice.getItems().stream().mapToDouble(InvoiceItem::getPrice).sum())
                .withTotalDiscount(invoice.getTotalDiscount())
                .build();
    }

}
