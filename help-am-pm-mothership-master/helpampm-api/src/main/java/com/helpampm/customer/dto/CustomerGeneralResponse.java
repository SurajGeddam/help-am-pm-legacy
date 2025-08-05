/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.customer.dto;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@Data
@Builder(setterPrefix = "with")
public class CustomerGeneralResponse {
    private int status;
    private String message;
    private byte[] profilePath;
}
