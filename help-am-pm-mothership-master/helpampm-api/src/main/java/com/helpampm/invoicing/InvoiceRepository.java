/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author kuldeep
 */
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    Invoice findByUniqueId(String invoiceUniqueId);
}
