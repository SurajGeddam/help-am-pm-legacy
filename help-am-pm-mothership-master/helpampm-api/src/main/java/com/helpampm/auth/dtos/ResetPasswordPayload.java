/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.dtos;

import lombok.Data;

@Data
/*
  @author kuldeep
 */
public class ResetPasswordPayload {
    private String username;
    private String password;
    private String otp;
}
