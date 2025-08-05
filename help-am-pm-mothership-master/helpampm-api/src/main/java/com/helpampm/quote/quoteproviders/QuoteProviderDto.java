/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteproviders;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.nio.charset.StandardCharsets;

@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class QuoteProviderDto implements Serializable {
    private Long id;
    private String uniqueId;
    private String providerName;
    private byte[] providerImage;

    public static QuoteProviderDto buildWithQuoteProvider(QuoteProvider quoteProvider, byte[] image) {
        if (quoteProvider != null) {
            return QuoteProviderDto.builder()
                    .withId(quoteProvider.getId())
                    .withProviderName(quoteProvider.getProviderName())
                    .withProviderImage(image != null ? image : "".getBytes(StandardCharsets.UTF_8))
                    .withUniqueId(quoteProvider.getUniqueId()).build();
        }
        return null;
    }
}
