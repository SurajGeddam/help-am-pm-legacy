/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

/**
 * @author kuldeep
 */
public class QuoteException extends RuntimeException {
    private final String message;
    private final int status;

    public QuoteException(String message, int status) {
        super(message);
        this.message = message;
        this.status = status;
    }

    @Override
    public String getMessage() {
        return message;
    }

    public int getStatus() {
        return status;
    }
}
