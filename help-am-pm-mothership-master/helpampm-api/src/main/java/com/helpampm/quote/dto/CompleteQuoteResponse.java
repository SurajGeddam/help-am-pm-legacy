/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class CompleteQuoteResponse {
    private String message;
}
