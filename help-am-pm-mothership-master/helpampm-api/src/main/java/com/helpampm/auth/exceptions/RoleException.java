/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.exceptions;

import lombok.Data;
import org.springframework.http.HttpStatus;

@Data
/*
  @author kuldeep
 */
public class RoleException extends RuntimeException {
    private HttpStatus status;

    public RoleException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }
}
