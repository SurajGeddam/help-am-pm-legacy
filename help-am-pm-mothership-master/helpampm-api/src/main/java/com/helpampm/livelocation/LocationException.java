/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.livelocation;

import lombok.Data;
import org.springframework.http.HttpStatus;

/**
 * @author kuldeep
 */

@Data
public class LocationException extends RuntimeException {
    private HttpStatus status;
    public LocationException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
