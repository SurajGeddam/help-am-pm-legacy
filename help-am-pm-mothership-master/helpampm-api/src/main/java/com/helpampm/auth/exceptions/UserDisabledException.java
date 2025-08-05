/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.exceptions;

/**
 * @author kuldeep
 */
public class UserDisabledException extends RuntimeException {
    public UserDisabledException(String message) {
        super(message);
    }
}
