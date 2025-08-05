/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.card;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * @author kuldeep
 */
@Data
@AllArgsConstructor
public class CardDeleteResponse {
    private String message;
    private int status;
}
