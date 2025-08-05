/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.common.StringUtils;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "tb_invoices")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "invoice_id")
    private String uniqueId;
    @Column(name = "quote_unique_id")
    private String quoteUniqueId;
    @Column(name = "currency_symbol")
    private String currency;
    @Column(name = "total_discount")
    private double totalDiscount;
    @Column(name = "total_price")
    private double totalPrice;

    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private InvoiceCustomer customer;
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private InvoicePayment payment;
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private InvoiceTax tax;
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "invoice_id")
    private Set<InvoiceItem> items;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;
    @Column(name = "create_at")
    private LocalDateTime createdAt;

    @Column(name = "invoice_path")
    private String invoicePath;

    public void validate() {
        if (StringUtils.isNullOrEmpty(uniqueId)) {
            throw new InvoiceException("InvoiceId can not be null or empty.");
        }
        if (StringUtils.isNullOrEmpty(currency)) {
            throw new InvoiceException("Currency can not be null or empty.");
        }
        if (Objects.isNull(createdAt)) {
            createdAt = LocalDateTime.now();
        }
        if (Objects.isNull(customer)) {
            throw new InvoiceException("Customer can not be null.");
        } else {
            customer.validate();
        }
        if (Objects.nonNull(payment)) {
            payment.validate();
        }
        if (Objects.isNull(items) || items.isEmpty()) {
            items = Set.of();
        } else {
            items.forEach(InvoiceItem::validate);
        }
        if (Objects.isNull(tax)) {
            throw new InvoiceException("Tax can not be null or empty.");
        } else {
            tax.validate();
        }
    }

    public void copyNonNullValues(Invoice invoice) {
        if (StringUtils.isNullOrEmpty(invoice.getUniqueId())) {
            invoice.setUniqueId(uniqueId);
        }
        if (StringUtils.isNullOrEmpty(invoice.getCurrency())) {
            invoice.setCurrency(currency);
        }
        if (Objects.isNull(invoice.getCustomer())) {
            invoice.setCustomer(customer);
        }
        if (Objects.isNull(invoice.getPayment())) {
            invoice.setPayment(payment);
        }
        if (Objects.isNull(invoice.getPaidAt())) {
            invoice.setPaidAt(paidAt);
        }
        if (Objects.isNull(invoice.getCreatedAt())) {
            invoice.setCreatedAt(createdAt);
        }
        if (Objects.isNull(invoice.getItems()) || invoice.getItems().isEmpty()) {
            invoice.setItems(items);
        }
        if (Objects.isNull(invoice.tax)) {
            invoice.setTax(tax);
        }
    }

    public void validateOnUpdate() {
        if (Objects.isNull(createdAt)) {
            createdAt = LocalDateTime.now();
        }
        if (Objects.nonNull(customer)) {
            //throw new InvoiceException("Customer can not be changed.");
        }
        if (Objects.nonNull(payment)) {
            payment.validate();
        }
        if (Objects.nonNull(items)) {
            //throw new InvoiceException("Invoice items can not be changed");
        }
        if (Objects.nonNull(tax)) {
            //throw new InvoiceException("Tax can not be changed.");
        }
    }
}
