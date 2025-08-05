/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address;

import lombok.Data;
import org.springframework.http.HttpStatus;

@Data
/*
  @author kuldeep
 */
public class AddressException extends RuntimeException {
    private HttpStatus status;

    public AddressException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
