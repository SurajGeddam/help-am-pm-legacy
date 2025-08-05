/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import lombok.Data;

import javax.persistence.*;

@Entity
@Table(name = "tb_invoice_payment")
@Data
/*
  @author kuldeep
 */
public class InvoicePayment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;


    public void validate() {
        //TODO:
    }

    public void copyNonNullValues(InvoiceItem item) {
        //TODO:
    }
}
