/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

/**
 * @author kuldeep
 */
public class UnauthorizedException extends RuntimeException {
    public UnauthorizedException(String message) {
        super(message);
    }
}
