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

@Data
@Entity
@Table(name = "tb_invoice_customers")
/*
  @author kuldeep
 */
public class InvoiceCustomer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name")
    private String name;
    @Column(name = "phone")
    private String phone;
    @Column(name = "email")
    private String email;
    @Column(name = "address")
    private String address;

    public void validate() {
        if (StringUtils.isNullOrEmpty(name)) {
            throw new InvoiceException("Invoice Customer name can't be null or empty");
        }
        if (StringUtils.isNullOrEmpty(phone)) {
            throw new InvoiceException("Invoice Customer phone can't be null or empty");
        }
    }

    public void copyNonNullValues(InvoiceCustomer customer) {
        if (StringUtils.isNullOrEmpty(customer.getName())) {
            customer.setName(name);
        }
        if (StringUtils.isNullOrEmpty(customer.getPhone())) {
            customer.setPhone(phone);
        }
        if (StringUtils.isNullOrEmpty(customer.getEmail())) {
            customer.setEmail(email);
        }
        if (StringUtils.isNullOrEmpty(customer.getAddress())) {
            customer.setAddress(address);
        }
    }

    public Map<String, String> toMap() {
        return Map.of(
                "name", getName(),
                "email", getEmail(),
                "phone", getPhone(),
                "addressLine1", getAddress()
        );
    }
}
