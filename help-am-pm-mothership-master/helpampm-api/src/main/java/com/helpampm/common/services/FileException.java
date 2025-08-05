/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common.services;

/**
 * @author kuldeep
 */
public class FileException extends RuntimeException {
    public FileException(String message) {
        super(message);
    }

    public FileException(String message, Throwable th) {
        super(message, th);
    }
}
