/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.customer.Customer;
import com.helpampm.quote.dto.*;
import com.helpampm.quote.quoteitems.QuoteItem;

import java.time.LocalTime;

/**
 * @author kuldeep
 */
public interface QuoteService {
    Quote create(QuoteDTO quoteDTO, Customer customer);

    Quote cancelQuote(String orderUniqueId);

    Quote confirmQuote(String orderUniqueId, String providerUniqueId, LocalTime eta);

    QuoteItemResponse addQuoteItem(String quoteUniqueId, String providerUniqueId, QuoteItem quoteItem);

    QuoteItemResponse removeQuoteItem(String quoteUniqueId, String providerUniqueId, long itemId);

    CompleteQuoteResponse completeOrder(String quoteUniqueId, String providerUniqueId);

    StartWorkResponse startWork(String quoteUniqueId, String providerUniqueId, StartWorkPayload startWorkPayload);
    void handleSendNewOrderNotification(Customer customer,
                                               Quote quote,
                                               boolean isScheduledOrder);
}
