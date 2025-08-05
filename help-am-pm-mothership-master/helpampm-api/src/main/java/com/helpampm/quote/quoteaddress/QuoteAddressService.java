/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteaddress;

/**
 * @author kuldeep
 */
public interface QuoteAddressService {
    QuoteAddress save(QuoteAddress address);

    QuoteAddress update(QuoteAddress address);

    QuoteAddress findById(Long id);
}
