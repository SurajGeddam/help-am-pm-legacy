/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.dtos;

import com.helpampm.auth.entities.RefreshToken;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class CredentialsPayload {
    private RefreshToken refreshToken;
    private String username;
    private String password;
}
