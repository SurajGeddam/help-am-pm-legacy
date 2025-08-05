/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.dtos;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.helpampm.auth.entities.RefreshToken;
import com.helpampm.common.StringUtils;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */ public class RefreshTokenDto implements Serializable {
    private long id;
    private boolean isUsed;
    private String token;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime expiryDate;

    public static RefreshTokenDto buildWithRefreshToken(RefreshToken refreshToken) {
        return RefreshTokenDto.builder()
                .withToken(refreshToken.getToken())
                .withId(refreshToken.getId())
                .withIsUsed(StringUtils.setDefaultBoolean(refreshToken.getIsUsed()))
                .withExpiryDate(refreshToken.getExpiryDate()).build();

    }
}