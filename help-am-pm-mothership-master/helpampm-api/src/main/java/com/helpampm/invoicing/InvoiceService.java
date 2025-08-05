/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.quote.Quote;

import java.io.IOException;

/**
 * @author kuldeep
 */
public interface InvoiceService {
    Invoice create(Quote quote);

    Invoice update(Invoice invoice);

    Invoice findByInvoiceUniqueId(String invoiceUniqueId);

    byte[] generateInvoicePdf(String invoiceUniqueId) throws IOException;

}
