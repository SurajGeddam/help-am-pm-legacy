/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments;

/**
 * @author kuldeep
 */
public class PaymentException extends RuntimeException {
    public PaymentException(String message) {
        super(message);
    }

    public PaymentException(String message, Throwable throwable) {
        super(message, throwable);
    }
}
