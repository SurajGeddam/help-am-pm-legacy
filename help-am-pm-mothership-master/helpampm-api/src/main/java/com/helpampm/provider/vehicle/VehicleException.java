/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.provider.vehicle;

import lombok.Data;
import org.springframework.http.HttpStatus;

/**
 * @author kuldeep
 */
@Data
public class VehicleException extends RuntimeException {
    private HttpStatus status;
    public VehicleException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
