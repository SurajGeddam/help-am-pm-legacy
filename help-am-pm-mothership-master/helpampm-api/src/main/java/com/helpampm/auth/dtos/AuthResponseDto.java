/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.dtos;


import com.fasterxml.jackson.annotation.JsonFormat;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class AuthResponseDto {
    private String token;
    private RefreshTokenDto refreshToken;
    private String username;
    private String completedPage;
    private String role;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime expiryDate;
    private boolean accountSetupCompleted;
    private boolean stripeSetupDone;
    private UserDetailsDto userDetailsDto;
    private List<Character> categories;
}
