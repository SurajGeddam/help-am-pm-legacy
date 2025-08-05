/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.payments;

import lombok.Builder;
import lombok.Data;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class PaymentResponse {
    private String transactionNumber;
    private String message;
    private int status;
}
