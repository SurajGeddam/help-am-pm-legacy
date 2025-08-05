/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.common;

import lombok.Builder;
import lombok.Data;

/**
 * @author kuldeep
 */
@Data
@Builder(setterPrefix = "with")
public class GeneralResponse {
    private int status;
    private String message;
}
