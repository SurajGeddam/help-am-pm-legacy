/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import lombok.Builder;
import lombok.Data;
import org.springframework.http.HttpStatus;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class StartWorkResponse {
    private String message;
    private HttpStatus status;
}
