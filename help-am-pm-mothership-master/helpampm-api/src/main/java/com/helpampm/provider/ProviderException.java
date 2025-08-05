/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.http.HttpStatus;

/**
 * @author kuldeep
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class ProviderException extends RuntimeException {
    private HttpStatus status;
    public ProviderException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
