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
public class ChangePasswordPayload {
    private String username;
    private String oldPassword;
    private String newPassword;
}
