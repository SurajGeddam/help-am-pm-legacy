/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import java.util.Map;

/**
 * @author kuldeep
 */
public interface InvoiceDataMapperService {
    Map<String, Object> invoiceMapper(Invoice invoice);
}
