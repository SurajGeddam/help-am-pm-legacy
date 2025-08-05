/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.quote.dto;

import com.helpampm.common.CommonUtils;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteHelper;
import com.helpampm.quote.quoteitems.QuoteItem;
import lombok.Builder;
import lombok.Data;

import java.util.Objects;

/**
 * @author kuldeep
 */
@Data
@Builder(setterPrefix = "with")
public class QuoteItemResponse {
    private Long quoteItemId;
    private String description;
    private Double itemPrice;
    private Double taxAmount;
    private Double totalQuotePrice;

    public static QuoteItemResponse buildFromQuote(Quote quote, QuoteItem quoteItem) {
        double grossBill = QuoteHelper.calculateGrossTotal(quote.getItems(), quote.getServiceCharge());
        double tax = (grossBill * quote.getTax().getTaxRate()) / 100;
        return QuoteItemResponse.builder()
                .withQuoteItemId(Objects.nonNull(quoteItem) ? quoteItem.getId() : -1) // Its database id, considering it will not be negative and set it to avoid null values on frontend.
                .withDescription(Objects.nonNull(quoteItem) ? quoteItem.getDescription() : "")
                .withItemPrice(Objects.nonNull(quoteItem) ? CommonUtils.formatDouble(quoteItem.getPrice()) : 0.00)
                .withTaxAmount(CommonUtils.formatDouble(tax))
                .withTotalQuotePrice(CommonUtils.formatDouble(grossBill + tax))
                .build();
    }
}
