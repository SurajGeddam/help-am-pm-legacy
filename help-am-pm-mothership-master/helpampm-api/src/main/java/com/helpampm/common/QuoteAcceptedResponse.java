/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.common;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

/**
 * @author kuldeep
 */
@SuppressFBWarnings({"EI_EXPOSE_REP", "EI_EXPOSE_REP2"})
@Data
@Builder(setterPrefix = "with")
public class QuoteAcceptedResponse {
    private int status;
    private String message;
    private byte[] profileImage;
}
