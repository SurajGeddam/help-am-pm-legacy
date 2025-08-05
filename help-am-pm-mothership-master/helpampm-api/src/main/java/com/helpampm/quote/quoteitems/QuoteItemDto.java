/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteitems;

import com.helpampm.common.CommonUtils;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder(setterPrefix = "with")
public class QuoteItemDto implements Serializable {
    private Long quoteItemId;
    private String description;
    private Double itemPrice;

    public static QuoteItemDto buildFromQuoteItem(QuoteItem quoteItem) {
        return QuoteItemDto.builder().withQuoteItemId(quoteItem.getId())
                .withDescription(quoteItem.getDescription())
                .withItemPrice(CommonUtils.formatDouble(quoteItem.getPrice()))
                .build();
    }


}
